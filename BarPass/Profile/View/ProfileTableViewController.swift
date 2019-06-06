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
        
        self.tabBarController?.tabBar.isHidden = false
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
