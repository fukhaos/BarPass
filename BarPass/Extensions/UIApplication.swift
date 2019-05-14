//
//  UIApplication.swift
//  Guardioes
//
//  Created by Bruno Lopes de Mello on 19/03/19.
//  Copyright © 2019 Bruno Lopes de Mello. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
    class func getRootViewController() -> UIViewController? {
        let root = UIApplication.shared.keyWindow?.rootViewController
        if let presented = root?.presentedViewController {
            return presented
        } else {
            return root
        }
    }
    
    var topViewController: UIViewController?{
        if keyWindow?.rootViewController == nil{
            return keyWindow?.rootViewController
        }
        
        var pointedViewController = keyWindow?.rootViewController
        
        while  pointedViewController?.presentedViewController != nil {
            switch pointedViewController?.presentedViewController {
            case let navagationController as UINavigationController:
                pointedViewController = navagationController.viewControllers.last
            case let tabBarController as UITabBarController:
                pointedViewController = tabBarController.selectedViewController
            default:
                pointedViewController = pointedViewController?.presentedViewController
            }
        }
        return pointedViewController
    }
}
