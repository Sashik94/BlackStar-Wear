//
//  CategoriesTableViewCell.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 02.03.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCategories: UIImageView!
    @IBOutlet weak var nameCategories: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
