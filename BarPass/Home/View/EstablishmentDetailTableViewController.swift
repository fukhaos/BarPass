//
//  EstablishmentDetailTableViewController.swift
//  BarPass
//
//  Created by Bruno Lopes on 04/06/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit
import iCarousel
import Spring
import GoogleMaps

class EstablishmentDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var likeButton: SpringButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapContainer: GMSMapView!
    
    
    var bar: Establishment!
    var pics = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = bar.name
        discountLabel.text = "\(bar.discount ?? 0.0)% de Desconto"
        distanceLabel.text = "\(bar.distance ?? 0.0) Km de você"
        detailLabel.text = bar.description
        locationLabel.text = bar.fullAddress
        numberLabel.text = bar.phone
        emailLabel.text = bar.email
        dateLabel.text = bar.description
        pageControl.numberOfPages = bar.photo?.count ?? 0
        
        pics = bar.photo ?? [String]()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setInitialLocation(lat: bar.latitude ?? 0.0, long: bar.longitude ?? 0.0)
        self.tabBarController?.tabBar.isHidden = true
        carouselView.reloadData()
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func like(_ sender: Any) {
        if likeButton.isSelected {
            likeButton.isSelected = false
        } else {
            likeButton.animation = "pop"
            likeButton.isSelected = true
            likeButton.animate()
        }
    }
    
    @IBAction func directions(_ sender: Any) {
        let alert = PazNavigationApp.directionsAlertController(coordinate: RootViewController.locationManager.location!.coordinate, name: "Destino", title: "Selecione o aplicativo de GPS",
                                                               nameTitle: "") { (completed) in
                                                                
        }
        
        self.present(alert, animated: true, completion: nil)
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
}

extension EstablishmentDetailTableViewController: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return pics.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        //create the UIView
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: carouselView.bounds.width, height: 200))
        
        //crate a UIImageView
        let frame = CGRect(x: 0, y: 0, width: carouselView.bounds.width, height: 200)
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: URL(string: pics[index]), completed: nil)
        tempView.addSubview(imageView)
        
        return tempView
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        self.pageControl.currentPage = carousel.currentItemIndex
    }
}

extension EstablishmentDetailTableViewController: GMSMapViewDelegate {
    
    func setInitialLocation(lat: Double, long: Double) {
        self.mapContainer.delegate = self
        self.mapContainer.isMyLocationEnabled = true
        let cameraPosition = GMSCameraPosition.camera(withLatitude: lat,
                                                      longitude: long, zoom: 18.0)
        mapContainer.animate(to: cameraPosition)
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat,
                                                                longitude:long))
        marker.map = mapContainer
    }
}
