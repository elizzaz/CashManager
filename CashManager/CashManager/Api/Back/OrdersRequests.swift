//
//  OrdersRequests.swift
//  CashManager
//
//  Created by Serge Serci on 17/12/2022.
//

import Foundation

protocol CreateOrderDelegate {
    func onCreateOrderDelegateSuccess()
    func onCreateOrderDelegateError(code : Int)
}


extension APIBack {
    func createOrder(client: String, products: [String], total_price: Double, status: String, payment_means: String, delegate: CreateOrderDelegate) {
        var body : [String: Any]
        if (client == "") {
            body = ["products": products, "total_price": total_price, "status": status, "payment_means": payment_means] as [String : Any]
        } else {
           body = ["client": client, "products": products, "total_price": total_price, "status": status, "payment_means": payment_means] as [String : Any]
        }
        class process: RequestBackDelegate {
            private dynamic var delegate: CreateOrderDelegate?
            init(delegate: CreateOrderDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                delegate?.onCreateOrderDelegateSuccess()
            }
            
            func onErrorBackDelegate(error_code: Int, error: String) {
                delegate?.onCreateOrderDelegateError(code : error_code)
            }
        }
        self.request(path: "orders", method: .POST, body: body, delegate: process(delegate: delegate))
    }
}
