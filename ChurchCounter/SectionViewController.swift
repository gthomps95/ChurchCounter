//
//  SectionViewController.swift
//  ChurchCounter
//
//  Created by Greg Thompson on 8/24/17.
//  Copyright © 2017 Greg Thompson. All rights reserved.
//

import UIKit

class SectionViewController: UITableViewController {
    var attendance: Attendance?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showSection"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let section = attendance?.sections[row]
                let rvc = segue.destination as! RowViewController
                rvc.section = section
            }
        default:
            print("Unexpected segue identifier \(segue.identifier ?? "nil").")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        title = "\(attendance?.dateStr ?? "")"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendance?.sections.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        let section = attendance?.sections[indexPath.row]

        cell.textLabel?.text = section?.name
        cell.detailTextLabel?.text = "\(section?.getTotal() ?? 0)"
        return cell
    }

    @IBAction func addSection(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Section", message: nil, preferredStyle: .alert)

        alertController.addTextField {
            (textField) -> Void in

            textField.placeholder = "name"
            textField.autocapitalizationType = .words
        }

        let okAction = UIAlertAction(title: "OK", style: .default) {
            (action) -> Void in

            if let name = alertController.textFields?.first?.text {
                let section = self.attendance?.addSection(forName: name)
                self.tableView.reloadData()

                let row = self.attendance?.sections.index(of: section!) ?? 0
                let ip = IndexPath(row: row, section: 0)
                self.tableView.selectRow(at: ip, animated: true, scrollPosition: .middle)
            }

            OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "showSection", sender: sender)
            }
        }

        alertController.addAction(okAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    @IBAction func toggleEdit(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            attendance?.sections.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
