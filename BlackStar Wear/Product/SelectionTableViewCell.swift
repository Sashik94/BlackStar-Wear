//
//  SelectionTableViewCell.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 01.04.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!    
    @IBOutlet weak var colorImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }

}
