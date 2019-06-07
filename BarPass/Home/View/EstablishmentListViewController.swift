//
//  EstablishmentListViewController.swift
//  BarPass
//
//  Created by Bruno Lopes on 04/06/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit

class EstablishmentListViewController: RootViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leadinBarConstraint: NSLayoutConstraint!
    
    var viewModel: EstablishmentViewModelProtocol!
    var userViewModel: ProfileViewModelProtocol!
    var estabs: [Establishment] = []
    var filteredEstabs: [Establishment] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var location: String = ""
    
    let animationOptions: UIView.AnimationOptions = [.allowAnimatedContent, .preferredFramesPerSecond60, .curveEaseOut]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = EstablishmentViewModel()
        userViewModel = ProfileViewModel()
        tableView.tableFooterView = UIView()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        searchBar.backgroundImage = UIImage()
        self.tabBarController?.tabBar.isHidden = false
        if let userLocation = RootViewController.locationManager.location?.coordinate {
            let lat = userLocation.latitude
            let lon = userLocation.longitude
            
            userViewModel.getAddress(lat, lon,
                                     onComplete: { [unowned self] address in
                                        self.location = address.formatedAddress ?? ""
                                        self.viewModel.getStabs(onComplete: { [unowned self] bars in
                                            self.estabs = bars
                                            self.filteredEstabs = bars
                                        }) { (msg) in
                                            GlobalAlert(with: self, msg: msg).showAlert()
                                        }
            }) { [unowned self] msg in
                GlobalAlert(with: self, msg: msg).showAlert()
            }
        }
    }
    
    private func layoutIfNeededViews() {
        searchBar.layoutIfNeeded()
        logoImage.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EstablishmentDetailTableViewController {
            let sender = sender as! Establishment
            vc.bar = sender
        }
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredEstabs = estabs
            return
        }
        
        let localFiltering = estabs.filter({
            ($0.name?.lowercased().contains(searchText.lowercased()) ?? false) ||
            ($0.fullAddress?.lowercased().contains(searchText.lowercased()) ?? false)
        })
        
        filteredEstabs = localFiltering
    }
}


// MARK: - <#UITableViewDataSource, UITableViewDelegate#>
extension EstablishmentListViewController: UITableViewDataSource,
UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEstabs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)
            as? EstablishmentTableViewCell else {return UITableViewCell()}
        cell.fillCell(filteredEstabs[indexPath.row], self.location)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.getStabDetail(with: filteredEstabs[indexPath.row].id ?? "",
                                onComplete: { [unowned self] detailed in
                                    self.performSegue(withIdentifier: "segueDetail",
                                                      sender: detailed)
        }) { (msg) in
            GlobalAlert(with: self, msg: msg).showAlert()
        }
    }
}
