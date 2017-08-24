//
//  Row.swift
//  ChurchCounter
//
//  Created by Greg Thompson on 8/24/17.
//  Copyright © 2017 Greg Thompson. All rights reserved.
//

import Foundation

class Row: NSObject, NSCoding {
    var number: Int
    var count: Int

    init(forRowNumber number: Int, withCount count: Int) {
        self.number = number
        self.count = count
    }

    required init(coder aCoder: NSCoder) {
        number = aCoder.decodeInteger(forKey: "number")
        count = aCoder.decodeInteger(forKey: "count")
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(number, forKey: "number")
        aCoder.encode(count, forKey: "count")
    }
}
