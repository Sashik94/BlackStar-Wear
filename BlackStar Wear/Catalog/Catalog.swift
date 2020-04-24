//
//  Catalog.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 02.03.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation
import UIKit
//import RealmSwift

class CategoriesID: Decodable  {
    
    var categories: Categories
}

class Categories: Decodable {
    
    var name: String
    var sortOrder: Int
//    var iconImage: Data
    var iconImage: String
    var subcategories: [SubCategories]
    
    enum CodingKeys: String, CodingKey {
        case name
        case sortOrder
        case iconImage
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
        
//        if let iconImageString = try? container.decode(String.self, forKey: .iconImage) {
//            self.iconImage = try Data(contentsOf: URL(string: "http://blackstarshop.ru/\(iconImageString)")!)
//        } else {
            self.iconImage = try container.decode(String.self, forKey: .iconImage)
//        }
        
        self.subcategories = try container.decode([SubCategories].self, forKey: .subcategories).sorted { $0.sortOrder < $1.sortOrder }
    }
    
    init() {
        self.name = ""
        self.sortOrder = 0
        self.iconImage = ""
        self.subcategories = []
    }
}

class SubCategories: Decodable {
    
    var id: String
//    var iconImage: Data = Data()
    var iconImage: String = ""
    var sortOrder: Int = 0
    var name: String = ""
    var type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case iconImage
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
        
//        if let iconImageString = try? container.decode(String.self, forKey: .iconImage) {
//            self.iconImage = try Data(contentsOf: URL(string: "http://blackstarshop.ru/\(iconImageString)")!)
//        } else {
            self.iconImage = try container.decode(String.self, forKey: .iconImage)
//        }
        
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
        self.sortOrder = 0
        self.name = ""
//        self.type = ""
    }
}

class Products: Decodable {
    
    var name: String
    var englishName: String
    var sortOrder: Int
    var article: String?
    var collection: String?
    var productsDescription: String?
    var colorName: String
    var colorImageURL: String
    var mainImage: String
    var productImages: [[String: String]]
    var offers: [[String: String]]
    var recommendedProductIDs: [String]
    var price: String?
    var oldPrice: String?
    var tag: String?
    var attributes: [[String: String]]?
    
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
        
        self.colorImageURL = try container.decode(String.self, forKey: .colorImageURL)

        self.mainImage = try container.decode(String.self, forKey: .mainImage)
        
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
        self.attributes = try? container.decode([[String: String]].self, forKey: .attributes)
    }
    
}
