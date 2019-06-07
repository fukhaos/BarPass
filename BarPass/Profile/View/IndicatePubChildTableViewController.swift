//
//  IncatePubChildTableViewController.swift
//  BarPass
//
//  Created by Bruno Lopes on 31/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit
import Spring
import AudioToolbox
import InputMask

class IndicatePubChildTableViewController: UITableViewController {

    @IBOutlet weak var pubNameField: UITextField!
    @IBOutlet weak var contactNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var indicateButton: SpringButton!
    @IBOutlet var phoneMaskListener: MaskedTextFieldDelegate!
    
    var viewModel: ProfileViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ProfileViewModel()
        
        hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func indicate(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        indicateButton.animation = "pop"
        indicateButton.animate()
        
        if validateFields() == "" {
            var pub = [String: Any]()
            pub["establishmentName"] = pubNameField.text
            pub["contactName"] = contactNameField.text
            pub["phone"] = phoneField.text
            pub["fullAddress"] = addressField.text
            viewModel.indicatePub(pub: pub,
                                  onComplete: { [unowned self] msg in
                                    GlobalAlert(with: self, msg: msg).showAlertAndReturn()
            }) { [unowned self] msg in
                GlobalAlert(with: self, msg: msg).showAlert()
            }
        } else {
            GlobalAlert(with: self, msg: validateFields()).showAlert()
        }
    }
    
    private func validateFields() -> String {
        var msg = ""
        
        if pubNameField.text == "" {
            msg = "Preencha o campo Nome do Bar"
        } else if contactNameField.text == ""{
            msg = "Preencha o campo Nome do contato"
        } else if phoneField.text == "" {
            msg = "Preencha o campo Telefone para Contato"
        } else if addressField.text == ""{
            msg = "Preencha o campo Endereço"
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

// MARK: - <#MaskedTextFieldDelegateListener#>
extension IndicatePubChildTableViewController: MaskedTextFieldDelegateListener {
    
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        print(value)
    }
}
