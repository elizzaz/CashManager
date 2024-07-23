//
//  ClientsRequests.swift
//  CashManager
//
//  Created by Serge Serci on 06/12/2022.
//

import Foundation

protocol GetOneClientDelegate {
    func onGetOneClientDelegateSuccess(client: ClientBack)
    func onGetOneClientDelegateError()
}

protocol UpdateClientDelegate {
    func onUpdateClientDelegateSuccess(client: ClientBack)
    func onUpdateClientDelegateError()
}

extension APIBack {
    func getOneClient(clientId: String, delegate: GetOneClientDelegate) {
        class process : RequestBackDelegate {
            private dynamic var delegate: GetOneClientDelegate?
            init(delegate: GetOneClientDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                do {
                    let type = try JSONSerialization.jsonObject(with: json, options: []) as? [String: AnyObject] ?? [:]
                    
                        let client = ClientBack()
                        client.parse(type: type)
                    
                    delegate?.onGetOneClientDelegateSuccess(client: client)
                }
                catch {
                    self.delegate!.onGetOneClientDelegateError()
                }
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.onGetOneClientDelegateError()
            }
        }
        self.request(path: "clients/\(clientId)", method: .GET, body: [:], delegate: process(delegate: delegate))
    }
    
    func updateClient(clientId: String, amount: Double, delegate: UpdateClientDelegate) {
        class process : RequestBackDelegate {
            private dynamic var delegate: UpdateClientDelegate?
            init(delegate: UpdateClientDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                do {
                    let type = try JSONSerialization.jsonObject(with: json, options: []) as? [String: AnyObject] ?? [:]
                    
                        let client = ClientBack()
                        client.parse(type: type)
                    
                    delegate?.onUpdateClientDelegateSuccess(client: client)
                } catch {
                    self.delegate!.onUpdateClientDelegateError()
                }
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.onUpdateClientDelegateError()
            }
        }
        self.request(path: "clients/\(clientId)", method: .PUT, body: ["amount": amount], delegate: process(delegate: delegate))

    }
}
