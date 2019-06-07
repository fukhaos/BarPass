//
//  ProfileTableViewController.swift
//  BarPass
//
//  Created by Bruno Lopes on 31/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit
import Spring

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codLabel: UILabel!
    @IBOutlet weak var premiumButton: SpringButton!
    @IBOutlet weak var picButton: UIButton!
    
    var viewModel: ProfileViewModelProtocol!
    var imagePicker = UIImagePickerController()
    var picture: UIImage!
    var fileName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        viewModel = ProfileViewModel()
        picButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        let user = RealmUtils().getUser()
        picButton.sd_setImage(with: URL(string: user.photo ?? ""), for: .normal,
                              completed: nil)
        nameLabel.text = user.fullName
        codLabel.text = "Código ID: \(user.codID ?? "")"
    }
    
    @IBAction func signPremium(_ sender: Any) {
        premiumButton.animation = "pop"
        premiumButton.animate()
    }
    
    @IBAction func addNewPic(_ sender: Any) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProfileDetailTableViewController {
            vc.fileName = self.fileName
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            let alert = UIAlertController(title: "Atenção", message: "Tem certeza que deseja deslogar?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sim", style: .destructive, handler: { (action) in
                UserDefaults.standard.set(false, forKey: "logged")
               self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - <#UIImagePickerControllerDelegate, UINavigationControllerDelegate#>
extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
