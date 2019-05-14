//
//  Utils.swift
//  Guardioes
//
//  Created by Bruno Lopes de Mello on 07/02/19.
//  Copyright © 2019 Bruno Lopes de Mello. All rights reserved.
//

import Foundation
import SystemConfiguration

class Utils {
    
    static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
    
    class func string(toStringData stringDate: String?, withFormat format: String?) -> String? {
        var format = format
        
        if stringDate == nil {
            return " "
        }
        if stringDate?.isEmpty ?? false {
            return " "
        }
        
        let dateType: Date? = self.getDateFrom(stringDate)
        
        if format == nil {
            format = "yyyy/MM/dd"
        }
        
        let dateString = self.data(toString: dateType, withFormat: format)
        return dateString
    }
    
    class func string(toStringData stringDate: String?, fromFormat formatIn: String?, toFormat format: String?) -> String? {
        let stringDate = stringDate
        let formatIn = formatIn
        
        if stringDate == nil {
            return " "
        }
        if stringDate?.isEmpty ?? false {
            return " "
        }
        
        //proteção contra o horário de verão 18/10/2015 formato dd/MM/yyyy
//        if !(formatIn?.contains("HH:mm:ss") ?? false) {
//            formatIn = "\(formatIn ?? "")-HH:mm:ss"
//            stringDate = "\(stringDate ?? "")-06:00:00"
//        }
        
        let df = DateFormatter()
        var retorno: Date?
        df.dateFormat = formatIn ?? ""
        df.locale = NSLocale(localeIdentifier: "pt") as Locale
        df.timeZone = NSTimeZone.default
        retorno = df.date(from: stringDate ?? "")
        
        let dateString = self.data(toString: retorno, withFormat: format)
        return dateString
    }
    
    class func getDateFrom(_ dateString: String?) -> Date? {
        var dateString = dateString
        let df = DateFormatter()
        var retorno: Date?
        if (dateString?.count ?? 0) == 8 {
            //proteção contra o horário de verão 18/10/2015 formato dd/MM/yyyy
            df.dateFormat = "dd/MM/yy-HH:mm:ss"
            dateString = "\(dateString ?? "")-06:00:00"
            df.locale = NSLocale(localeIdentifier: "pt") as Locale
            df.timeZone = NSTimeZone.default
            retorno = df.date(from: dateString ?? "")
        } else {
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            df.locale = NSLocale(localeIdentifier: "pt") as Locale
            df.timeZone = NSTimeZone.default
            // força um horário para que a data sempre seja convertida de yyyy-MM-dd para yyyy-MM-dd HH:mm:ss
            let date = "\(dateString ?? "") 12:00:00"
            retorno = df.date(from: date)
        }
        return retorno
    }
    
    class func data(toString fromDateTime: Date?, withFormat format: String?) -> String? {
        var format = format
        let dataFormatada = DateFormatter()
        
        if format == nil {
            format = "dd/MM/yyyy"
        }
        
        dataFormatada.dateFormat = format ?? ""
        var data: String? = nil
        if let fromDateTime = fromDateTime {
            data = dataFormatada.string(from: fromDateTime)
        }
        
        return data
    }
    
    class func convert(toTimeStamp value: String) -> Int64? {
        
        let formatedDate = self.string(toStringData: value, fromFormat: "dd/MM/yyyy HH:mm", toFormat: "yyyy-MM-dd HH:mm")
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = dfmatter.date(from: formatedDate ?? "") {
            let dateStamp:TimeInterval = date.timeIntervalSince1970
            let dateSt:Int64 = Int64(dateStamp)
            return dateSt
        }
        
        return nil
    }
    
    class func converTo(date timestamp: Int64) -> Date {
        let date = Date(timeIntervalSince1970: TimeInterval(exactly: timestamp) ?? TimeInterval(Int64()))
        return date
    }
    
}
