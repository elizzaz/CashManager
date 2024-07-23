//
//  OrderRequest.swift
//  CashManager
//
//  Created by Franck Minassian on 13/12/2022.
//

import Foundation

protocol GetAllOrdersDelegate {
    func onGetAllOrdersSuccess(orders: [OrderBack])
    func onGetAllOrdersError()
}

protocol GetOrdersDelegate {
    func onGetOrdersSuccess(order: OrderBack)
    func onGetOrdersError()
}

extension APIBack {
    
    func getOrder(id: String, delegate: GetOrdersDelegate){
        class process : RequestBackDelegate {
            private dynamic var delegate: GetOrdersDelegate?
            init(delegate: GetOrdersDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data){
                do {
                    let type = try JSONSerialization.jsonObject(with: json, options: []) as? [String: AnyObject] ?? [:]
                    let myProd = OrderBack()
                    myProd.parse(type: type)
                    delegate?.onGetOrdersSuccess(order: myProd)
                }
                catch {
                    self.delegate!.onGetOrdersError()
                }
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.onGetOrdersError()
            }
        }
        self.request(path: "orders/\(id)", method: .GET, body: [:], delegate: process(delegate: delegate))
    }
    
    func getAllOrder(delegate: GetAllOrdersDelegate){
        class process : RequestBackDelegate {
            
            
            private dynamic var delegate: GetAllOrdersDelegate?
            init(delegate: GetAllOrdersDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data){
                do {
                    let type = try JSONSerialization.jsonObject(with: json, options: []) as? [[String: AnyObject]] ?? [[:]]
                    let array = type
                    var allOrders = [OrderBack] ()
                    for config in array {
                        let oneCat = OrderBack()
                        oneCat.parse(type: config)
                        allOrders.append(oneCat)
                    }
                    
                    delegate?.onGetAllOrdersSuccess(orders: allOrders)
                }
                catch {
                    self.delegate!.onGetAllOrdersError()
                }
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.onGetAllOrdersError()
            }
        }
        self.request(path: "orders/", method: .GET, body: [:], delegate: process(delegate: delegate))
    }
    
}
