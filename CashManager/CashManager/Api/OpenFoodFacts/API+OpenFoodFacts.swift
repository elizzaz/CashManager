//
//  OpenFoodFacts.swift
//  CashManager
//
//  Created by Anthony Luong on 29/11/2022.
//

import Foundation

enum METHOD_REQUEST {
    case POST
    case GET
    case PUT
    case DELETE
    
    var description : String {
        switch self {
        case .POST: return "POST"
        case .GET: return "GET"
        case .PUT: return "PUT"
        case .DELETE: return "DELETE"
        }
    }
}

protocol RequestDelegate {
    func onSuccessOFFDelegate(json: Data)
    func onErrorOFFDelegate(error_code: Int, error: String)
}

class ApiOpenFoodFacts {
    private let apiURL = "https://world.openfoodfacts.org/api/v2/"
    public var session = URLSession.shared
    public let debug = true
    
    func request(path: String, method: METHOD_REQUEST, body: [String: Any], delegate: RequestDelegate) {
        var debugString = "--------------\n"
        var request = URLRequest(url: URL(string: "\(self.apiURL)\(path)")!)
        request.httpMethod = method.description
        
        if (method == .PUT || method == .POST || method == .DELETE) {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaults.standard.string(forKey: "USER_TOKEN") ?? "", forHTTPHeaderField: "Authorization")
        
        let task = self.session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            if (error == nil) {
                
                debugString += "URL : \(request.url!)\n"
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    debugString += "Status Code : \(httpResponse.statusCode)\n"
                    
                    debugString += "Method: \(method.description)\n"
                    
                    debugString += "Data : \n"
                    
                    do {
                        
                        if (httpResponse.statusCode == 200) {
                            
                            debugString += String(decoding: data!, as: UTF8.self)
                            
                            DispatchQueue.main.async {
                                
                                delegate.onSuccessOFFDelegate(json: data!)
                                
                            }
                            
                        } else {
                            
                            DispatchQueue.main.async {
                                
                                delegate.onErrorOFFDelegate(error_code: httpResponse.statusCode, error: "")
                                
                            }
                            
                        }
                        
                    } catch {
                        
                        DispatchQueue.main.async {
                            
                            delegate.onErrorOFFDelegate(error_code: 801, error: "")
                            
                        }
                        
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        
                        delegate.onErrorOFFDelegate(error_code: 802, error: "")
                        
                    }
                    
                }
                
            } else {
                
                DispatchQueue.main.async {
                    
                    delegate.onErrorOFFDelegate(error_code: 803, error: "")
                    
                }
                
            }
            
            debugString += "--------------"
            
            if (self.debug) {
                
                print(debugString)
                
            }
            
        })
        
        task.resume()
    }
}
