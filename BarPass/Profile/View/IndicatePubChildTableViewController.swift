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
        } else if phoneField.text?.count ?? 0 < 15 {
            msg = "Preencha corretamente o campo Telefone celular"
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
extension IndicatePubChildTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //New String and components
        let newStr = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let components = (newStr as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        
        //Decimal string, length and leading
        let decimalString = components.joined(separator: "") as NSString
        let length = decimalString.length
        let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
        
        //Checking the length
        if length == 0 || (length > 11 && !hasLeadingOne) || length > 13 {
            let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
            
            return (newLength > 11) ? false : true
        }
        
        //Index and formatted string
        var index = 0 as Int
        let formattedString = NSMutableString()
        
        //Check if it has leading
        if hasLeadingOne {
            formattedString.append("1 ")
            index += 1
        }
        
        //Area Code
        if (length - index) > 2 {
            let areaCode = decimalString.substring(with: NSMakeRange(index, 2))
            formattedString.appendFormat("(%@) ", areaCode)
            index += 2
        }
        
        if length - index > 4 {
            let prefix = decimalString.substring(with: NSMakeRange(index, 4))
            formattedString.appendFormat("%@-", prefix)
            index += 4
        }
        
        let remainder = decimalString.substring(from: index)
        formattedString.append(remainder)
        var newString = formattedString as String
        if length == 11 {
            //(11) 9502-01647
            newString.swapAt(9, 10)
            //(11) 95020-1647
            textField.text = newString
        } else {
            textField.text = newString
        }
        
        return false
    }
}
