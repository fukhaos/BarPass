//
//  RegisterReturn.swift
//  BarPass
//
//  Created by Bruno Lopes de Mello on 29/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import Foundation

// MARK: - RegisterReturn
struct RegisterReturn: Codable {
    let data: TokenCodable?
    let erro: Bool?
    let errors: [String: String]?
    let message: String?
    let messageEx: String?
}

// MARK: - DataClass
struct TokenCodable: Codable {
    let accessToken, refreshToken: String?
    let expiresIn: Int?
    let expires, expiresType: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case expires
        case expiresType = "expires_type"
    }
}
