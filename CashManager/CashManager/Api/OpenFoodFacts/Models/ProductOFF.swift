//
//  ProductOFF.swift
//  CashManager
//
//  Created by Anthony Luong on 29/11/2022.
//

import Foundation

class ProductOFF: Identifiable {
    var name = ""
    var image_url = ""
    var barcode = ""
    var brand = ""
    
    func parse(type: [String: Any]) {
        self.name = type["product_name"] as? String ?? ""
        self.image_url = type["image_url"] as? String ?? ""
        self.barcode = type["_id"] as? String ?? ""
        self.brand = type["brands"] as? String ?? ""
    }
}
