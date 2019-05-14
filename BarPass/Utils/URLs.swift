//
//  URLs.swift
//  Guardioes
//
//  Created by Bruno Lopes de Mello on 19/02/19.
//  Copyright © 2019 Bruno Lopes de Mello. All rights reserved.
//

import Foundation

enum URLs {
    static let baseUrl = "http://api.guardioes.megaleios.com"
    
    static var apiEndPoint : String {
        get {
            let value = "\(URLs.baseUrl)/api/v1"
            return value
        }
    }
    
    static var uploadsEndPoint : String {
        get {
            let value = "\(URLs.baseUrl)/content/upload"
            return value
        }
    }
    
    //main
    static let recover = ""
    
    //occurrences
    static let getOccurrences = "\(apiEndPoint)/Alert/GetNear"
    static let saveOccurrence = "\(apiEndPoint)/Alert/Save"
    static let deleteOccurrence = "\(apiEndPoint)/Alert/Delete"
    static let getOccurrencesByUser = "\(apiEndPoint)/Alert/GetByUser"
    static let getHelpedOccurrences = "\(apiEndPoint)/HelpSolicitation/GetAllMyAsHelper"
    
    //pet
    static let savePet = "\(apiEndPoint)/Pet/Save"
    static let deletePet = "\(apiEndPoint)/Pet/Delete"
    static let getPet = "\(apiEndPoint)/Pet/Details"
    static let getAllPets = "\(apiEndPoint)/Pet/GetAllMy/1/100"
    
    //profile
    static let signin = "\(apiEndPoint)/Profile/GetInfo"
    static let getUser = "\(apiEndPoint)/Profile/Detail"
    static let signup = "\(apiEndPoint)/Profile/Register"
    static let deleteUser = "\(apiEndPoint)/Profile/Delete"
    static let updateUser = "\(apiEndPoint)/Profile/Update"
    
    //Vehicle
    static let saveVehicle = "\(apiEndPoint)/Vehicle/Save"
    static let deleteVehicle = "\(apiEndPoint)/Vehicle/Delete"
    static let getVehicle = "\(apiEndPoint)/Vehicle/Details"
    static let getAllVehicles = "\(apiEndPoint)/Vehicle/GetAllMy/1/100"
    static let getAllBrands = "\(apiEndPoint)/Vehicle/GetAllBrand/1/100"
    static let getModelByBrand = "\(apiEndPoint)/Vehicle/GetModelByBrandId/1/100"
    
    //rating
    static let saveRating = "\(apiEndPoint)/Rating/Save"
    
    //helpSolicitation
    static let saveHelp = "\(apiEndPoint)/HelpSolicitation/Save"
    
    //Terms of use
    static let termsAndUse = "\(baseUrl)/content/termos-de-uso.html"
    
    //Privacy
    static let privacyPolicy = "\(baseUrl)/content/private-policy.html"
    
    //About Guardioes
    static let aboutGuardians = "\(baseUrl)/content/texto-institucional.html"
    
    //Suport
    static let supportContact = "\(apiEndPoint)/Support/Contact"
    
    //Emergency Contact
    static let saveContact = "\(apiEndPoint)/EmergencyContact/Save"
    static let deleteContact = "\(apiEndPoint)/EmergencyContact/Delete"
    static let getAllContacts = "\(apiEndPoint)/EmergencyContact/GetAccepted/1/100"
    static let getAllMeAsContact = "\(apiEndPoint)/EmergencyContact/GetMeAsContact"
    
    //Notifications
    static let getNotifications = "\(apiEndPoint)/Notifications/GetAllMy/1/100"
    static let acceptEmergencyContact = "\(apiEndPoint)/EmergencyContact/AcceptPermission"
    static let refuseEmergencyContact = "\(apiEndPoint)/EmergencyContact/RejectPermission"
    static let setAllUnreadToRead = "\(apiEndPoint)/Notifications/SetVisualized"
    static let deleteNotification = "\(apiEndPoint)/Notifications/Delete"
    
    //Chat
    static let getChatList = "\(apiEndPoint)/Message/GetByAlert/1/100"
    
    //OneSignal
    static let oneSignal = "\(apiEndPoint)/Profile/RegisterUnRegisterDeviceId"
    static let panicPush = "\(apiEndPoint)/EmergencyContact/SendPanicAlertNotification"
    static let chatPush = "\(apiEndPoint)/Message/SendNewMessage"
}
