//
//  InitialViewController.swift
//  BarPass
//
//  Created by Bruno Lopes on 27/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import Foundation
import UIKit
import SwiftyGif

class InitialViewController: UIViewController, Storyboarded {

    let logoAnimationView = LogoAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoAnimationView)
        logoAnimationView.logoGifImageView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
    }
}

extension InitialViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
    }
}
