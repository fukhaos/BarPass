//
//  ProfileViewModel.swift
//  BarPass
//
//  Created by Bruno Lopes on 30/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import Foundation
import SVProgressHUD

protocol ProfileViewModelProtocol {
    func getInfo(onComplete: @escaping (UserCodable) -> Void,
                    onError: @escaping (_ message: String) -> Void)
    func indicatePub(pub: [String: Any], onComplete: @escaping (_ msg: String) -> Void,
                     onError: @escaping (_ msg: String) -> Void)
}

class ProfileViewModel: ProfileViewModelProtocol {
    
    func indicatePub(pub: [String: Any], onComplete: @escaping (String) -> Void,
                     onError: @escaping (String) -> Void) {
        
        let parameters: [String: Any] = pub
        
        SVProgressHUD.show()
        Api().requestCodable(metodo: .wPOST, url: URLs.indicate, objeto: DefaultReturn.self, parametros: parameters,
                             onSuccess: { (response, result) in
                                SVProgressHUD.dismiss()
                                if result.erro ?? false {
                                    onError(result.message ?? "")
                                    return
                                }
                                
                                onComplete(result.message ?? "")
        }) { (response, msg) in
            SVProgressHUD.dismiss()
            onError(msg)
        }
    }

    func getInfo(onComplete: @escaping (UserCodable) -> Void, onError: @escaping (String) -> Void) {
        let parameters: [String: Any] = [:]
        
        SVProgressHUD.show()
        Api().requestCodable(metodo: .wPOST, url: URLs.getInfo, objeto: InfoReturn.self, parametros: parameters,
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
