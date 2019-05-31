//
//  URLs.swift
//  Guardioes
//
//  Created by Bruno Lopes de Mello on 19/02/19.
//  Copyright © 2019 Bruno Lopes de Mello. All rights reserved.
//

import Foundation

enum URLs {
    static let baseUrl = "http://api.barpass.dev.megaleios.com"
    
    static var apiEndPoint : String {
        get {
            let value = "\(URLs.baseUrl)/api/v1"
            return value
        }
    }
    
    static var uploadsEndPoint : String {
        get {
            let value = "\(apiEndPoint)/File/Upload"
            return value
        }
    }
    
    //profile
    static let signin = "\(apiEndPoint)/Profile/Token"
    static let getInfo = "\(apiEndPoint)/Profile/GetInfo"
    static let getUser = "\(apiEndPoint)/Profile/Detail"
    static let signup = "\(apiEndPoint)/Profile/Register"
    static let forgotPass = "\(apiEndPoint)/Profile/ForgotPassword"
    static let deleteUser = "\(apiEndPoint)/Profile/Delete"
    static let updateUser = "\(apiEndPoint)/Profile/Update"
    
    //Indication
    static let indicate = "\(apiEndPoint)/Indication/IndicateEstablishment"
    
    //rating
    static let saveRating = "\(apiEndPoint)/Rating/Save"
    
    //Terms of use
    static let termsAndUse = "\(baseUrl)/content/termos-de-uso.html"
    
    //Privacy
    static let privacyPolicy = "\(baseUrl)/content/private-policy.html"
    
    //About BarPass
    static let aboutGuardians = "\(baseUrl)/content/texto-institucional.html"
    
    //Suport
    static let supportContact = "\(apiEndPoint)/Support/Contact"
    
    //Notifications
    static let getNotifications = "\(apiEndPoint)/Notifications/GetAllMy/1/100"
    static let acceptEmergencyContact = "\(apiEndPoint)/EmergencyContact/AcceptPermission"
    static let refuseEmergencyContact = "\(apiEndPoint)/EmergencyContact/RejectPermission"
    static let setAllUnreadToRead = "\(apiEndPoint)/Notifications/SetVisualized"
    static let deleteNotification = "\(apiEndPoint)/Notifications/Delete"
    
    //OneSignal
    static let oneSignal = "\(apiEndPoint)/Profile/RegisterUnRegisterDeviceId"
    static let panicPush = "\(apiEndPoint)/EmergencyContact/SendPanicAlertNotification"
    static let chatPush = "\(apiEndPoint)/Message/SendNewMessage"
}
