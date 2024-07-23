//
//  ProductsRequests.swift
//  CashManager
//
//  Created by Serge Serci on 29/11/2022.
//

import Foundation

protocol GetOneProductBackDelegate {
    func onGetOneProductBackSuccess(product: ProductBack)
    func onGetOneProductBackError()
}

protocol GetAllProductsBackDelegate {
    func onGetAllProductsBackSuccess(products: [ProductBack])
    func onGetAllProductsBackError()
}

protocol GetProductByCategoryBackDelegate {
    func onGetProductByCategoryBackSuccess(product: [ProductBack])
    func onGetProductByCategoryBackError()
}

protocol createProductBackDelegate {
    func onCreateProductBackSuccess(message: String)
    func onCreateProductBackError(code: Int, err: String)
}

protocol updateProductBackDelegate {
    func onUpdateProductBackSuccess(message: String)
    func onUpdateProductBackError(code: Int, err: String)
}

protocol deleteProductBackDelegate {
    func onDeleteProductBackSuccess(message: String)
    func onDeleteProductBackError(code: Int, err: String)
}

extension APIBack {
    func getProductByBarcode(productBarcode: String, delegate: GetOneProductBackDelegate) {
        class process : RequestBackDelegate {
            
            private dynamic var delegate: GetOneProductBackDelegate?
            init(delegate: GetOneProductBackDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                do {
                    let type = try JSONSerialization.jsonObject(with: json, options: []) as? [String: AnyObject] ?? [:]
                    
                    let myProd = ProductBack()
                    myProd.parse(type: type)
                    
                    delegate?.onGetOneProductBackSuccess(product: myProd)
                }
                catch {
                    self.delegate!.onGetOneProductBackError()
                }
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.onGetOneProductBackError()
            }
        }
        self.request(path: "products/barcode/\(productBarcode)", method: .GET, body: [:], delegate: process(delegate: delegate))
    }
    
    func getAllProduct(delegate: GetAllProductsBackDelegate) {
        class process : RequestBackDelegate {
            
            
            private dynamic var delegate: GetAllProductsBackDelegate?
            init(delegate: GetAllProductsBackDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data){
                do {
                    let type = try JSONSerialization.jsonObject(with: json, options: []) as? [[String: AnyObject]] ?? [[:]]
                    var allProducts = [ProductBack] ()
                    for config in type {
                        let oneCat = ProductBack()
                        oneCat.parse(type: config)
                        allProducts.append(oneCat)
                    }
                    
                    delegate?.onGetAllProductsBackSuccess(products: allProducts)
                }
                catch {
                    self.delegate!.onGetAllProductsBackError()
                }
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.onGetAllProductsBackError()
            }
        }
        self.request(path: "products/", method: .GET, body: [:], delegate: process(delegate: delegate))
    }
    
    
    func getProductByCatgeory(category: Category, delegate: GetProductByCategoryBackDelegate) {
        class process : RequestBackDelegate {
            
            private dynamic var delegate: GetProductByCategoryBackDelegate?
            init(delegate: GetProductByCategoryBackDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                do {
                    let type = try JSONSerialization.jsonObject(with: json, options: []) as? [[String: AnyObject]] ?? [[:]]
                    let array = type
                    var allCategory = [ProductBack] ()
                    for config in array {
                        let oneCat = ProductBack()
                        oneCat.parse(type: config)
                        allCategory.append(oneCat)
                    }
                    delegate?.onGetProductByCategoryBackSuccess(product: allCategory)
                }
                catch {
                    self.delegate!.onGetProductByCategoryBackError()
                }
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.onGetProductByCategoryBackError()
            }
        }
        self.request(path: "products/categories/\(category.id)", method: .GET, body: [:], delegate: process(delegate: delegate))
    }
    
    func createProduct(product: ProductBack, delegate: createProductBackDelegate) {
        class process : RequestBackDelegate {
            
            private dynamic var delegate: createProductBackDelegate?
            init(delegate: createProductBackDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                delegate?.onCreateProductBackSuccess(message: "Product created successfully")
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.onCreateProductBackError(code: error_code, err: error)
            }
        }
        self.request(path: "products", method: .POST, body: ["name": product.name, "brand": product.brand, "img_url": product.image_url, "price": product.price, "vat_percent": 20, "bar_code": product.barcode, "category": product.category.id], delegate: process(delegate: delegate))
    }
    
    func updateProduct(product: ProductBack, delegate: updateProductBackDelegate) {
        class process : RequestBackDelegate {
            
            private dynamic var delegate: updateProductBackDelegate?
            init(delegate: updateProductBackDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                delegate?.onUpdateProductBackSuccess(message: "Product updated successfully")
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.onUpdateProductBackError(code: error_code, err: error)
            }
            
        }
        self.request(path: "products/\(product.id)", method: .PUT, body: ["name": product.name, "brand": product.brand, "img_url": product.image_url, "price": product.price, "vat_percent": 20, "bar_code": product.barcode, "category": product.category.id], delegate: process(delegate: delegate))
    }
    
    func deleteProduct(product: ProductBack, delegate: deleteProductBackDelegate) {
        class process : RequestBackDelegate {
            private dynamic var delegate: deleteProductBackDelegate?
            
            init(delegate: deleteProductBackDelegate) {
                self.delegate = delegate
            }
            
            func onSuccessBackDelegate(json: Data) {
                delegate?.onDeleteProductBackSuccess(message: "Product deleted successfully")
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.onDeleteProductBackError(code: error_code, err: error)
            }
            
            
        }
        self.request(path: "products/\(product.id)", method: .DELETE, body: [:], delegate: process(delegate: delegate))
    }
}

