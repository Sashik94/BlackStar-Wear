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
                    for subCategory in categories.subcategories {
                        if let subCategoryRealm = category.subcategories.filter("name == '\(subCategory.name)'").first {
                            subCategoryRealm.id = subCategory.id
                            subCategoryRealm.iconImage = subCategory.iconImage
                            subCategoryRealm.sortOrder = subCategory.sortOrder
                            subCategoryRealm.name = subCategory.name
                            subCategoryRealm.type = subCategory.type
                        } else {
                            let subCategoryRealm = SubCategoriesRealm()
                            subCategoryRealm.id = subCategory.id
                            subCategoryRealm.iconImage = subCategory.iconImage
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
                    for subCategory in categories.subcategories {
                        let newSubcategories = SubCategoriesRealm()
                        newSubcategories.id = subCategory.id
                        newSubcategories.iconImage = subCategory.iconImage
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
                if (realm.objects(ProductsRealm.self).filter("article == '\(products.article!)' && colorName == '\(products.colorName)'").first != nil) {
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
                    newProduct.mainImage = products.mainImage
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
                    if let attributes = products.attributes {
                        for attribute in attributes {
                            let newAttribute = attributesRealm()
                            newAttribute.name = attribute.first!.key
                            newAttribute.value = attribute.first!.value
                            newProduct.attributes.append(newAttribute)
                        }
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
            for cubCategoryRealm in categoryRealm.subcategories {
                let subcategories = SubCategories()
                subcategories.id = cubCategoryRealm.id
                subcategories.iconImage = cubCategoryRealm.iconImage
                subcategories.sortOrder = cubCategoryRealm.sortOrder
                subcategories.name = cubCategoryRealm.name
                subcategories.type = cubCategoryRealm.type
                category.subcategories.append(subcategories)
            }
            categories.append(category)
        }
        return categories
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
