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

class IndicatePubChildTableViewController: UITableViewController {

    @IBOutlet weak var pubNameField: UITextField!
    @IBOutlet weak var contactNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var indicateButton: SpringButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func indicate(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        indicateButton.animation = "pop"
        indicateButton.animate()
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
