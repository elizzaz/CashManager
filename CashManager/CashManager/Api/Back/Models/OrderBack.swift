//
//  OrdersBack.swift
//  CashManager
//
//  Created by Franck Minassian on 12/12/2022.
//

import Foundation

class OrderBack: Identifiable {
    var id = ""
    var user = UserBack()
    var client = [String]()
    var product = [ProductBack]()
    var status = ""
    var payement = ""
    var total_price = 0.0
    var created_at = ""
    
    func parse(type: [String: Any]) {
        self.id = type["_id"] as? String ?? ""
        let parsedUser = UserBack()
        parsedUser.parse(type: type["user"] as! [String : Any])
        self.user = parsedUser
        self.client = type["client"] as? Array<String> ?? [String]()
        let tab = type["products"] as! [[String: Any]]
                for line in tab {
                    let temp = ProductBack()
                    temp.parse(type: line)
                    self.product.append(temp)
                }
        self.status = type["status"] as? String ?? ""
        self.payement = type["payment_means"] as? String ?? ""
        self.total_price = type["total_price"] as? Double ?? 0.0
        self.created_at = type["created_at"] as? String ?? ""
    }
}

//class UserOrder: Identifiable {
//    var id = ""zzz
//    var username = ""
//
//    func parse(type: [String: Any]) {
//        self.id = type["_id"] as? String ?? ""
//        self.username = type["user"] as? String ?? ""
//    }
//}
