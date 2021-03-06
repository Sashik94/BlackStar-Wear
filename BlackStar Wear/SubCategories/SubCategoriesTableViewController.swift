//
//  SubCategoriesTableViewController.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 11.03.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit

class SubCategoriesTableViewController: UITableViewController {
    
    var subCategories: [SubCategories] = []
    let networkDataFetcher = NetworkDataFetcher()
    
    @IBOutlet var subCategoriesTableView: UITableView!
    @IBOutlet weak var subCategoriesNavigationItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subCategories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategories cell", for: indexPath) as! SubCategoriesTableViewCell
        let track = self.subCategories[indexPath.row]
        cell.nameSubCategories.text = track.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos : .userInteractive, attributes: .concurrent).async {
            let cell = cell as! SubCategoriesTableViewCell
            let track = self.subCategories[indexPath.row]
            let image = track.iconImageData.isEmpty && track.iconImage != "" ? self.networkDataFetcher.loadImage(urlImage: track.iconImage) : UIImage(data: track.iconImageData)
            DispatchQueue.main.async {
                cell.imageSubCategories.image = image
                cell.activityIndicator.stopAnimating()
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
        
        if segue.identifier == "Products" {
            let PCVC = segue.destination as! ProductsCollectionViewController
            PCVC.idSubCategories = subCategories[indexPath.row].id
            PCVC.productsNavigationItem.title = subCategories[indexPath.row].name
        }
    }

}
