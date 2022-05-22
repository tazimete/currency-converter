//
//  MockUrlSession.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/22/22.
//

import Foundation
@testable import currency_converter

class MockURLSessionSucess: AbstractURLSession {
    var responseType: Codable.Type?
    
    required init(config: URLSessionConfiguration = URLSessionConfigHolder.config) {
        defaultConfig = configuration
    }
    
    func dataTask<T: Codable>(with request: URLRequest, type: T.Type, completionHandler: @escaping URLSessionDataTaskResult) -> URLSessionDataTask {
        let data = StubResponseProvider.getData(type: type)
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "1.0", headerFields: request.allHTTPHeaderFields)
        let error: Error? = nil
        
        completionHandler(data, response, error)
        
        return URLSession.shared.dataTask(with: request.url!)
    }
}

class MockURLSessionFailed: AbstractURLSession {
    var responseType: Codable.Type?
    
    required init(config: URLSessionConfiguration = URLSessionConfigHolder.config) {
        defaultConfig = configuration
    }
    
    func dataTask<T: Codable>(with request: URLRequest, type: T.Type, completionHandler: @escaping URLSessionDataTaskResult) -> URLSessionDataTask {
        let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: "1.0", headerFields: request.allHTTPHeaderFields)
        let error: Error? = NetworkError.serverError(code: 404, message: "Currency not found")
        let data = try? JSONSerialization.data(withJSONObject: currencyExchangeFailedResponse, options: .fragmentsAllowed)
        
        completionHandler(data, response, error)
        
        return URLSession.shared.dataTask(with: request.url!)
    }
}

