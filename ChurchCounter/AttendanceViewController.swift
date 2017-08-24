//
//  AttendanceViewController.swift
//  ChurchCounter
//
//  Created by Greg Thompson on 8/24/17.
//  Copyright © 2017 Greg Thompson. All rights reserved.
//

import UIKit

class AttendanceViewController: UITableViewController {
    var attendanceStore: AttendanceStore?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let store = attendanceStore {
            tableView.dataSource = store
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "newAttendance"?:
            let attendance = attendanceStore?.addAttendance(forDate: Date())
            let svc = segue.destination as! SectionViewController
            svc.attendance = attendance
        case "showAttendance"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let attendance = attendanceStore?.attendanceList[row]
                let svc = segue.destination as! SectionViewController
                svc.attendance = attendance
            }
        default:
            print("Unexpected segue identifier \(segue.identifier ?? "nil").")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    @IBAction func toggleEditing(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
}
