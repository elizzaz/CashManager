//
//  OFFProductsRequests.swift
//  CashManager
//
//  Created by Anthony Luong on 29/11/2022.
//

import Foundation

protocol GetOneProductDelegate {
    func onGetOneProductSuccess(product: ProductOFF)
    func onGetOneProductError(code: Int, message: String)
}

extension ApiOpenFoodFacts {
    func getProductByBarcode(barcode: String, delegate: GetOneProductDelegate) {
            class process : RequestDelegate {
                private dynamic var delegate: GetOneProductDelegate?
                init(delegate: GetOneProductDelegate) {
                    self.delegate = delegate
                }
                func onSuccessOFFDelegate(json: Data) {
                    do {
                        let type = try JSONSerialization.jsonObject(with: json, options: []) as? [String: AnyObject] ?? [:]
                        let myProd = ProductOFF()
                        myProd.parse(type: type["product"] as! [String : Any])
                        
                        delegate?.onGetOneProductSuccess(product: myProd)
                    }
                    catch {
                        self.delegate!.onGetOneProductError(code: 500, message: "erreur")
                    }
                }
                func onErrorOFFDelegate(error_code: Int, error: String) {

                    self.delegate!.onGetOneProductError(code: error_code, message: error)
                }
            }
            self.request(path: "product/\(barcode)", method: .GET, body: [:], delegate: process(delegate: delegate))
        }
}
