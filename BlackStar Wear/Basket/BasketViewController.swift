//
//  BasketViewController.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 13.04.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit
import RealmSwift

class BasketViewController: UIViewController {
    
    @IBOutlet weak var basketTableView: UITableView!
    @IBOutlet weak var priceLabel: UILabel!
    
//    var productsID: Int!
//    var products: [Products]!
//    var productInBasket: [(Int, [Products])] = []
    private let realm = try! Realm()
//    var productInBasket = List<ProductInBasketRealm>()
    var productInBasket: [ProductInBasketRealm]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadBasket()
        basketTableView.reloadData()
    }
    
    func reloadBasket() {
        try! realm.write {
            productInBasket = realm.objects(ProductInBasketRealm.self).array
            realm.refresh()
        }
        sumPrice()
        tabBarController?.tabBar.items?[1].badgeValue = String(productInBasket.count)
    }
    
    func sumPrice() {
        var sumPrice = 0
        for product in productInBasket {
            if let price = product.price {
                sumPrice += Int(Double(price)!)
            }
        }
        priceLabel.text = ProductViewController().numberFormatter(String(sumPrice)) + " руб."
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let basketTableViewCell = sender as! BasketTableViewCell
        let indexPath = basketTableView.indexPath(for: basketTableViewCell)!//RealmViewController.records[indexPath.row]
        if segue.identifier == "ProdutFromBasket" {
            let PVC = segue.destination as! ProductViewController
            PVC.productsID = productInBasket[indexPath.row].ProductID
            PVC.productsRealm = productInBasket[indexPath.row].products.array
            PVC.idSubCategories = productInBasket[indexPath.row].idSubCategories
            PVC.productNavigationItem.title = productInBasket[indexPath.row].name
            }
    }
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInBasket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basket cell", for: indexPath) as! BasketTableViewCell
        let track = productInBasket[indexPath.row]
        cell.imageBasket.image = nil
        cell.nameLabel.text = track.name
        cell.sizeLabel.text = track.size
        
        if let oldPrice = track.oldPrice {
            let attributeOldPriceString: NSMutableAttributedString =  NSMutableAttributedString(string: ProductViewController().numberFormatter(oldPrice) + " руб.")
            attributeOldPriceString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeOldPriceString.length))
            cell.oldPriceLabel.attributedText = attributeOldPriceString
        } else {
            cell.oldPriceLabel.text = ""
            cell.priceLabel.textColor = .black
        }
        if let price = track.price {
            cell.priceLabel.text = ProductViewController().numberFormatter(price) + " руб."
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos : .userInteractive, attributes: .concurrent).async {
            let cell = cell as! BasketTableViewCell
            let track = self.productInBasket[indexPath.row]
            DispatchQueue.main.async {
                cell.imageBasket.image = UIImage(data: track.mainImage)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, complete in
            PersistanceRealm.shared.deleteProduct(indexPath.row)
            self.reloadBasket()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
               configuration.performsFirstActionWithFullSwipe = true
               return configuration
    }
}
