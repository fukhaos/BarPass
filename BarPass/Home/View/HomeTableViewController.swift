//
//  HomeTableViewController.swift
//  BarPass
//
//  Created by Bruno Lopes on 03/06/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit
import iCarousel
import Spring

class HomeTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var evaluatedButton: SpringButton!
    @IBOutlet weak var recomendedButton: SpringButton!
    @IBOutlet weak var favButton: SpringButton!
    @IBOutlet weak var discountsButton: SpringButton!
    @IBOutlet weak var locationButton: SpringButton!
    @IBOutlet weak var popularButton: SpringButton!
    @IBOutlet weak var newsButton: SpringButton!
    @IBOutlet weak var othersButton: SpringButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var highlights: [UIImage] = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        searchBar.backgroundImage = UIImage()
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


// MARK: - <#UICollectionViewDelegate, UICollectionViewDataSource#>
extension HomeTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView
            .dequeueReusableCell(withReuseIdentifier: "reuseCell", for: indexPath) as? PromotionCollectionViewCell
            else {return UICollectionViewCell()}
        return cell
    }
}


// MARK: - <#UISearchBarDelegate#>
extension HomeTableViewController: UISearchBarDelegate {
    
}

extension HomeTableViewController: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return highlights.count
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
