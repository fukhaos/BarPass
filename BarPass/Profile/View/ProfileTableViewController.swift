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

    @IBOutlet weak var profileImage: SpringImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codLabel: UILabel!
    @IBOutlet weak var premiumButton: SpringButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func tappedImage(_ sender: UITapGestureRecognizer) {
        profileImage.animation = "pop"
        profileImage.animate()
    }
    
    @IBAction func signPremium(_ sender: Any) {
        premiumButton.animation = "pop"
        premiumButton.animate()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
