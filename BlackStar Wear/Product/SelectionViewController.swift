//
//  SelectionColorViewController.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 29.03.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var heightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    let networkDataFetcher = NetworkDataFetcher()
    var productController: ProductViewController!
//    var products: [Products] = []
    var selectionColorArray: [Int]?
    var selectionSizeArray: [[String: String]]?
    var selectionID: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableHeight: CGFloat
        
        if let selectionColorArray = self.selectionColorArray {
            tableHeight = CGFloat((selectionColorArray.count * 44) + 88)
        } else {
            tableHeight = CGFloat((self.selectionSizeArray!.count * 44) + 88)
        }
        
//        SelectionViewController.
        heightLayoutConstraint.constant = tableHeight
//        bottomLayoutConstraint.constant = -tableHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let selectionColorArray = selectionColorArray {
            return selectionColorArray.count
        } else {
            return selectionSizeArray!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Selection", for: indexPath) as! SelectionTableViewCell
        if let selectionColorArray = selectionColorArray {
            titleLabel.text = ""
            let track = productController.products[selectionColorArray[indexPath.row]]
            cell.nameLabel.text = track.colorName
            cell.colorImageView.image = self.networkDataFetcher.loadImage(urlImage: track.colorImageURL)
            cell.colorImageView.layer.cornerRadius = cell.colorImageView.bounds.height / 2
            cell.colorImageView.layer.borderWidth = 1
            cell.colorImageView.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
            cell.countLabel.text = ""
        } else {
            let track = selectionSizeArray![indexPath.row]
            cell.nameLabel.text = track["size"]
            cell.countLabel.text = track["quantity"]! + " шт"
            cell.colorImageView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectionColorArray = selectionColorArray {
            if productController.productsID != selectionColorArray[indexPath.row] {
                selectionID?(selectionColorArray[indexPath.row])
            }
        } else {
            let offer = Offer(size: selectionSizeArray![indexPath.row]["size"]!, productOfferID: selectionSizeArray![indexPath.row]["productOfferID"]!, quantity: selectionSizeArray![indexPath.row]["quantity"]!)
            productController.offer = offer
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}
