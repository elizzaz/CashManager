//
//  UserRequest.swift
//  CashManager
//
//  Created by Franck Minassian on 05/12/2022.
//

import Foundation

protocol getAllUserDelegate {
    func getAllUserSuccess(users: [UserBack])
    func getAllUserError(code: Int, err: String)
}

protocol deleteUserDelegate {
    func deleteUserSuccess(message: String)
    func deleteUserError(code: Int, err: String)
}

protocol updateUserDelegate {
    func updateUserSuccess(message: String)
    func updateUserError(code: Int, err: String)
}

protocol createUserDelegate {
    func createUserSuccess(message: String)
    func createUserError(code: Int, err: String)
}
protocol getUserMeDelegate {
    func getUserMeDelegateSuccess(user: UserBack)
    func getUserMeDelegateError(code: Int, err: String)
}

extension APIBack {
    func getAllUser(delegate: getAllUserDelegate) {
        class process : RequestBackDelegate{
            
            private dynamic var delegate: getAllUserDelegate?
            init(delegate: getAllUserDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                do {
                    let type = try JSONSerialization.jsonObject(with: json, options: []) as? [[String: AnyObject]] ?? [[:]]
                    let array = type
                    var allUser = [UserBack] ()
                    for config in array {
                        let oneCat = UserBack()
                        oneCat.parse(type: config)
                        allUser.append(oneCat)
                    }
                    delegate?.getAllUserSuccess(users: allUser)
                }
                catch {
                    self.delegate!.getAllUserError(code: 400, err: "Can't transform the list")
                }
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.getAllUserError(code: error_code, err: error)
            }
        }
        self.request(path: "users", method: .GET, body: [:], delegate: process(delegate: delegate))
    }
    
    //    DELETE USER
    
    func deleteUser(id: String, delegate: deleteUserDelegate) {
        class process : RequestBackDelegate{
            
            private dynamic var delegate: deleteUserDelegate?
            init(delegate: deleteUserDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                delegate?.deleteUserSuccess(message: "User deleted succesfuly")
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.deleteUserError(code: error_code, err: error)
            }
        }
        self.request(path: "users/delete/\(id)", method: .DELETE, body: [:], delegate: process(delegate: delegate))
    }
    
    //    UPDATE USER
    
    func updateUser(user: UserBack, edit: UserBack, delegate: updateUserDelegate) {
        class process : RequestBackDelegate{
            
            private dynamic var delegate: updateUserDelegate?
            init(delegate: updateUserDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                delegate?.updateUserSuccess(message: "User update succesfuly")
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.updateUserError(code: error_code, err: error)
            }
        }
        if (edit.password == "") {
            self.request(path: "users/update/\(user.id)", method: .PUT, body: ["username": edit.username, "role": edit.role], delegate: process(delegate: delegate))
        } else {
            self.request(path: "users/update/\(user.id)", method: .PUT, body: ["username": edit.username, "password": edit.password, "role": edit.role], delegate: process(delegate: delegate))
        }
    }
    
    //    CREATE USER
    
    func createUser(user: UserBack, delegate: createUserDelegate) {
        class process : RequestBackDelegate{
            
            private dynamic var delegate: createUserDelegate?
            init(delegate: createUserDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                delegate?.createUserSuccess(message: "User created succesfuly")
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.createUserError(code: error_code, err: error)
            }
        }
        self.request(path: "users/create", method: .POST, body: ["username": user.username, "role": user.role, "password": user.password], delegate: process(delegate: delegate))
    }
    
    // GET THE CONNECTED USER
    func getUserMe(delegate: getUserMeDelegate) {
        class process : RequestBackDelegate{
            
            private dynamic var delegate: getUserMeDelegate?
            init(delegate: getUserMeDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                do {
                    let type = try JSONSerialization.jsonObject(with: json, options: []) as? [String: AnyObject] ?? [:]
                    
                        let user = UserBack()
                        user.parse(type: type)
                    delegate?.getUserMeDelegateSuccess(user: user)
                }
                catch {
                    self.delegate!.getUserMeDelegateError(code: 400, err: "Can't transform the list")
                }
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.getUserMeDelegateError(code: error_code, err: error)
            }
        }
        self.request(path: "users/me", method: .GET, body: [:], delegate: process(delegate: delegate))
    }
}
