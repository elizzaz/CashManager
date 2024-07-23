//
//  CategoryRequests.swift
//  CashManager
//
//  Created by Elisa Morillon on 12/12/2022.
//

import Foundation

protocol GetAllCategoryBackDelegate {
    func onGetAllCategoryBackSuccess(category: [Category])
    func onGetAllCategoryBackError()
}

protocol createCategoryDelegate {
    func createCategorySuccess(message: String)
    func createCategoryError(code: Int, err: String)
}

protocol updateCategoryDelegate {
    func updateCategorySuccess(message: String)
    func updateCategoryError(code: Int, err: String)
}

protocol deleteCategoryDelegate {
    func deleteCategorySuccess(message: String)
    func deleteCategoryError(code: Int, err: String)
}

// GET ALL
extension APIBack {
    func getAllCategory(delegate: GetAllCategoryBackDelegate) {
        class process : RequestBackDelegate {
            
            private dynamic var delegate: GetAllCategoryBackDelegate?
            init(delegate: GetAllCategoryBackDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                do {
                    let type = try JSONSerialization.jsonObject(with: json, options: []) as? [[String: AnyObject]] ?? [[:]]
                    var array = type
                    var allCategory = [Category] ()
                    for config in array {
                        var oneCat = Category()
                        oneCat.parse(type: config)
                        allCategory.append(oneCat)
                    }
//                    let type = try JSONSerialization.jsonObject(with: json, options: []) as? [String: AnyObject] ?? [:]
//
//                    let myProd = ProductBack()
//                    myProd.parse(type: type)
                    
                    delegate?.onGetAllCategoryBackSuccess(category: allCategory)
                }
                catch {
                    self.delegate!.onGetAllCategoryBackError()
                }
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.onGetAllCategoryBackError()
            }
        }
        self.request(path: "categories/", method: .GET, body: [:], delegate: process(delegate: delegate))
    }
    
    // CREATE
    func createCategory(category: Category, delegate: createCategoryDelegate) {
        class process : RequestBackDelegate{
            
            private dynamic var delegate: createCategoryDelegate?
            init(delegate: createCategoryDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                delegate?.createCategorySuccess(message: "Category created succesfuly")
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.createCategoryError(code: error_code, err: error)
            }
        }
        self.request(path: "categories", method: .POST, body: ["name": category.name], delegate: process(delegate: delegate))
    }
    
    // UPDATE
    func updateCategory(category: Category, edit: Category, delegate: updateCategoryDelegate) {
        class process : RequestBackDelegate{
            
            private dynamic var delegate: updateCategoryDelegate?
            init(delegate: updateCategoryDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                delegate?.updateCategorySuccess(message: "Category updated succesfuly")
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.updateCategoryError(code: error_code, err: error)
            }
        }
        self.request(path: "categories/\(category.id)", method: .PUT, body: ["name": edit.name], delegate: process(delegate: delegate))
    }
    
    //DELETE
    
    func deleteCategory(id: String, delegate: deleteCategoryDelegate) {
        class process : RequestBackDelegate{
            
            private dynamic var delegate: deleteCategoryDelegate?
            init(delegate: deleteCategoryDelegate) {
                self.delegate = delegate
            }
            func onSuccessBackDelegate(json: Data) {
                delegate?.deleteCategorySuccess(message: "Category deleted succesfuly")
            }
            func onErrorBackDelegate(error_code: Int, error: String) {
                self.delegate!.deleteCategoryError(code: error_code, err: error)
            }
        }
        self.request(path: "categories/\(id)", method: .DELETE, body: [:], delegate: process(delegate: delegate))
    }
}
