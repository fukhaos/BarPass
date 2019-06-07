//
//  UpdatePassTableViewController.swift
//  BarPass
//
//  Created by Bruno Lopes on 07/06/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit

class UpdatePassTableViewController: UITableViewController {

    @IBOutlet weak var oldPassField: UITextField!
    @IBOutlet weak var newPassField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    
    var viewModel: ProfileViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ProfileViewModel()
    }

    private func validateFields() -> String {
        var msg = ""
        
        if oldPassField.text == "" {
            msg = "Preencha o campo Senha Atual"
        } else if newPassField.text == "" {
            msg = "Preencha o campo Nova Senha"
        } else if newPassField.text?.count ?? 6 < 6 {
            msg = "A nova senha deve ter no mínimo 6 dígitos"
        } else if confirmPassField.text != newPassField.text {
            msg = "As senhas são diferentes"
        }
        
        return msg
    }
    
    @IBAction func changePassword(_ sender: Any) {
        if validateFields() == "" {
            
            viewModel.updatePass(oldPassField.text ?? "",
                                 newPassField.text ?? "",
                                 onComplete: { [unowned self] msg in
                                    GlobalAlert(with: self, msg: msg).showAlertAndReturn()
            }) { [unowned self] msg in
                GlobalAlert(with: self, msg: msg).showAlert()
            }
            
        } else {
            GlobalAlert(with: self, msg: validateFields()).showAlert()
        }
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
