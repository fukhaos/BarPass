//
//  DashTabBarController.swift
//  BarPass
//
//  Created by Bruno Lopes de Mello on 29/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit
import AudioToolbox
import Spring

class DashTabBarController: UITabBarController, UITabBarControllerDelegate {

    var viewModel: ProfileViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        UserDefaults.standard.set(true, forKey: "logged")
        viewModel = ProfileViewModel()
        viewModel.getInfo(onComplete: { (user) in
            RealmUtils().save(user, onComplete: {
            }, onError: { _ in})
        }) { _ in}
    }
    

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController == tabBarController.viewControllers?[2] {
//            present(QRCodeNavigationController.instantiate("QRCode"),
//                    animated: true, completion: nil)
//            return false
//        } else {
//            return true
//        }
//    }
}
