//
//  SignUpTableViewController.swift
//  BarPass
//
//  Created by Bruno Lopes on 27/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit
import AudioToolbox
import Spring
import Realm
import RealmSwift

class SignUpTableViewController: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var checkButton: SpringButton!
    @IBOutlet weak var useAndTermsButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var viewModel: LoginViewModelProtocol!
    var facebookId: String?
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = LoginViewModel()
        realm = try! Realm()
        
        hideKeyboardWhenTappedAround()
        setUIElements()
    }
    
    func setUIElements() {
        let attributedString = NSMutableAttributedString(string: "Eu li e concordo com os Termos de Uso.", attributes: [
            .font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
            .foregroundColor: UIColor(white: 36.0 / 255.0, alpha: 1.0)
            ])
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .bold), range: NSRange(location: 24, length: 14))
        signUpButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    @IBAction func checkAction(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        if checkButton.isSelected {
            checkButton.isSelected = false
        } else {
            checkButton.isSelected = true
            checkButton.animation = "pop"
            checkButton.animate()
        }
    }
    
    @IBAction func concludeSignup(_ sender: Any) {
        if validateFields() == "" {
            
            let user = UserModel(password: passField.text,
                                 facebookID: facebookId, nickName: nil,
                                 phone: nil, gender: nil, sendSMS: nil, sendEmail: nil,
                                 notification: nil, codID: nil, premium: nil,
                                 fullName: nameField.text, email: emailField.text,
                                 photo: nil, cpf: nil, blocked: nil, id: nil)
            
            viewModel.createUser(user, onComplete: { [unowned self] tokenModel in
               
            }) { (msg) in
                GlobalAlert(with: self, msg: msg).showAlert()
            }
            
        } else {
            GlobalAlert(with: self, msg: validateFields()).showAlert()
        }
    }
    
    private func validateFields() -> String {
        
        var msg = ""
        
        if self.nameField.text == "" {
            msg = "Preencha nome"
        } else if self.emailField.text == "" {
            msg = "Preencha o email"
        } else if emailField.text == "" {
            msg = "Preencha o campo nome de usuário"
        } else if passField.text == "" {
            msg = "Preencha a senha"
        } else if confirmPassField.text == ""{
            msg = "Confirme a senha"
        } else if passField.text != confirmPassField.text {
            msg = "As senhas são diferentes"
        } else if !checkButton.isSelected {
            msg = "Aceite os Termos de Uso."
        }
        
        return msg
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
}
