//
//  Helpers.swift
//  iGamesman
//
//  Created by Sina Dalir on 4/12/21.
//

import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start ..< end])
      }
}


func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
    var chars = Array(myString)     // gets an array of characters
    chars[index] = newChar
    let modifiedString = String(chars)
    return modifiedString
}
