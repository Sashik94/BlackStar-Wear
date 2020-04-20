//
//  BasketTableViewCell.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 13.04.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class BasketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageBasket: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
