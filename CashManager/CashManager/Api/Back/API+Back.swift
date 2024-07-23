//
//  Back.swift
//  CashManager
//
//  Created by Serge Serci on 29/11/2022.
//

import Foundation

enum METHOD_REQUEST_BACK {
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

protocol RequestBackDelegate {
    func onSuccessBackDelegate(json: Data)
    func onErrorBackDelegate(error_code: Int, error: String)
}

class APIBack {

    private let apiURL = "http://localhost:8080/api/"

    public var session = URLSession.shared
    public let debug = true

    func request(path: String, method: METHOD_REQUEST_BACK, body: [String: Any], delegate: RequestBackDelegate  ) {
        var debugString = "--------------\n"
        var request = URLRequest(url: URL(string: "\(self.apiURL)\(path)")!)
        request.httpMethod = method.description
        if (method == .PUT || method == .POST || method == .DELETE) {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaults.standard.string(forKey: "JWT") ?? "", forHTTPHeaderField: "Authorization")

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
                                delegate.onSuccessBackDelegate(json: data!)
                            }
                        } else {
                            DispatchQueue.main.async {
                                delegate.onErrorBackDelegate(error_code: httpResponse.statusCode, error: "")
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            delegate.onErrorBackDelegate(error_code: 801, error: "")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        delegate.onErrorBackDelegate(error_code: 802, error: "")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    delegate.onErrorBackDelegate(error_code: 803, error: "")
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
