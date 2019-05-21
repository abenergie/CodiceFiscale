//
//  String+XT.swift
//  CodiceFiscale
//
//  Created by Luigi Aiello on 21/05/2019.
//

import Foundation.NSString

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }

    subscript (position: Int) -> Character {
        return self[index(startIndex, offsetBy: position)]
    }

    var isValidFiscalCode: Bool {
        guard
            self.count > 0,
            self.count == 16
        else {
            return false
        }

        let pattern = "^[A-Z]{6}[A-Z0-9]{2}[A-Z][A-Z0-9]{2}[A-Z][A-Z0-9]{3}[A-Z]$"
        do {
            if try NSRegularExpression(pattern: pattern, options: .caseInsensitive).firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) == nil {
                return false
            }
        } catch {
            return false
        }

        return true
    }
}
