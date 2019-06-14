//
//  EstablishmentTableViewCell.swift
//  BarPass
//
//  Created by Bruno Lopes on 04/06/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit
import SDWebImage

class EstablishmentTableViewCell: UITableViewCell {

    @IBOutlet weak var estabImage: UIImageView!
    @IBOutlet weak var imageIndicator: UIActivityIndicatorView!
    @IBOutlet weak var estabNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var neighborhood: UILabel!
    @IBOutlet weak var shortLocationLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillCell(_ bar: Establishment, _ location: String = "") {
        estabImage.sd_setImage(with: URL(string: bar.photo?.first ?? "")) { [unowned self] image, error, cache, url in
            self.imageIndicator.stopAnimating()
        }
        estabNameLabel.text = bar.name ?? ""
        locationLabel.text = "Rua: \(bar.fullAddress ?? "-")"
        shortLocationLabel.text = location
        neighborhood.text = "Bairro: \(bar.neighborhood ?? "-")"
        discountLabel.text = " -\(bar.discount ?? 0) % "
        distanceLabel.text = "\(bar.distance?.rounded() ?? 0.0) km"
    }

}
