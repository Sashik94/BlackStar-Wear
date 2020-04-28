//
//  ProductViewController.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 17.03.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit
import RealmSwift

class ProductViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var colorButton: AddProfilePictureView!
    @IBOutlet weak var sizeButton: UIButton!
    @IBOutlet weak var attributesTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    
    static var shared = ProductViewController()
    private let realm = try! Realm()
    var networkDataFetcher = NetworkDataFetcher()
    var idSubCategories: String!
    var productsID: Int!
    var products: [Products]!
    var recommendProducts: [Products] = []
    var arrayImages: [UIImage] = []
    var indexColorArray: [Int] = []
    var offer: Offer? {
        didSet { fillingButton() }
    }
    var mainImage: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index, value) in products.enumerated() {
            if value.article == products[productsID].article {
                indexColorArray.append(index)
            }
        }
        
        recommendProducts = products
        recommendProducts.remove(at: productsID)
        
//        loadImage()
        drowImage()
        fillingButton()
        filling()
        
    }
    
    func loadImage() {
        self.arrayImages.append(self.networkDataFetcher.loadImage(urlImage: self.products[self.productsID].mainImage))
        for i in self.products[self.productsID].productImages {
            if let url = i["imageURL"] {
                self.arrayImages.append(self.networkDataFetcher.loadImage(urlImage: url))
            }
        }
    }
    
    func drowImage() {
        DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos : .userInteractive, attributes: .concurrent).async {
            self.loadImage()
            DispatchQueue.main.async {
                self.imageScrollView.contentSize = CGSize(width: (self.imageScrollView.bounds.height * 0.75) * CGFloat(self.arrayImages.count), height: self.imageScrollView.bounds.height)
                self.pageControl.numberOfPages = self.arrayImages.count
                for (index, image) in self.arrayImages.enumerated() {
                    if type(of: image) == UIImage.self {
                        let imageView = UIImageView()
                        imageView.image = image
                        imageView.frame = CGRect(x: (self.imageScrollView.bounds.height * 0.75) * CGFloat(index), y: 0, width: self.imageScrollView.bounds.height * 0.75, height: self.imageScrollView.bounds.height)
                        self.imageScrollView.addSubview(imageView)
                    }
                }
            }
        }
    }
    
    func fillingButton() {
        if let offer = offer {
            sizeButton.setTitle("Размер: \(offer.size)", for: .normal)
        }
        
        let image = self.networkDataFetcher.loadImage(urlImage: products[productsID].colorImageURL)
        let destinationSize = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContext(destinationSize);
        image.draw(in: CGRect(x: 0, y: 0, width: destinationSize.width, height: destinationSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        colorButton.setImage(image: newImage, inFrame: CGRect(x: colorButton.titleLabel!.frame.maxX - 18, y: colorButton.imageView!.frame.midY - colorButton.titleLabel!.frame.height / 2, width: 20, height: 20), for: .normal)
//        colorButton.setImage(newImage, for: .normal)
        colorButton.imageView?.layer.cornerRadius = (colorButton.imageView?.bounds.height)! / 2
        colorButton.imageView?.layer.borderWidth = 1
        colorButton.imageView?.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        if indexColorArray.count > 1 {
            colorButton.rightHandImage = UIImage(systemName: "chevron.down")
            colorButton.isUserInteractionEnabled = true
        }
    }
    
    func filling() {
        
        let product = products[productsID]
        
        if let oldPrice = product.oldPrice {
            let attributeOldPriceString: NSMutableAttributedString =  NSMutableAttributedString(string: numberFormatter(oldPrice) + " руб.")
            attributeOldPriceString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeOldPriceString.length))
            oldPriceLabel.attributedText = attributeOldPriceString
        } else {
            oldPriceLabel.isHidden = true
        }
        if let price = product.price {
            priceLabel.text = numberFormatter(price) + " руб."
        }
        nameLabel.text = product.name
        if let discount = product.tag {
            discountLabel.backgroundColor = .red
            if discount == "new" {
                discountLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            }
            discountLabel.text = discount
        } else {
            discountLabel.isHidden = true
        }
        
        let attributeAttributesString = NSMutableAttributedString(string: "")
        if let article = product.article {
            attributeAttributesString.append(NSMutableAttributedString(string: "Артикул: ", attributes: [NSMutableAttributedString.Key.font : UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)]))
            attributeAttributesString.append(NSMutableAttributedString(string: article + "\n", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: UIFont.systemFontSize)]))
        }
        if let attributes = product.attributes {
            for attribute in attributes {
                attributeAttributesString.append(NSMutableAttributedString(string: attribute.first!.key + ": ", attributes: [NSMutableAttributedString.Key.font : UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)]))
                attributeAttributesString.append(NSMutableAttributedString(string: attribute.first!.value + "\n", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: UIFont.systemFontSize)]))
            }
            attributeAttributesString.deleteCharacters(in: NSRange(location: attributeAttributesString.length - 1, length: 1))
            attributesTextView.attributedText = attributeAttributesString
        }
        
        descriptionTextView.text = product.productsDescription
    }
    
    func numberFormatter (_ numberString: String) -> String {
        let formatedString = NumberFormatter()
        formatedString.groupingSeparator = " "
        formatedString.numberStyle = .decimal
        return formatedString.string(from: NSNumber(value: Int(Double(numberString)!)))!
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    @IBAction func addInBasket(_ sender: UIButton) {
        if let size = offer?.size {
            mainImage = try! Data(contentsOf: URL(string: "http://blackstarshop.ru/\(products[productsID].mainImage)")!)
            PersistanceRealm.shared.loadProductInBasket(idSubCategories: idSubCategories, products: products, productID: productsID, mainImage: mainImage, size: size)
            tabBarController?.tabBar.items?[1].badgeValue = String(realm.objects(ProductInBasketRealm.self).count)
            
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "SelectionSize") as! SelectionViewController
            newViewController.selectionSizeArray = products[productsID].offers
            newViewController.productController = self
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectionColor" {
            let SVC = segue.destination as! SelectionViewController
//            SVC.products = products
            SVC.productController = self
            SVC.selectionColorArray = indexColorArray
            SVC.selectionID = { id in
                self.dismiss(animated: true) {
                    self.fillingNewController(id)
                }
            }
        } else if segue.identifier == "SelectionSize" {
            let SVC = segue.destination as! SelectionViewController
            SVC.selectionSizeArray = products[productsID].offers
            SVC.productController = self
        } else if segue.identifier == "Recommend produt" {
            let collectionViewCell = sender as! UICollectionViewCell
            let indexPath = recommendCollectionView.indexPath(for: collectionViewCell)!//RealmViewController.records[indexPath.row]
            let PVC = segue.destination as! ProductViewController
            PVC.productsID = indexPath.row >= productsID ? indexPath.row + 1 : indexPath.row
            PVC.products = products
        }
    }
    
    func fillingNewController(_ id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ProductViewController") as! ProductViewController
        vc.productsID = id
        vc.products = products
        definesPresentationContext = false
        show(vc, sender: nil)
    }
}

