//
//  IndicatePubViewController.swift
//  BarPass
//
//  Created by Bruno Lopes on 31/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit

class IndicatePubViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
