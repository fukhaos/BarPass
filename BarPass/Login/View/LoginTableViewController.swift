//
//  LoginTableViewController.swift
//  BarPass
//
//  Created by Bruno Lopes on 24/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKCoreKit
import SVProgressHUD
import Spring
import AudioToolbox

class LoginTableViewController: UITableViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signInFaceButton: SpringButton!
    @IBOutlet weak var signInGmailButton: SpringButton!
    
    var viewModel: LoginViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = LoginViewModel()

        signInFaceButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        
        setUIElements()
        hideKeyboardWhenTappedAround()
    }
    
    private func setUIElements() {
        self.title = "Login"
        let attributedString = NSMutableAttributedString(string: "NÃO É CADASTRADO? CADASTRE-SE", attributes: [
            .font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
            .foregroundColor: UIColor(red: 73.0 / 255.0, green: 81.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0),
            .kern: 0.43
            ])
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 14.0, weight: .bold),
            .foregroundColor: UIColor(red: 253.0 / 255.0, green: 117.0 / 255.0, blue: 69.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 18, length: 11))
        
        signupButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func loginButtonClicked() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        signInFaceButton.animation = "pop"
        signInFaceButton.animate()

        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends],
                           viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, _, _):
                if grantedPermissions.contains("email") {
                    self.getFBUserData()
                }
            }
        }
    }

    @IBAction func signIn(_ sender: Any) {
//        performSegue(withIdentifier: "segueTutorial", sender: nil)
        
        if validateFields() == ""{
            viewModel.signInWith(emailField.text ?? "",
                                 and: passField.text ?? "",
                                 onComplete: {
                                    self.performSegue(withIdentifier: "segueDash", sender: nil)
            }) { (msg) in
                GlobalAlert(with: self, msg: msg).showAlert()
            }
        } else {
            GlobalAlert(with: self, msg: validateFields()).showAlert()
        }
    }
    
    @IBAction func loginGmail(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        signInGmailButton.animation = "pop"
        signInGmailButton.animate()
    }
    
    private func getFBUserData() {
        if((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me",
                              parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"])
                .start(completionHandler: { [unowned self] connection, result, error -> Void in
                if (error == nil) {
                    //everything works print the user data
                    if let user = result as? [String: Any],
                        let email = user["email"],
                        let name = user["name"],
//                        let userName = user["first_name"],
                        let faceID = user["id"] {
                        
                        self.signInWithFacebook(faceId: faceID as! String,
                                                email: email as! String,
                                                name: name as! String)
                        
                    }
                }
            })
        }
    }
    
    private func signInWithFacebook(faceId: String, email: String, name: String) {
        viewModel.signInWith(faceId, onComplete: {
            self.performSegue(withIdentifier: "segueDash", sender: nil)
        }) { [unowned self] msg in
            if msg == "Usuário não encontrado" {
                let userData: [String: String] = [
                    "faceId": faceId,
                    "name": name,
                    "email": email
                ]
                self.performSegue(withIdentifier: "segueSignup", sender: userData)
                return
            }
            GlobalAlert(with: self, msg: msg).showAlert()
        }
    }
    
    private func validateFields() -> String {
        
        var msg = ""
        
        if self.emailField.text == "" {
            msg = "Preencha o email"
        } else if self.passField.text == "" {
            msg = "Preencha a senha"
        }
        
        return msg
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueSignup" {
            guard let vc = segue.destination as? SignUpTableViewController else {return}
            guard let userData = sender as? [String: String] else {return}
            
            vc.facebookId = userData["faceId"]
            vc.name = userData["name"]
            vc.email = userData["email"]
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
}
