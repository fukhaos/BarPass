//
//  Establishment.swift
//  BarPass
//
//  Created by Bruno Lopes on 04/06/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import Foundation

// MARK: - EstablishmentReturn
struct EstablishmentReturn: Codable {
    let data: [Establishment]?
    let erro: Bool?
    let errors: [String: String]?
    let message: String?
    let messageEx: String?
}

struct EstablishmentDetailReturn: Codable {
    let data: Establishment?
    let erro: Bool?
    let errors: [String: String]?
    let message: String?
    let messageEx: String?
}

// MARK: - Datum
struct Establishment: Codable {
    let name, login, operatingHours, description: String?
    let contactName: String?
    let type: String?
    let latitude: Double?
    let longitude: Double?
    let cnpj, phone, email: String?
    let photo: [String]?
    let fullAddress: String?
    let reason: String?
    let distance: Double?
    let discount: Int?
    let blocked: Bool?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case name, login, operatingHours
        case description = "description"
        case latitude, longitude
        case contactName, type, cnpj, phone, email, photo, fullAddress, reason, distance, blocked, id, discount
    }
}
