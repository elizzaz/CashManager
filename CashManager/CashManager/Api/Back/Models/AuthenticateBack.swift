//
//  AuthenticateBack.swift
//  CashManager
//
//  Created by Serge Serci on 05/12/2022.
//

import Foundation



class AuthenticateBack: Identifiable {
    var username = ""
    var password = ""
    
    func parse(type: [String: Any]) {
    
        self.username = type["username"] as? String ?? ""
        self.password = type["password"] as? String ?? ""
    }}
