//
//  EstablishmentViewModel.swift
//  BarPass
//
//  Created by Bruno Lopes on 04/06/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import Foundation
import SVProgressHUD

protocol EstablishmentViewModelProtocol {
    func getStabs(onComplete: @escaping ([Establishment]) -> Void,
                  onError: @escaping (_ msg: String) -> Void)
    func getStabDetail(with id: String, onComplete: @escaping (Establishment) -> Void,
                       onError: @escaping (_ msg: String) -> Void)
}

class EstablishmentViewModel: EstablishmentViewModelProtocol {
    
    func getStabs(onComplete: @escaping ([Establishment]) -> Void,
                  onError: @escaping (String) -> Void) {
        
        SVProgressHUD.show()
        Api().requestCodable(metodo: .wGET, url: URLs.getStabs, objeto: EstablishmentReturn.self,
                             parametros: [:],
                             onSuccess: { (response, result) in
                                SVProgressHUD.dismiss()
                                
                                if result.erro ?? false {
                                    onError(result.message ?? "")
                                    return
                                }
                                
                                onComplete(result.data ?? [Establishment]())
                                
        }) { (response, msg) in
            SVProgressHUD.dismiss()
            onError(msg)
        }
    }
    
    func getStabDetail(with id: String, onComplete: @escaping (Establishment) -> Void,
                       onError: @escaping (String) -> Void) {
        SVProgressHUD.show()
        Api().requestCodable(metodo: .wGET, url: "\(URLs.getEstabDetail)/\(id)", objeto: EstablishmentDetailReturn.self,
                             parametros: [:],
                             onSuccess: { (response, result) in
                                SVProgressHUD.dismiss()
                                
                                if result.erro ?? false {
                                    onError(result.message ?? "")
                                    return
                                }
                                
                                onComplete(result.data!)
                                
        }) { (response, msg) in
            SVProgressHUD.dismiss()
            onError(msg)
        }
    }
}
