//
//  CatalogRealm.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 14.04.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CategoriesIDRealm: Object  {
    
    @objc dynamic var categories: CategoriesRealm?
}

class CategoriesRealm: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var sortOrder: Int = 0
    @objc dynamic var iconImage: String = ""
    @objc dynamic var iconImageData: Data = Data()
    var subcategories = List<SubCategoriesRealm>()
}

class SubCategoriesRealm: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var iconImage: String = ""
    @objc dynamic var iconImageData: Data = Data()
    @objc dynamic var sortOrder: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var type: String? = nil
    
}

class ProductsRealm: Object {
    
    @objc dynamic var owner: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var englishName: String = ""
    @objc dynamic var sortOrder: Int = 0
    @objc dynamic var article: String? = nil
    @objc dynamic var collection: String? = nil
    @objc dynamic var productsDescription: String?
    @objc dynamic var colorName: String = ""
    @objc dynamic var colorImageURL: String = ""
    @objc dynamic var colorImageData: Data = Data()
    @objc dynamic var mainImage: String = ""
    @objc dynamic var mainImageData: Data = Data()
    var productImages = List<productImagesRealm>()
    var offers = List<offersRealm>()
    var recommendedProductIDs = List<String>()
    @objc dynamic var price: String? = nil
    @objc dynamic var oldPrice: String? = nil
    @objc dynamic var tag: String? = nil
    var attributes = List<attributesRealm>()
    
}

class ProductInBasketRealm: Object {
    
    @objc dynamic var idSubCategories: String = ""
    @objc dynamic var ProductID: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var mainImage: Data = Data()
    @objc dynamic var price: String? = nil
    @objc dynamic var oldPrice: String? = nil
    @objc dynamic var size: String = ""
    var products = List<ProductsRealm>()
    
}

class productImagesRealm: Object {
    
    @objc dynamic var imageURL: String = ""
    @objc dynamic var imageData: Data = Data()
    @objc dynamic var sortOrder: String = ""
    
}

class offersRealm: Object {
    
    @objc dynamic var size: String = ""
    @objc dynamic var productOfferID: String = ""
    @objc dynamic var quantity: String = ""
    
}

class attributesRealm: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var value: String = ""
    
}
