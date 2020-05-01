//
//  Catalog.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 02.03.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CategoriesID: Decodable  {
    
    var categories: Categories
}

class Categories: Decodable {
    
    var name: String = ""
    var sortOrder: Int = 0
    var iconImage: String = ""
    var iconImageData: Data = Data()
    var subcategories: [SubCategories] = []
    
    enum CodingKeys: String, CodingKey {
        case name
        case sortOrder
        case iconImage
//        case iconImageData
        case subcategories
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        
        if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
            self.sortOrder = Int(sortOrderString)!
        } else {
            self.sortOrder = try container.decode(Int.self, forKey: .sortOrder)
        }
        
        if let iconImageURL = try? container.decode(String.self, forKey: .iconImage) {
            self.iconImage = iconImageURL
//            DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .userInteractive, attributes: .concurrent).async {
//                self.iconImageData = try! Data(contentsOf: URL(string: "http://blackstarshop.ru/\(iconImageURL)")!)
//            }
        } else {
//            self.iconImageData = try container.decode(Data.self, forKey: .iconImage)
        }
        
        self.subcategories = try container.decode([SubCategories].self, forKey: .subcategories).sorted { $0.sortOrder < $1.sortOrder }
    }
    
    init() {
        self.name = ""
        self.sortOrder = 0
        self.iconImage = ""
        self.iconImageData = Data()
        self.subcategories = []
    }
}

class SubCategories: Decodable {
    
    var id: String
    var iconImage: String = ""
    var iconImageData: Data = Data()
    var sortOrder: Int = 0
    var name: String = ""
    var type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case iconImage
//        case iconImageData
        case sortOrder
        case name
        case type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let idInt = try? container.decode(Int.self, forKey: .id) {
            self.id = "\(idInt)"
        } else {
            self.id = try container.decode(String.self, forKey: .id)
        }
        
        if let iconImageURL = try? container.decode(String.self, forKey: .iconImage) {
            self.iconImage = iconImageURL
//            DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .userInteractive, attributes: .concurrent).async {
//                self.iconImageData = try! Data(contentsOf: URL(string: "http://blackstarshop.ru/\(iconImageURL)")!)
//            }
        } else {
//            self.iconImageData = try container.decode(Data.self, forKey: .iconImage)
        }
        
        if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
            self.sortOrder = Int(sortOrderString)!
        } else {
            self.sortOrder = try container.decode(Int.self, forKey: .sortOrder)
        }
    
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try? container.decode(String.self, forKey: .type)
    }
    
    init() {
        self.id = ""
        self.iconImage = ""
        self.iconImageData = Data()
        self.sortOrder = 0
        self.name = ""
//        self.type = ""
    }
}

class Products: Decodable {
    
    var owner: String = ""
    var name: String = ""
    var englishName: String = ""
    var sortOrder: Int = 0
    var article: String?
    var collection: String?
    var productsDescription: String?
    var colorName: String = ""
    var colorImageURL: String = ""
    var colorImageData: Data = Data()
    var mainImage: String = ""
    var mainImageData: Data = Data()
    var productImages: [[String: String]] = []
    var offers: [[String: String]] = []
    var recommendedProductIDs: [String] = []
    var price: String?
    var oldPrice: String?
    var tag: String?
    var attributes: [[String: String]] = []
    
    enum CodingKeys: String, CodingKey {
        case name
        case englishName
        case sortOrder
        case article
        case collection
        case productsDescription = "description"
        case colorName
        case colorImageURL
        case mainImage
        case productImages
        case offers
        case recommendedProductIDs
        case price
        case oldPrice
        case tag
        case attributes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.englishName = try container.decode(String.self, forKey: .englishName)

        if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
            self.sortOrder = Int(sortOrderString)!
        } else {
            self.sortOrder = try container.decode(Int.self, forKey: .sortOrder)
        }
        
        self.article = try container.decode(String.self, forKey: .article)
        self.collection = try? container.decode(String.self, forKey: .collection)
        self.productsDescription = try? container.decode(String.self, forKey: .productsDescription)
        self.colorName = try container.decode(String.self, forKey: .colorName)
        
        if let colorImageURL = try? container.decode(String.self, forKey: .colorImageURL) {
            self.colorImageURL = colorImageURL
            DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .userInteractive, attributes: .concurrent).async {
                self.colorImageData = try! Data(contentsOf: URL(string: "http://blackstarshop.ru/\(colorImageURL)")!)
            }
        } else {
            self.colorImageData = try container.decode(Data.self, forKey: .colorImageURL)
        }
        
        if let mainImageURL = try? container.decode(String.self, forKey: .mainImage) {
            self.mainImage = mainImageURL
            DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .userInteractive, attributes: .concurrent).async {
                self.mainImageData = try! Data(contentsOf: URL(string: "http://blackstarshop.ru/\(mainImageURL)")!)
            }
        } else {
            self.mainImageData = try container.decode(Data.self, forKey: .mainImage)
        }
        
        //productImages
        self.productImages = try container.decode([[String: String]].self, forKey: .productImages)
        
        //offers
        self.offers = try container.decode([[String: String]].self, forKey: .offers)
        
        self.recommendedProductIDs = try container.decode([String].self, forKey: .recommendedProductIDs)
        if let price = try? container.decode(String.self, forKey: .price) {
            self.price = price
        }
        
        if let oldPrice = try? container.decode(String.self, forKey: .oldPrice) {
            self.oldPrice = oldPrice
        }
        
        self.tag = try? container.decode(String.self, forKey: .tag)
        
        //attributes
        self.attributes = try container.decode([[String: String]].self, forKey: .attributes)
    }
    
    init() { }
}
