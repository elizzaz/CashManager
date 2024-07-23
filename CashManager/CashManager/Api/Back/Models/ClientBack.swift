//
//  ClientBack.swift
//  CashManager
//
//  Created by Serge Serci on 06/12/2022.
//

import Foundation

class ClientBack: Identifiable {
    var id = ""
    var first_name = ""
    var last_name = ""
    var email = ""
    var amount = 0.00
    
    func parse(type: [String: Any]) {
        self.id = type["_id"] as? String ?? ""
        self.first_name = type["first_name"] as? String ?? ""
        self.last_name = type["last_name"] as? String ?? ""
        self.email = type["email"] as? String ?? ""
        self.amount = type["amount"] as? Double ?? 0.00
    }
}

