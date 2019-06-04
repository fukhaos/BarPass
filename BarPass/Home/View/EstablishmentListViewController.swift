//
//  EstablishmentListViewController.swift
//  BarPass
//
//  Created by Bruno Lopes on 04/06/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit

class EstablishmentListViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: EstablishmentViewModelProtocol!
    var estabs: [Establishment] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = EstablishmentViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        searchBar.backgroundImage = UIImage()
        viewModel.getStabs(onComplete: { [unowned self] bars in
            self.estabs = bars
        }) { (msg) in
            GlobalAlert(with: self, msg: msg).showAlert()
        }
    }
    
}


// MARK: - <#UITableViewDataSource, UITableViewDelegate#>
extension EstablishmentListViewController: UITableViewDataSource,
UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return estabs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)
            as? EstablishmentTableViewCell else {return UITableViewCell()}
        cell.fillCell(estabs[indexPath.row])
        return cell
    }
}
