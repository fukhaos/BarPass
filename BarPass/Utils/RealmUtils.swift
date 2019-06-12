//
//  RealmUtils.swift
//  BarPass
//
//  Created by Bruno Lopes on 30/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol RealmUtilsProtocol {
    
    var realm: Realm? {get set}
    
    func save(_ user: UserCodable, onComplete: @escaping () -> Void,
              onError: @escaping (_ msg: String) -> Void)
    func save(_ token: TokenCodable, onComplete: @escaping () -> Void,
              onError: @escaping (_ msg: String) -> Void)
    func getUser() -> User
    func getToken() -> Token
}

class RealmUtils: RealmUtilsProtocol {
    
    var realm: Realm?
    
    init() {
        realm = try! Realm()
    }
    
    
    func save(_ user: UserCodable, onComplete: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let userRealm = User()
        userRealm.password = user.password
        userRealm.facebookID = user.facebookID
        userRealm.nickName = user.nickName
        userRealm.phone = user.phone
        userRealm.gender = user.gender
        userRealm.sendSMS = user.sendSMS ?? false
        userRealm.sendEmail = user.sendEmail ?? false
        userRealm.notification = user.notification ?? false
        userRealm.codID = user.codID
        userRealm.premium = user.premium ?? false
        userRealm.fullName = user.fullName
        userRealm.email = user.email
        userRealm.photo = user.photo
        userRealm.cpf = user.cpf
        userRealm.linkedAccount = user.linkedAccount ?? false
        userRealm.blocked = user.blocked ?? false
        userRealm.id = user.id
        
        try! realm?.safeWrite {
            realm?.delete((realm?.objects(User.self))!)
            realm?.add(userRealm)
            onComplete()
        }
    }
    
    func save(_ token: TokenCodable, onComplete: @escaping () -> Void, onError: @escaping (String) -> Void) {
        let tokenRealm = Token()
        tokenRealm.accessToken = token.accessToken
        tokenRealm.refreshToken = token.refreshToken
        tokenRealm.expiresIn = token.expiresIn ?? 0
        tokenRealm.expires = token.expires
        tokenRealm.expiresType = token.expiresType
        
        try! realm?.safeWrite {
            realm?.delete((realm?.objects(Token.self))!)
            realm?.add(tokenRealm)
            onComplete()
        }
    }
    
    func getUser() -> User {
        return realm?.objects(User.self).last ?? User()
    }
    
    func getToken() -> Token {
        return realm?.objects(Token.self).last ?? Token()
    }
}
