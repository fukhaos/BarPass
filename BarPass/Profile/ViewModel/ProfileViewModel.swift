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
    func uploadPic(with image: UIImage,
                   onComplete: @escaping (_ fileName: String) -> Void,
                   onError: @escaping (_ message: String) -> Void)
    func updateUserPhoto(with fileName: String,
                         onComplete: @escaping () -> Void,
                   onError: @escaping (_ message: String) -> Void)
    func updateUser(_ user: User,
                         onComplete: @escaping () -> Void,
                         onError: @escaping (_ message: String) -> Void)
    func updatePass(_ oldPass: String, _ newPass: String,
                    onComplete: @escaping (_ message: String) -> Void,
                    onError: @escaping (_ message: String) -> Void)
    func getAddress(_ lat: Double, _ long: Double,
                    onComplete: @escaping (Address) -> Void,
                    onError: @escaping (_ message: String) -> Void)
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

    func getInfo(onComplete: @escaping (UserCodable) -> Void,
                 onError: @escaping (String) -> Void) {
        let parameters: [String: Any] = [:]
        
        SVProgressHUD.show()
        Api().requestCodable(metodo: .wGET, url: URLs.getInfo, objeto: InfoReturn.self, parametros: parameters,
                             onSuccess: { (response, result) in
                                SVProgressHUD.dismiss()
                                if result.erro ?? false {
                                    onError(result.message ?? "")
                                    return
                                }
                                
                                if let user = result.data {
                                    onComplete(user)
                                    return
                                }
                                
                                onError("Não foi possível concluir o procedimento, tente novamente")
        }) { (response, msg) in
            SVProgressHUD.dismiss()
            onError(msg)
        }
    }
    
    func uploadPic(with image: UIImage, onComplete: @escaping (_ fileName: String) -> Void,
                   onError: @escaping (String) -> Void) {
        
        SVProgressHUD.show()
        Api().uploadImage(image, onSuccess: { (imageData) in
            SVProgressHUD.dismiss()
            if let json = imageData, let fileName = json.fileName {
                onComplete(fileName)
                return
            }
            onError("ERRO")
        }) { (error) in
            SVProgressHUD.dismiss()
            onError(error.localizedDescription)
        }
    }
    
    func updateUserPhoto(with fileName: String, onComplete: @escaping () -> Void,
                         onError: @escaping (String) -> Void) {
        
        let parameters: [String: Any] = [
            "photo": fileName
        ]
        
        SVProgressHUD.show()
        Api().requestCodable(metodo: .wPOST, url: URLs.updateUserPic, objeto: InfoReturn.self, parametros: parameters,
                             onSuccess: { (response, result) in
                                SVProgressHUD.dismiss()
                                if result.erro ?? false {
                                    onError(result.message ?? "")
                                    return
                                }
                                
                                
                                if let user = result.data {
                                    
                                    RealmUtils().save(user,
                                                      onComplete: {
                                                    onComplete()
                                    }, onError: { (msg) in
                                        SVProgressHUD.dismiss()
                                        onError(msg)
                                    })
                                }
        }) { (response, msg) in
            SVProgressHUD.dismiss()
            onError(msg)
        }
    }
    
    func updateUser(_ user: User,
                    onComplete: @escaping () -> Void, onError: @escaping (String) -> Void) {
        
        var parameters: [String: Any] = [
            "sendSMS": user.sendSMS,
            "sendEmail": user.sendEmail,
            "notification": user.notification,
            "fullName": user.fullName ?? "",
            "email": user.email ?? "",
        ]
        
        if !user.linkedAccount && user.photo != "" {
            parameters["photo"] = user.photo ?? ""
        }
        
        SVProgressHUD.show()
        Api().requestCodable(metodo: .wPOST, url: URLs.updateUser, objeto: InfoReturn.self, parametros: parameters,
                             onSuccess: { (response, result) in
                                SVProgressHUD.dismiss()
                                if result.erro ?? false {
                                    onError(result.message ?? "")
                                    return
                                }
                                
                                
                                if let user = result.data {
                                    
                                    RealmUtils().save(user,
                                                      onComplete: {
                                                        onComplete()
                                    }, onError: { (msg) in
                                        SVProgressHUD.dismiss()
                                        onError(msg)
                                    })
                                }
        }) { (response, msg) in
            SVProgressHUD.dismiss()
            onError(msg)
        }
    }
    
    func updatePass(_ oldPass: String, _ newPass: String,
                    onComplete: @escaping (String) -> Void, onError: @escaping (String) -> Void) {
        
        let parameters: [String: Any] = [
            "currentPassword": oldPass,
            "newPassword": newPass
        ]
        
        SVProgressHUD.show()
        Api().requestCodable(metodo: .wPOST, url: URLs.changePass, objeto: DefaultReturn.self, parametros: parameters,
                             onSuccess: { (response, result) in
                                SVProgressHUD.dismiss()
                                if result.erro ?? false {
                                    onError(result.message ?? "")
                                    return
                                }
                                
                                onComplete(result.message ?? "Senha atualziada com sucesso!")
        }) { (response, msg) in
            SVProgressHUD.dismiss()
            onError(msg)
        }
    }
    
    func getAddress(_ lat: Double, _ long: Double,
                    onComplete: @escaping (Address) -> Void, onError: @escaping (String) -> Void) {
        let parameters: [String: Any] = [
            "latitude": lat,
            "longitude": long
        ]
        
        SVProgressHUD.show()
        Api().requestCodable(metodo: .wPOST, url: URLs.getAddress, objeto: AddressReturn.self, parametros: parameters,
                             onSuccess: { (response, result) in
                                SVProgressHUD.dismiss()
                                if result.erro ?? false {
                                    onError(result.message ?? "")
                                    return
                                }
                                
                                if let address = result.data {
                                    onComplete(address)
                                    return
                                }
                                
                                onError("Não foi possível obter a localização")
        }) { (response, msg) in
            SVProgressHUD.dismiss()
            onError(msg)
        }
    }
}
