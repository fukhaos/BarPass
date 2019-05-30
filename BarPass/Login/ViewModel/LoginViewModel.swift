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
    func createUser(_ user: UserCodable, onComplete: @escaping (TokenCodable) -> Void,
                    onError: @escaping (_ message: String) -> Void)
    func forgotPassword(_ email: String, onComplete: @escaping () -> Void,
                    onError: @escaping (_ message: String) -> Void)
}

class LoginViewModel: LoginViewModelProtocol {
    
    
    /// Create a new user
    ///
    /// - Parameters:
    ///   - user: <#user description#>
    ///   - onComplete: <#onComplete description#>
    ///   - onError: <#onError description#>
    func createUser(_ user: UserCodable, onComplete: @escaping (TokenCodable) -> Void,
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
                                    onComplete(tokenCodable)
                                    return
                                }
                                
                                onError("Objeto vazio")
        }) { (response, msg) in
            SVProgressHUD.dismiss()
            onError(msg)
        }
    }
    
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
        }) { (response, msg) in
            SVProgressHUD.dismiss()
            onError(msg)
        }
    }
    
}
