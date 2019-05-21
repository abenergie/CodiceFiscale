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
}
