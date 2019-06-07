//
//  Address.swift
//  BarPass
//
//  Created by Bruno Lopes on 07/06/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import Foundation

struct AddressReturn: Codable {
    let data: Address?
    let erro: Bool?
    let message, messageEx: String?
}

// MARK: - DataClass
struct Address: Codable {
    let formatedAddress, street, number, state: String?
    let city, country, postalCode, neighborhood: String?
}
