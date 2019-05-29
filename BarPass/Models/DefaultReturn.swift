//
//  DefaultReturn.swift
//  BarPass
//
//  Created by Bruno Lopes de Mello on 29/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import Foundation

struct DefaultReturn: Codable {
    let data: DataClass?
    let erro: Bool?
    let errors: [String: String]?
    let message, messageEx: String?
}

struct DataClass: Codable {
}
