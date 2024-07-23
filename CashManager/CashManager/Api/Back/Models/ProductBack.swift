//
//  ProductBack.swift
//  CashManager
//
//  Created by Serge Serci on 29/11/2022.
//

import Foundation

class Category: Identifiable {
    var id = ""
    var name = ""
    
    func parse(type: [String: Any]) {
        self.id = type["_id"] as? String ?? ""
        self.name = type["name"] as? String ?? ""
    }
}

class ProductBack: Identifiable {
    
    var id = ""
    var name = ""
    var price = 0.0
    var image_url = ""
    var brand = ""
    var vat_percent = 0.0
    var barcode = ""
    var category = Category()
    
    func parse(type: [String: Any]) {
        self.id = type["_id"] as? String ?? ""
        self.name = type["name"] as? String ?? ""
        self.price = type["price"] as? Double ?? 0.0
        self.image_url = type["img_url"] as? String ?? "https://www.sciencesetavenir.fr/assets/img/2020/07/10/cover-r4x3w1000-5f07bdac39ca2-00000015-jpg.jpg"
        self.brand = type["brand"] as? String ?? "$caduca$h"
        self.vat_percent = type["vat_percent"] as? Double ?? 0.0
        self.barcode = type["bar_code"] as? String ?? ""
        
        if let categoryDict = type["category"] as? [String: Any] {
            self.category.parse(type: categoryDict)
        }
    }
}

extension Array where Element == ProductBack {
    func groupByBarcode() -> [String: [ProductBack]] {
        var groupedDictionary = [String: [ProductBack]]()
        for product in self {
            let barcode = product.barcode
            if groupedDictionary[barcode] == nil {
                groupedDictionary[barcode] = [product]
            } else {
                groupedDictionary[barcode]?.append(product)
            }
        }
        return groupedDictionary
    }
}
