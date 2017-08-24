//
//  Church.swift
//  ChurchCounter
//
//  Created by Greg Thompson on 8/24/17.
//  Copyright © 2017 Greg Thompson. All rights reserved.
//

import Foundation

class Attendance: NSObject, NSCoding {
    var sections: [Section]
    var date: Date

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    var dateStr: String {
        get {
            return "\(dateFormatter.string(from: date))"
        }
    }

    init(date: Date) {
        self.date = date
        sections = [Section]()
    }

    @discardableResult func addSection(forName name: String) -> Section {
        let section = Section(name: name)
        sections.append(section)
        return section
    }

    func getTotal() -> Int {
        return sections.reduce(0) {
            (result, section) in

            return result + section.getTotal()
        }
    }

    required init(coder aCoder: NSCoder) {
        sections = aCoder.decodeObject(forKey: "sections") as! [Section]
        date = aCoder.decodeObject(forKey: "date") as! Date
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(sections, forKey: "sections")
        aCoder.encode(date, forKey: "date")
    }
}
