//
//  AttendanceStore.swift
//  ChurchCounter
//
//  Created by Greg Thompson on 8/24/17.
//  Copyright © 2017 Greg Thompson. All rights reserved.
//

import UIKit

class AttendanceStore: NSObject, UITableViewDataSource {
    var attendanceList = [Attendance]()
    let attendanceArchiveURL: URL = {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent("attendance.archive")
    }()

    override init() {
        if let archivedAttendance = NSKeyedUnarchiver.unarchiveObject(withFile: attendanceArchiveURL.path) as? [Attendance] {
            attendanceList = archivedAttendance
        }
    }

    @discardableResult func addAttendance(forDate date: Date) -> Attendance {
        let attendance = Attendance(date: date)
        attendanceList.append(attendance)
        return attendance
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendanceList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        let attendance = attendanceList[indexPath.row]

        cell.textLabel?.text = attendance.dateStr
        cell.detailTextLabel?.text = "\(attendance.getTotal())"
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            attendanceList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

    @discardableResult func saveChanges() -> Bool {
        return NSKeyedArchiver.archiveRootObject(attendanceList, toFile: attendanceArchiveURL.path)
    }
}
