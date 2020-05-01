//
//  CategoriesTableViewController.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 02.03.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriesTableViewController: UITableViewController {
    
    @IBOutlet var tableCategories: UITableView!
    
    let urlString = "https://blackstarshop.ru/index.php?route=api/v1/categories"
    
    let networkDataFetcher = NetworkDataFetcher()
    private let realm = try! Realm()
    var categories: [Categories] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = PersistanceRealm.shared.downloadCategories()
        tabBarController?.tabBar.items?[1].badgeValue = String(realm.objects(ProductInBasketRealm.self).count)
//        if categories.count == 0 { loadInJSON() }
        loadInJSON()
    }
    
    func loadInJSON() {
        networkDataFetcher.urlString = urlString
        networkDataFetcher.fetchTracksCategories { (categoriesJSON) in
            guard let categoriesJSON = categoriesJSON else { return }
            let reload = self.categories.count == 0 ? true : false
            var newCategories: [Categories] = []
            for category in categoriesJSON {
                newCategories.append(category.value)
            }
            newCategories = newCategories.sorted { $0.sortOrder < $1.sortOrder }
            for category in newCategories {
                if category.name == "Коллекции" {
                    continue
                }
                var i = -1
                for subcategory in category.subcategories {
                    i += 1
                    if let type = subcategory.type, type == "Collection" {
                        newCategories.filter{ $0.name == "Коллекции" }.first?.subcategories.append(category.subcategories.remove(at: i))
                        i -= 1
                    }
                }
            }
            self.categories = newCategories
            if reload {
                self.tableView.reloadData()
            }
            
            PersistanceRealm.shared.loadCategories(newCategories)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Categories cell", for: indexPath) as! CategoriesTableViewCell
        let track = self.categories[indexPath.row]
        cell.nameCategories.text = track.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .background, attributes: .concurrent).async {
            let cell = cell as! CategoriesTableViewCell
            let track = self.categories[indexPath.row]
            let image = track.iconImageData.isEmpty && track.iconImage != "" ? self.networkDataFetcher.loadImage(urlImage: track.iconImage) : UIImage(data: track.iconImageData)
            DispatchQueue.main.async {
                cell.imageCategories.image = image
                cell.activityIndicator.stopAnimating()
            }
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tableViewCell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)!//RealmViewController.records[indexPath.row]
        
        if segue.identifier == "SubCategories" {
            let SCTVC = segue.destination as! SubCategoriesTableViewController
            SCTVC.subCategories = categories[indexPath.row].subcategories
            SCTVC.subCategoriesNavigationItem.title = categories[indexPath.row].name
        }
    }

}
