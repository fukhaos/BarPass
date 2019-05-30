//
//  LoginViewModel.swift
//  BarPass
//
//  Created by Bruno Lopes de Mello on 29/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import Foundation
import SVProgressHUD

protocol LoginViewModelProtocol {
    var realmModel: RealmUtilsProtocol? {get set}
    
    func createUser(_ user: UserCodable, onComplete: @escaping () -> Void,
                    onError: @escaping (_ message: String) -> Void)
    func forgotPassword(_ email: String, onComplete: @escaping () -> Void,
                    onError: @escaping (_ message: String) -> Void)
    func signInWith(_ email: String, and password: String, onComplete: @escaping (TokenCodable) -> Void,
                        onError: @escaping (_ message: String) -> Void)
}

class LoginViewModel: LoginViewModelProtocol {
    
    var realmModel: RealmUtilsProtocol?
    
    init() {
        realmModel = RealmUtils()
    }
    
    /// Create a new user
    ///
    /// - Parameters:
    ///   - user: <#user description#>
    ///   - onComplete: <#onComplete description#>
    ///   - onError: <#onError description#>
    func createUser(_ user: UserCodable, onComplete: @escaping () -> Void,
                    onError: @escaping (String) -> Void) {
        
        var parameters: [String: Any] = [
            "password" : user.password ?? "",
            "fullName" : user.fullName ?? "",
            "email" : user.email ?? ""
        ]
        
        if user.facebookID != "" && user.facebookID != nil {
            parameters["facebookId"] = user.facebookID ?? ""
        }
        
        SVProgressHUD.show()
        Api().requestCodable(metodo: .wPOST, url: URLs.signup, objeto: RegisterReturn.self, parametros: parameters,
                             onSuccess: { (response, result) in
                                SVProgressHUD.dismiss()
                                if result.erro ?? false {
                                    onError(result.message ?? "")
                                    return
                                }
                                if let tokenCodable = result.data {
                                    self.realmModel?.save(tokenCodable,
                                                             onComplete: {
                                                                self.realmModel?.save(user,
                                                                                     onComplete: {
                                                                                        onComplete()
                                                                }, onError: { (msg) in
                                                                    onError(msg)
                                                                })
                                        }, onError: { (msg) in
                                            onError(msg)
                                        })
                                    return
                                }
                                
                                onError("Objeto vazio")
        }) { (response, msg) in
            SVProgressHUD.dismiss()
            onError(msg)
        }
    }
    
    
    /// forgot pass
    ///
    /// - Parameters:
    ///   - email: <#email description#>
    ///   - onComplete: <#onComplete description#>
    ///   - onError: <#onError description#>
    func forgotPassword(_ email: String,
                        onComplete: @escaping () -> Void,
                        onError: @escaping (String) -> Void) {
        
        let parameters: [String: Any] = [
            "email" : email
        ]
        
        SVProgressHUD.show()
        Api().requestCodable(metodo: .wPOST, url: URLs.signup, objeto: RegisterReturn.self, parametros: parameters,
                             onSuccess: { (response, result) in
                                SVProgressHUD.dismiss()
                                if result.erro ?? false {
                                    onError(result.message ?? "")
                                    return
                                }
                                
                                onComplete()
        }) { (response, msg) in
            SVProgressHUD.dismiss()
            onError(msg)
        }
    }
    
    
    /// Normal login using email and password
    ///
    /// - Parameters:
    ///   - email: <#email description#>
    ///   - password: <#password description#>
    ///   - onComplete: <#onComplete description#>
    ///   - onError: <#onError description#>
    func signInWith(_ email: String, and password: String,
                    onComplete: @escaping (TokenCodable) -> Void,
                    onError: @escaping (String) -> Void) {
        let parameters: [String: Any] = [
            "email" : email,
            "password" : password
        ]
        
        SVProgressHUD.show()
        Api().requestCodable(metodo: .wPOST, url: URLs.signin, objeto: RegisterReturn.self, parametros: parameters,
                             onSuccess: { (response, result) in
                                SVProgressHUD.dismiss()
                                if result.erro ?? false {
                                    onError(result.message ?? "")
                                    return
                                }
                                
                                if let tokenCodable = result.data {
                                    onComplete(tokenCodable)
                                    return
                                }
                                
                                onError("Imposível obeter um token!")
        }) { (response, msg) in
            SVProgressHUD.dismiss()
            onError(msg)
        }
    }
}
