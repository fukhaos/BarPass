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
        let userLocation = LocationService.sharedInstance.locationManager?.location?.coordinate
        
        let params: [String: Any] = [
            "latitude": userLocation?.latitude ?? 0.0,
            "longitude": userLocation?.longitude ?? 0.0
        ]
        
        SVProgressHUD.show()
        Api().requestCodable(metodo: .wPOST, url: URLs.getStabs, objeto: EstablishmentReturn.self,
                             parametros: params,
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
        
        let userLocation = LocationService.sharedInstance.locationManager?.location?.coordinate
        
        let params: [String: Any] = [
            "latitude": userLocation?.latitude ?? 0.0,
            "longitude": userLocation?.longitude ?? 0.0,
            "id": id
        ]
        
        SVProgressHUD.show()
        Api().requestCodable(metodo: .wPOST, url: URLs.getEstabDetail, objeto: EstablishmentDetailReturn.self,
                             parametros: params,
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
