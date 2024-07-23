//
//  AuthenticateRequests.swift
//  CashManager
//
//  Created by Serge Serci on 05/12/2022.
//
import SwiftUI
import Foundation

protocol PostAuthenticateBackDelegate {
    func onPostAuthenticateBackSuccess(jwt: String)
    func onPostAuthenticateBackError()
}

extension APIBack {
   
    func postAuthenticateByUsername(username: String, password: String,delegate: PostAuthenticateBackDelegate) {
        class process : RequestBackDelegate {
            
            private dynamic var delegate: PostAuthenticateBackDelegate?
            init(delegate: PostAuthenticateBackDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                do {
                    let type = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] ?? [:]
                   
                    let JWT = type["access_token"] as? String ?? ""

                print("test",JWT)
                    delegate?.onPostAuthenticateBackSuccess(jwt: JWT)
                }
                catch {
                    self.delegate!.onPostAuthenticateBackError()
                }
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.onPostAuthenticateBackError()
            }
        }
        self.request(path: "users/login", method: .POST, body: ["username": username, "password": password], delegate: process(delegate: delegate))
    }
}
