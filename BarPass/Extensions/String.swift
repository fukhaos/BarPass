//
//  String.swift
//  Guardioes
//
//  Created by Bruno Lopes de Mello on 27/02/19.
//  Copyright © 2019 Bruno Lopes de Mello. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func fileName() -> String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
    
    func fullFileName() -> String {
        return "\(fileName()).\(fileExtension())"
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    mutating func swapAt(_ index1: Int, _ index2: Int) {
        var characters = Array(self)
        characters.swapAt(index1, index2)
        self = String(characters)
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeACall() {
//        if isValid(regex: .phone) {
//            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
//                if #available(iOS 10, *) {
//                    UIApplication.shared.open(url)
//                } else {
//                    UIApplication.shared.openURL(url)
//                }
//            }
//        }
        if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

extension StringProtocol {
    var isValidCPF: Bool {
        let numbers = compactMap({ Int(String($0)) })
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        func digitCalculator(_ slice: ArraySlice<Int>) -> Int {
            var number = slice.count + 2
            let digit = 11 - slice.reduce(into: 0) {
                number -= 1
                $0 += $1 * number
                } % 11
            return digit > 9 ? 0 : digit
        }
        let dv1 = digitCalculator(numbers.prefix(9))
        let dv2 = digitCalculator(numbers.prefix(10))
        return dv1 == numbers[9] && dv2 == numbers[10]
    }
}
