//
//  DateFormaterExtension.swift
//  Guardioes
//
//  Created by Bruno Lopes de Mello on 25/02/19.
//  Copyright © 2019 Bruno Lopes de Mello. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = NSTimeZone.local
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = NSTimeZone.local
        formatter.locale = Locale.current
        return formatter
    }()
    
}
