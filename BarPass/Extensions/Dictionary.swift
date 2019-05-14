//
//  Dictionary.swift
//  Guardioes
//
//  Created by Bruno Lopes de Mello on 27/02/19.
//  Copyright © 2019 Bruno Lopes de Mello. All rights reserved.
//

import Foundation

extension Dictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
    
}
