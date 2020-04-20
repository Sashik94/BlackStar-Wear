//
//  ProductCollectionViewController.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 15.03.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Products Cell"

class ProductsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var idSubCategories: String = ""
    let urlString = "http:blackstarshop.ru/index.php?route=api/v1/products&cat_id="
    var networkDataFetcher = NetworkDataFetcher()
    var products: [Products] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
//        DispatchQueue.main.async {
            self.networkDataFetcher.urlString = self.urlString + self.idSubCategories
            self.networkDataFetcher.fetchTracksProducts { (productsJSON) in
                guard let productsJSON = productsJSON else { return }
                for (_, product) in Array(productsJSON).sorted(by: {$0.0 < $1.0}) {
                    self.products.append(product)
                }
                self.products = self.products.sorted { $0.sortOrder < $1.sortOrder }
                self.collectionView.reloadData()
//            }
        }
    }
    
    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductsCollectionViewCell
        
        let track = products[indexPath.row]
//        DispatchQueue.main.async {
        cell.productsImage.image = UIImage(data: track.mainImage)
//            cell.productsImage.image = self.networkDataFetcher.loadImage(urlImage: track.mainImage)
//        }
        
        if let oldPrice = track.oldPrice {
            let attributeOldPriceString: NSMutableAttributedString =  NSMutableAttributedString(string: numberFormatter(oldPrice) + " руб.")
            attributeOldPriceString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeOldPriceString.length))
            cell.productsOldPriceLabel.attributedText = attributeOldPriceString
        } else {
            cell.productsOldPriceLabel.text = ""
//            cell.productsOldPriceLabel.isHidden = true
        }
        if let price = track.price {
            cell.productsPriceLabel.text = numberFormatter(price) + " руб."
        }
        cell.productsNameLabel.text = track.name
        if let discount = track.tag {
            cell.productsDiscountLabel.backgroundColor = .red
            if discount == "new" {
                cell.productsDiscountLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            }
            cell.productsDiscountLabel.text = discount
        } else {
            cell.productsDiscountLabel.isHidden = true
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: - CollectionViewFlowLayoutDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (collectionView.bounds.width - 26) / 2
        return CGSize(width: w, height: w * 1.75)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let collectionViewCell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: collectionViewCell)!//RealmViewController.records[indexPath.row]
        
        if segue.identifier == "Produt" {
            let PVC = segue.destination as! ProductViewController
            PVC.productsID = indexPath.row
            PVC.products = products
            }
    }
    
    func numberFormatter (_ numberString: String) -> String {
        let formatedString = NumberFormatter()
        formatedString.groupingSeparator = " "
        formatedString.numberStyle = .decimal
        return formatedString.string(from: NSNumber(value: Int(Double(numberString)!)))!
    }
    
}
