//
//  ProfileDetailTableViewController.swift
//  BarPass
//
//  Created by Bruno Lopes on 07/06/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit
import Spring
import AudioToolbox

class ProfileDetailTableViewController: UITableViewController {

    @IBOutlet weak var picButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editNameButton: SpringButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var smsSwitch: UISwitch!
    @IBOutlet weak var emailSwitch: UISwitch!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    var viewModel: ProfileViewModelProtocol!
    var imagePicker = UIImagePickerController()
    var picture: UIImage!
    var fileName: String!
    var user: User!
    var sendSMS: Bool = false
    var sendEmail: Bool = false
    var sendNotification: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        imagePicker.delegate = self
        viewModel = ProfileViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        user = RealmUtils().getUser()
        
        picButton.sd_setImage(with: URL(string: user.photo ?? ""),
                              for: .normal, completed: nil)
        nameField.text = user.fullName
        emailField.text = user.email
        codeLabel.text = user.codID
        smsSwitch.setOn(user.sendSMS, animated: true)
        emailSwitch.setOn(user.sendEmail, animated: true)
        notificationsSwitch.setOn(user.notification, animated: true)
        sendSMS = user.sendSMS
        sendEmail = user.sendEmail
        sendNotification = user.notification
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        if nameField.text != ""{
            saveButton.isHidden = true
            nameField.isEnabled = false
            
            try! user.realm?.write {
                user.fullName = nameField.text
                user.sendSMS = self.sendSMS
                user.sendEmail = self.sendEmail
                user.notification = self.sendNotification
            }
            
            viewModel.updateUser(self.user,
                                 onComplete: {
                                    GlobalAlert(with: self,
                                                msg: "Informações atualizadas com sucesso!").showAlert()
            }) { [unowned self] msg in
                GlobalAlert(with: self, msg: msg).showAlert()
            }
        } else {
            GlobalAlert(with: self, msg: "Preencha o campo Nome").showAlert()
        }
    }
    
    @IBAction func editName(_ sender: Any) {
        saveButton.isHidden = false
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        editNameButton.animation = "pop"
        editNameButton.animate()
        nameField.isEnabled = true
        nameField.becomeFirstResponder()
    }
    
    @IBAction func updatePic(_ sender: Any) {
        let alert = UIAlertController(title: "Incluir imagem", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Galeria", style: UIAlertAction.Style.default, handler: { action in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { action in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tappedOnSMS(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        saveButton.isHidden = false
        if smsSwitch.isOn {
            self.sendSMS = true
        } else {
            self.sendSMS = false
        }
    }
    
    @IBAction func tappedOnEmail(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        saveButton.isHidden = false
        if emailSwitch.isOn {
            self.sendEmail = true
        } else {
            self.sendEmail = false
        }
    }
    
    @IBAction func tappedOnNotification(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        saveButton.isHidden = false
        if notificationsSwitch.isOn {
            self.sendNotification = true
        } else {
            self.sendNotification = false
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
}

// MARK: - <#UIImagePickerControllerDelegate, UINavigationControllerDelegate#>
extension ProfileDetailTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pic = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let image = pic.fixedOrientation()
            viewModel.uploadPic(with: image, onComplete: { [unowned self] fileName in
                DispatchQueue.main.async {
                    self.picture = image
                    self.fileName = fileName
                }
                
                self.viewModel.updateUserPhoto(with: fileName,
                                               onComplete: {
                                                DispatchQueue.main.async {
                                                    self.picButton.setImage(self.picture, for: .normal)
                                                    
                                                }
                                                self.imagePicker.dismiss(animated: true, completion: nil)
                }, onError: { (msg) in
                    self.imagePicker.dismiss(animated: true, completion: {
                        GlobalAlert(with: self, msg: msg).showAlert()
                    })
                })
                
            }) { [unowned self] msg in
                self.imagePicker.dismiss(animated: true, completion: {
                    GlobalAlert(with: self, msg: msg).showAlert()
                })
            }
        }
    }
}

