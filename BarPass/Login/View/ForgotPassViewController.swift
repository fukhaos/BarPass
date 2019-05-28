//
//  ForgotPassViewController.swift
//  BarPass
//
//  Created by Bruno Lopes de Mello on 28/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit

class ForgotPassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
