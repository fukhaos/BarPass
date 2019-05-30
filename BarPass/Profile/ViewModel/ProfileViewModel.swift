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
}

class ProfileViewModel: ProfileViewModelProtocol {
    
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
