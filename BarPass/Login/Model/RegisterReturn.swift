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
    let data: TokenModel?
    let erro: Bool?
    let errors: JSONNull?
    let message: String?
    let messageEx: JSONNull?
}

// MARK: - DataClass
struct TokenModel: Codable {
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
