//
//  ProductCollectionViewController.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 15.03.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Products Cell"

class ProductsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var productsNavigationItem: UINavigationItem!
    
    var idSubCategories: String!
    let urlString = "https:blackstarshop.ru/index.php?route=api/v1/products&cat_id="
    var networkDataFetcher = NetworkDataFetcher()
    var products: [Products] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        products = PersistanceRealm.shared.downloadProducts(idSubCategories)
        if products.isEmpty {
            networkDataFetcher.urlString = urlString + idSubCategories
            networkDataFetcher.fetchTracksProducts { (productsJSON) in
                guard let productsJSON = productsJSON else { return }
                for (_, product) in Array(productsJSON).sorted(by: {$0.0 < $1.0}) {
                    self.products.append(product)
                }
                self.products = self.products.sorted { $0.sortOrder < $1.sortOrder }
                self.collectionView.reloadData()
                
                PersistanceRealm.shared.loadProducts(self.products, self.idSubCategories)
            }
        }
    }
    
    // MARK: UICollectionViewDataSourceё
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductsCollectionViewCell
        let track = self.products[indexPath.row]
        cell.productsImage.image = nil
        if let oldPrice = track.oldPrice {
            let attributeOldPriceString: NSMutableAttributedString =  NSMutableAttributedString(string: ProductViewController().numberFormatter(oldPrice) + " руб.")
            attributeOldPriceString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeOldPriceString.length))
            cell.productsOldPriceLabel.attributedText = attributeOldPriceString
        } else {
            cell.productsOldPriceLabel.text = ""
        }
        if let price = track.price {
            cell.productsPriceLabel.text = ProductViewController().numberFormatter(price) + " руб."
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
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .userInteractive, attributes: .concurrent).async {
            let cell = cell as! ProductsCollectionViewCell
            let track = self.products[indexPath.row]
            let image = self.networkDataFetcher.loadImage(urlImage: track.mainImage)
            DispatchQueue.main.async {
                cell.productsImage.image = image
                
            }
        }
    }
    
    // MARK: - CollectionViewFlowLayoutDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (collectionView.bounds.width - 26) / 2
        return CGSize(width: w, height: w * 1.75)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let collectionViewCell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: collectionViewCell)!//RealmViewController.records[indexPath.row]
        
        if segue.identifier == "Produt" {
            let PVC = segue.destination as! ProductViewController
            PVC.productsID = indexPath.row
            PVC.products = products
            PVC.idSubCategories = idSubCategories
            PVC.productNavigationItem.title = products[indexPath.row].name
            }
    }
}
