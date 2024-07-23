//
//  ClientBack.swift
//  CashManager
//
//  Created by Serge Serci on 06/12/2022.
//

import Foundation

class UserBack: Identifiable {
    var id = ""
    var username = ""
    var password = ""
    var role = ""
    
    func parse(type: [String: Any]) {
        self.id = type["_id"] as? String ?? ""
        self.username = type["username"] as? String ?? ""
        self.password = type["password"] as? String ?? ""
        self.role = type["role"] as? String ?? ""
    }
}
