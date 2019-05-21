//
//  Date+XT.swift
//  CodiceFiscale
//
//  Created by Luigi Aiello on 21/05/2019.
//

import Foundation

extension Date {
    static func from(string: String, withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }

    func formatted(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func components(_ calendarUnits: [Calendar.Component]) -> [Calendar.Component: Int] {
        var result: [Calendar.Component: Int] = [: ]
        for unit in calendarUnits {
            result[unit] = component(unit)
        }
        return result
    }

    func component(_ calendarUnit: Calendar.Component) -> Int {
        return Calendar.current.component(calendarUnit, from: self)
    }
}

internal extension Calendar.Component {
    func value(fromDate date: Date) -> Int {
        return date.component(self)
    }
}
