//
//  ForgotPassViewController.swift
//  BarPass
//
//  Created by Bruno Lopes de Mello on 28/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPassViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var viewModel: LoginViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        viewModel = LoginViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func send(_ sender: Any) {
        if emailField.text != "" {
            viewModel.forgotPassword(emailField.text ?? "",
                                     onComplete: {
                                        GlobalAlert(with: self, msg: "Uma mensagem foi enviado para seu email").showAlertAndReturn()
            }) { (msg) in
                GlobalAlert(with: self, msg: msg).showAlert()
            }
        } else {
            GlobalAlert(with: self, msg: "Preencha o campo email").showAlert()
        }
    }
}
