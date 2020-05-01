//
//  SubCategoriesTableViewCell.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 11.03.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class SubCategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageSubCategories: UIImageView!
    @IBOutlet weak var nameSubCategories: UILabel!
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
