//
//  LoginTableViewController.swift
//  BarPass
//
//  Created by Bruno Lopes on 24/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController, TableStoryboarded {

    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setUIElements()
        hideKeyboardWhenTappedAround()
    }
    
    private func setUIElements() {
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
