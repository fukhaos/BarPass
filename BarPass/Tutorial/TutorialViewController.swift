//
//  TutorialViewController.swift
//  BarPass
//
//  Created by Bruno Lopes de Mello on 28/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit
import iCarousel

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var beginButton: UIButton!
    
    var onBoardImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        onBoardImages.append(UIImage(named: "tutorial1") ?? UIImage())
        onBoardImages.append(UIImage(named: "tutorial2") ?? UIImage())
        onBoardImages.append(UIImage(named: "tutorial3") ?? UIImage())
        onBoardImages.append(UIImage(named: "tutorial4") ?? UIImage())
        
        pageControl.numberOfPages = onBoardImages.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        carouselView.reloadData()
    }
    
    @IBAction func begin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - <#iCarouselDataSource, iCarouselDelegate#>
extension TutorialViewController: iCarouselDataSource, iCarouselDelegate {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return onBoardImages.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        //create the UIView
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: carouselView.bounds.width, height: carouselView.bounds.height))
        
        //crate a UIImageView
        let frame = CGRect(x: 0, y: 0, width: carouselView.bounds.width, height: carouselView.bounds.height)
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFill
        
        //set the images to the imageview and add it to the tempView
        imageView.image = onBoardImages[index]
        tempView.addSubview(imageView)
        
        return tempView
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        self.pageControl.currentPage = carousel.currentItemIndex
        if carousel.currentItemIndex == onBoardImages.count - 1 {
            beginButton.isHidden = false
        } else {
            beginButton.isHidden = true
        }
    }
}
