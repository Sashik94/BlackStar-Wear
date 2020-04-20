//
//  Persistance.swift
//  BlackStar Wear
//
//  Created by Александр Осипов on 08.03.2020.
//  Copyright © 2020 Александр Осипов. All rights reserved.
//

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
    
//    func load(_ forecast: Forecast) {
//        try! realm.write {
//            realm.add(forecast)
//        }
//    }

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
}

extension Results {
    var array: [Element] {
        return self.count > 0 ? self.map { $0 } : []
    }
}
