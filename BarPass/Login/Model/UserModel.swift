//
//  UserModel.swift
//  BarPass
//
//  Created by Bruno Lopes de Mello on 29/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

// MARK: - UserModel
struct UserCodable: Codable {
    let password, facebookID, googleId, nickName, phone: String?
    let gender: String?
    let sendSMS, sendEmail, notification: Bool?
    let codID: String?
    let premium: Bool?
    let fullName, email, photo, cpf: String?
    let blocked: Bool?
    let linkedAccount: Bool?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case password
        case linkedAccount
        case facebookID = "facebookId"
        case googleId = "googleId"
        case nickName, phone, gender, sendSMS, sendEmail, notification
        case codID = "codId"
        case premium, fullName, email, photo, cpf, blocked, id
    }
}
