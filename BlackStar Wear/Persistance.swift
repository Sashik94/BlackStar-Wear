//
//  Persistance.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 08.03.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class PersistanceRealm {
    static var shared = PersistanceRealm()
    private let realm = try! Realm()
    
    func loadCategories(_ allCategories: [Categories]) {
        try! realm.write {
            for categories in allCategories {
                if let category = realm.objects(CategoriesRealm.self).filter("name == '\(categories.name)'").first {
                    category.name = categories.name
                    category.sortOrder = categories.sortOrder
                    category.iconImage = categories.iconImage
//                    if category.iconImageData.isEmpty {
//                        DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .userInteractive, attributes: .concurrent).async {
//                            category.iconImageData = try! Data(contentsOf: URL(string: "http://blackstarshop.ru/\(categories.iconImage)")!)
//                        }
//                    } else {
                        category.iconImageData = categories.iconImageData
//                    }
                    for subCategory in categories.subcategories {
                        if let subCategoryRealm = category.subcategories.filter("name == '\(subCategory.name)'").first {
                            subCategoryRealm.id = subCategory.id
                            subCategoryRealm.iconImage = subCategory.iconImage
//                            if subCategoryRealm.iconImageData.isEmpty {
//                                DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .userInteractive, attributes: .concurrent).async {
//                                    subCategoryRealm.iconImageData = try! Data(contentsOf: URL(string: "http://blackstarshop.ru/\(subCategory.iconImage)")!)
//                                }
//                            } else {
                                subCategoryRealm.iconImageData = subCategory.iconImageData
//                            }
                            subCategoryRealm.sortOrder = subCategory.sortOrder
                            subCategoryRealm.name = subCategory.name
                            subCategoryRealm.type = subCategory.type
                        } else {
                            let subCategoryRealm = SubCategoriesRealm()
                            subCategoryRealm.id = subCategory.id
                            subCategoryRealm.iconImage = subCategory.iconImage
//                            if subCategoryRealm.iconImageData.isEmpty {
//                                DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .userInteractive, attributes: .concurrent).async {
//                                    subCategoryRealm.iconImageData = try! Data(contentsOf: URL(string: "http://blackstarshop.ru/\(subCategory.iconImage)")!)
//                                }
//                            } else {
                                subCategoryRealm.iconImageData = subCategory.iconImageData
//                            }
                            subCategoryRealm.sortOrder = subCategory.sortOrder
                            subCategoryRealm.name = subCategory.name
                            subCategoryRealm.type = subCategory.type
                            category.subcategories.append(subCategoryRealm)
                        }
                    }
                } else {
                    let newCategory = CategoriesRealm()
                    newCategory.name = categories.name
                    newCategory.sortOrder = categories.sortOrder
                    newCategory.iconImage = categories.iconImage
//                    if newCategory.iconImageData.isEmpty {
//                        DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .userInteractive, attributes: .concurrent).async {
//                            newCategory.iconImageData = try! Data(contentsOf: URL(string: "http://blackstarshop.ru/\(categories.iconImage)")!)
//                        }
//                    } else {
                        newCategory.iconImageData = categories.iconImageData
//                    }
                    for subCategory in categories.subcategories {
                        let newSubcategories = SubCategoriesRealm()
                        newSubcategories.id = subCategory.id
                        newSubcategories.iconImage = subCategory.iconImage
//                        if newSubcategories.iconImageData.isEmpty {
//                            DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .userInteractive, attributes: .concurrent).async {
//                                newSubcategories.iconImageData = try! Data(contentsOf: URL(string: "http://blackstarshop.ru/\(subCategory.iconImage)")!)
//                            }
//                        } else {
                            newSubcategories.iconImageData = subCategory.iconImageData
//                        }
                        newSubcategories.sortOrder = subCategory.sortOrder
                        newSubcategories.name = subCategory.name
                        newSubcategories.type = subCategory.type
                        newCategory.subcategories.append(newSubcategories)
                    }
                    realm.add(newCategory)
                }
                realm.refresh()
            }
        }
    }
    
    func loadProducts(_ allProducts: [Products], _ idSubCategories: String) {
        try! realm.write {
            for products in allProducts {
                if (realm.objects(ProductsRealm.self).filter("article == '\(products.article!)' && colorName == '\(products.colorName)' && owner == '\(idSubCategories)'").first != nil) {
                    continue
                } else {
                    let newProduct = ProductsRealm()
                    newProduct.owner = idSubCategories
                    newProduct.name = products.name
                    newProduct.englishName = products.englishName
                    newProduct.sortOrder = products.sortOrder
                    newProduct.article = products.article
                    newProduct.collection = products.collection
                    newProduct.productsDescription = products.productsDescription
                    newProduct.colorName = products.colorName
                    newProduct.colorImageURL = products.colorImageURL
//                    if products.colorImageData.isEmpty {
//                        DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .userInteractive, attributes: .concurrent).async {
//                            newProduct.colorImageData = try! Data(contentsOf: URL(string: "http://blackstarshop.ru/\(newProduct.colorImageURL)")!)
//                        }
//                    } else {
                        newProduct.colorImageData = products.colorImageData
//                    }
                    newProduct.mainImage = products.mainImage
//                    if products.mainImageData.isEmpty {
//                        DispatchQueue(label: "com.Sashik.BlackStar-Wear", qos: .userInteractive, attributes: .concurrent).async {
//                            newProduct.mainImageData = try! Data(contentsOf: URL(string: "http://blackstarshop.ru/\(newProduct.mainImage)")!)
//                        }
//                    } else {
                        newProduct.mainImageData = products.mainImageData
//                    }
                    newProduct.productImages = List<productImagesRealm>()
                    for img in products.productImages {
                        let newProductImages = productImagesRealm()
                        newProductImages.imageURL = img["imageURL"]!
                        newProductImages.sortOrder = img["sortOrder"]!
                        newProduct.productImages.append(newProductImages)
                    }
                    newProduct.offers = List<offersRealm>()
                    for offer in products.offers {
                        let newOffers = offersRealm()
                        newOffers.size = offer["size"]!
                        newOffers.productOfferID = offer["productOfferID"]!
                        newOffers.quantity = offer["quantity"]!
                        newProduct.offers.append(newOffers)
                    }
                    newProduct.recommendedProductIDs = List<String>()
                    for id in products.recommendedProductIDs {
                        newProduct.recommendedProductIDs.append(id)
                    }
                    newProduct.price = products.price
                    newProduct.oldPrice = products.oldPrice
                    newProduct.tag = products.tag
                    newProduct.attributes = List<attributesRealm>()
                    for attribute in products.attributes {
                        let newAttribute = attributesRealm()
                        newAttribute.name = attribute.first!.key
                        newAttribute.value = attribute.first!.value
                        newProduct.attributes.append(newAttribute)
                    }
                    realm.add(newProduct)
                }
                realm.refresh()
            }
        }
    }
    
    func loadProductInBasket(idSubCategories: String, products: [Products], productID: Int, mainImage: Data, size: String) {
        try! realm.write {
            let newProduct = ProductInBasketRealm()
            newProduct.idSubCategories = idSubCategories
            newProduct.ProductID = productID
            newProduct.name = products[productID].name
            newProduct.mainImage = mainImage
            newProduct.price = products[productID].price
            newProduct.oldPrice = products[productID].oldPrice
            newProduct.size = size
            for product in realm.objects(ProductsRealm.self).filter("owner == '\(idSubCategories)'") {
                newProduct.products.append(product)
            }
            realm.add(newProduct)
            realm.refresh()
        }
    }

    func downloadCategories() -> [Categories] {
        
        var categories: [Categories] = []
        let categoriesRealm = realm.objects(CategoriesRealm.self).array
        
        for categoryRealm in categoriesRealm {
            let category = Categories()
            category.name = categoryRealm.name
            category.sortOrder = categoryRealm.sortOrder
            category.iconImage = categoryRealm.iconImage
            category.iconImageData = categoryRealm.iconImageData
            for subCategoryRealm in categoryRealm.subcategories {
                let subcategories = SubCategories()
                subcategories.id = subCategoryRealm.id
                subcategories.iconImage = subCategoryRealm.iconImage
                subcategories.iconImageData = subCategoryRealm.iconImageData
                subcategories.sortOrder = subCategoryRealm.sortOrder
                subcategories.name = subCategoryRealm.name
                subcategories.type = subCategoryRealm.type
                category.subcategories.append(subcategories)
            }
            categories.append(category)
        }
        return categories
    }
    
    func downloadProducts(_ idSubCategories: String) -> [Products] {
        
        var products: [Products] = []
        let productsRealm = realm.objects(ProductsRealm.self).filter("owner == '\(idSubCategories)'").array
        
        for productRealm in productsRealm {
            let newProduct = Products()
            newProduct.name = productRealm.name
            newProduct.englishName = productRealm.englishName
            newProduct.sortOrder = productRealm.sortOrder
            newProduct.article = productRealm.article
            newProduct.collection = productRealm.collection
            newProduct.productsDescription = productRealm.productsDescription
            newProduct.colorName = productRealm.colorName
            newProduct.colorImageURL = productRealm.colorImageURL
            newProduct.colorImageData = productRealm.colorImageData
            newProduct.mainImage = productRealm.mainImage
            newProduct.mainImageData = productRealm.mainImageData
            for img in productRealm.productImages.array {
                let newProductImages: [String: String] = ["imageURL" : img.imageURL, "sortOrder" : img.sortOrder]
                newProduct.productImages.append(newProductImages)
            }
            for offer in productRealm.offers.array {
                let newOffers: [String: String] = ["size" : offer.size, "productOfferID" : offer.productOfferID, "quantity" : offer.quantity]
                newProduct.offers.append(newOffers)
            }
            for id in productRealm.recommendedProductIDs.array {
                newProduct.recommendedProductIDs.append(id)
            }
            newProduct.price = productRealm.price
            newProduct.oldPrice = productRealm.oldPrice
            newProduct.tag = productRealm.tag
            for attribute in productRealm.attributes.array {
                let newAttribute: [String: String] = [attribute.name: attribute.value]
                newProduct.attributes.append(newAttribute)
            }
            products.append(newProduct)
        }
        return products
    }
    
    func deleteCategories() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func deleteProduct(_ id: Int) {
        let record = realm.objects(ProductInBasketRealm.self)[id]
        try! realm.write {
            realm.delete(record)
        }
    }
}

extension Results {
    var array: [Element] {
        return self.count > 0 ? self.map { $0 } : []
    }
}

extension List {
    var array: [Element] {
        return self.count > 0 ? self.map { $0 } : []
    }
    
    func toArray<T>(ofType: T.Type) -> [T] {
            var array = [T]()
            for i in 0 ..< count {
                if let result = self[i] as? T {
                    array.append(result)
                }
            }
            return array
        }
}

//extension List {
//    func toArray<T>(ofType: T.Type) -> [T] {
//        var array = [T]()
//        for i in 0 ..< count {
//            if let result = self[i] as? T {
//                array.append(result)
//            }
//        }
//
//        return array
//    }
//}
