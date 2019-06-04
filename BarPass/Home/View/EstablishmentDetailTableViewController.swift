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

class EstablishmentDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var likeButton: SpringButton!
    
    
    var bar: Establishment!
    var pics = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
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
        imageView.image = UIImage()
        tempView.addSubview(imageView)
        
        return tempView
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        self.pageControl.currentPage = carousel.currentItemIndex
    }
}

