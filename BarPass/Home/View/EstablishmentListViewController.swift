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
    @IBOutlet weak var leadinBarConstraint: NSLayoutConstraint!
    
    var viewModel: EstablishmentViewModelProtocol!
    var estabs: [Establishment] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let animationOptions: UIView.AnimationOptions = [.allowAnimatedContent, .preferredFramesPerSecond60, .curveEaseOut]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = EstablishmentViewModel()
        tableView.tableFooterView = UIView()
        hideKeyboardWhenTappedAround()
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
    
    private func layoutIfNeededViews() {
        searchBar.layoutIfNeeded()
        logoImage.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
}


// MARK: - <#UISearchBarDelegate#>
extension EstablishmentListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3, delay: 0, options: animationOptions, animations: {
            
            self.logoImage.alpha = 0
            self.leadinBarConstraint.constant = 20
            self.layoutIfNeededViews()
        }, completion: nil)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3, delay: 0, options: animationOptions, animations: {
            
            self.logoImage.alpha = 1
            self.leadinBarConstraint.constant = 134
            self.layoutIfNeededViews()
        }, completion: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
