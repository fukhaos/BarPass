//
//  User.swift
//  BarPass
//
//  Created by Bruno Lopes on 30/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class User: Object {
    @objc dynamic var password, facebookID, nickName, phone: String?
    @objc dynamic var gender: String?
    @objc dynamic var sendSMS = false
    @objc dynamic var sendEmail = false
    @objc dynamic var notification = false
    @objc dynamic var codID: String?
    @objc dynamic var premium = false
    @objc dynamic var linkedAccount = false
    @objc dynamic var fullName, email, photo, cpf: String?
    @objc dynamic var blocked = false
    @objc dynamic var id: String?
}
