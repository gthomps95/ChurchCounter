//
//  Section.swift
//  ChurchCounter
//
//  Created by Greg Thompson on 8/24/17.
//  Copyright © 2017 Greg Thompson. All rights reserved.
//

import Foundation

class Section: NSObject, NSCoding {
    var rows: [Row]
    var name: String

    init(name: String) {
        self.name = name
        self.rows = [Row]()
    }

    func addRow(withCount count: Int) {
        let number = getNextRowNumber()
        rows.append(Row(forRowNumber: number, withCount: count))
    }

    func getTotal() -> Int {
        return rows.reduce(0) {
            (result, row) -> Int in

            return result + row.count
        }
    }

    func getNextRowNumber() -> Int {
        return rows.count + 1
    }

    required init(coder aCoder: NSCoder) {
        rows = aCoder.decodeObject(forKey: "rows") as! [Row]
        name = aCoder.decodeObject(forKey: "name") as! String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(rows, forKey: "rows")
        aCoder.encode(name, forKey: "name")
    }

}

extension Section {
    public static func ==(lhs: Section, rhs: Section) -> Bool {
        return lhs.name == rhs.name
    }
}
