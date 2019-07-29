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
    var realmModel: RealmUtilsProtocol!
    var facebookId: String?
    var googleId: String?
    var name: String?
    var email: String?
    weak var delegate: DidCompleteSignupDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = LoginViewModel()
        realmModel = RealmUtils()
        
        
        
        hideKeyboardWhenTappedAround()
        setUIElements()
    }
    
    func setUIElements() {
        let attributedString = NSMutableAttributedString(string: "Eu li e concordo com os Termos de Uso.", attributes: [
            .font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
            .foregroundColor: UIColor(white: 36.0 / 255.0, alpha: 1.0)
            ])
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .bold), range: NSRange(location: 24, length: 14))
        useAndTermsButton.setAttributedTitle(attributedString, for: .normal)
        
        if facebookId != nil || googleId != nil {
            guard let name = name else {return}
            guard let email = email else {return}
            
            nameField.text = name
            emailField.text = email
            emailField.isEnabled = false
            emailField.textColor = UIColor.lightGray
        }
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
            
            let user = UserCodable(password: passField.text,
                                 facebookID: facebookId, googleId: googleId, nickName: nil,
                                 phone: nil, gender: nil, sendSMS: nil, sendEmail: nil,
                                 notification: nil, codID: nil, premium: nil,
                                 fullName: nameField.text, email: emailField.text,
                                 photo: nil, cpf: nil, blocked: nil, linkedAccount: false, id: nil)
            
            viewModel.createUser(user, onComplete: { [unowned self] in
                let alert = UIAlertController(title: "Atenção", message: "Usuário cadastrado com sucesso",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [unowned self] _ in
                    self.navigationController?.popViewController(animated: true, completion: {
                        self.delegate.login()
                    })
                }))
                self.present(alert, animated: true, completion: nil)
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
        } else if !(self.emailField.text?.isValidEmail() ?? true){
            msg = "O email não é válido"
        } else if emailField.text == "" {
            msg = "Preencha o campo nome de usuário"
        } else if passField.text == "" {
            msg = "Preencha a senha"
        } else if confirmPassField.text == ""{
            msg = "Confirme a senha"
        } else if passField.text?.count ?? 6 < 6 {
            msg = "A senha deve ao menos ter 6 dígitos"
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
        return 5
    }
}
