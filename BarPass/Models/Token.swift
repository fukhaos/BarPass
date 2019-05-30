//
//  Token.swift
//  BarPass
//
//  Created by Bruno Lopes on 30/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Token: Object {
    @objc dynamic var accessToken, refreshToken, expires, expiresType: String?
    @objc dynamic var expiresIn = 0
}
