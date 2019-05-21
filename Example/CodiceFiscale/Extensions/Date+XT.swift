//
//  Date+XT.swift
//  CodiceFiscale_Example
//
//  Created by Luigi Aiello on 21/05/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

extension Date {
    public static func from(string: String, withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }

    public func localizedString(dateWithStyle style: DateFormatter.Style) -> String {
        return localizedString(withDateStyle: style, timeStyle: .none)
    }

    public func localizedString(timeWithStyle style: DateFormatter.Style) -> String {
        return localizedString(withDateStyle: .none, timeStyle: style)
    }

    public func localizedString(withDateStyle dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = dateStyle

        dateFormatter.timeStyle = timeStyle

        return dateFormatter.string(from: self)
    }
}
