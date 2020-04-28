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
        
//        categories = PersistanceRealm.shared.downloadCategories()
        tabBarController?.tabBar.items?[1].badgeValue = String(realm.objects(ProductInBasketRealm.self).count)
        loadInJSON()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadInJSON() {
//        DispatchQueue.main.async {
            self.networkDataFetcher.urlString = self.urlString
            self.networkDataFetcher.fetchTracksCategories { (categoriesJSON) in
                guard let categoriesJSON = categoriesJSON else { return }
//                let reload = self.categories.count == 0 ? true : false
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
//                if reload {
                    self.tableView.reloadData()
//                }
                
                PersistanceRealm.shared.loadCategories(self.categories)
            }
//        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

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
        DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .userInteractive, attributes: .concurrent).async {
            let cell = cell as! CategoriesTableViewCell
            let track = self.categories[indexPath.row]
            let image = track.iconImage != "" ? self.networkDataFetcher.loadImage(urlImage: track.iconImage) : nil
            DispatchQueue.main.async {
                cell.imageCategories.image = image
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tableViewCell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: tableViewCell)!//RealmViewController.records[indexPath.row]
        
        if segue.identifier == "SubCategories" {
            let SCTVC = segue.destination as! SubCategoriesTableViewController
            SCTVC.subCategories = categories[indexPath.row].subcategories
        }
    }

}