extension ProductViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
}

extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Recommend Cell", for: indexPath) as! RecommendCollectionViewCell
        let track = self.recommendProducts[indexPath.row]
        cell.recommendImageView.image = nil
        if let oldPrice = track.oldPrice {
            let attributeOldPriceString: NSMutableAttributedString =  NSMutableAttributedString(string: self.numberFormatter(oldPrice) + " руб.")
            attributeOldPriceString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeOldPriceString.length))
            cell.recommendOldPriceLabel.attributedText = attributeOldPriceString
        } else {
            cell.recommendOldPriceLabel.isHidden = true
        }
        if let price = track.price {
            cell.recommendPriceLabel.text = self.numberFormatter(price) + " руб."
        }
        cell.recommendNameLabel.text = track.name
        if let discount = track.tag {
            cell.recommendDiscountLabel.backgroundColor = .red
            if discount == "new" {
                cell.recommendDiscountLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            }
            cell.recommendDiscountLabel.text = discount
        } else {
            cell.recommendDiscountLabel.isHidden = true
        }
        self.recommendLabel.isHidden = false
        self.recommendCollectionView.isHidden = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .userInteractive, attributes: .concurrent).async {
            let cell = cell as! RecommendCollectionViewCell
            let track = self.recommendProducts[indexPath.row]
            let image = self.networkDataFetcher.loadImage(urlImage: track.mainImage)
            DispatchQueue.main.async {
                cell.recommendImageView.image = image
            }
        }
    }
    
    // MARK: - CollectionViewFlowLayoutDelegate
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        let w = (collectionView.bounds.width - 26) / 2
//        return CGSize(width: w, height: w * 1.75)
//    }
}

struct Offer {
    var size: String
    var productOfferID: String
    var quantity: String
}
