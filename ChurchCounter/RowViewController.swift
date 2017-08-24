//
//  RowViewController.swift
//  ChurchCounter
//
//  Created by Greg Thompson on 8/24/17.
//  Copyright © 2017 Greg Thompson. All rights reserved.
//

import UIKit

class RowViewController: UITableViewController {
    var section: Section?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = section?.name
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.section?.rows.count ?? 0) + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        if indexPath.row > (section?.rows.count ?? 0) - 1 {
            cell.textLabel?.text = "Total"
            cell.detailTextLabel?.text = "\(section?.getTotal() ?? 0)"
        } else {
            let row = section?.rows[indexPath.row]
            cell.textLabel?.text = "\(row?.number ?? 0)"
            cell.detailTextLabel?.text = "\(row?.count ?? 0)"
        }

        return cell
    }

    @IBAction func addRow(_ sender: UIBarButtonItem) {
        let nextRow = section?.getNextRowNumber() ?? 0
        let alertController = UIAlertController(title: "Add Row \(nextRow)", message: nil, preferredStyle: .alert)

        alertController.addTextField {
            (textField) -> Void in

            textField.placeholder = "count"
            textField.keyboardType = .numberPad
        }

        let okAction = UIAlertAction(title: "OK", style: .default) {
            (action) -> Void in

            if let countTxt = alertController.textFields?.first?.text,
                let count = Int(countTxt) {

                self.section?.addRow(withCount: count)
                self.tableView.reloadData()
            }

            OperationQueue.main.addOperation {
                self.addRow(sender)
            }
        }

        alertController.addAction(okAction)

        let cancelAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < section?.rows.count ?? 0,
            let row = section?.rows[indexPath.row] else {
            return
        }

        let alertController = UIAlertController(title: "Modify Row \(row.number)", message: nil, preferredStyle: .alert)

        alertController.addTextField {
            (textField) -> Void in

            textField.text = "\(row.count)"
            textField.placeholder = "count"
            textField.keyboardType = .numberPad
        }

        let okAction = UIAlertAction(title: "OK", style: .default) {
            (action) -> Void in

            if let countTxt = alertController.textFields?.first?.text,
                let count = Int(countTxt) {

                row.count = count
                self.tableView.reloadData()
            }
        }

        alertController.addAction(okAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func toggleEditing(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard indexPath.row < section?.rows.count ?? 0 else {
            return
        }

        if editingStyle == .delete {
            section?.rows.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
