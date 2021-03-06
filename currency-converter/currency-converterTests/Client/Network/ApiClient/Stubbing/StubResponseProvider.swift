//
//  StubResponseProvider.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/22/22.
//

import Foundation
@testable import currency_converter

public class StubResponseProvider{
    public static func getType<T: Codable>(type: T.Type) -> T{
        var result: T!
        
        if T.self is Currency.Type {
            result = Currency() as! T
        }
        
        else if T.self is NetworkError.Type {
            result = NetworkError.none as! T
        }
        
        return result
    }
    
    public static func getResponse<T: Codable>(type: T.Type) -> T{
        var result: T!
        
        // model type is currency
        if type is Currency.Type {
            let data  = StubResponseProvider.getData(type: type.self)
            
            if let data = data {
                result = try? JSONDecoder().decode(type, from: data)
            }else {
                result = Currency() as! T
            }
        }
        
        return result
    }
    
    public static func getErrorResponse<T: Error>(type: T.Type) -> T {
        var result: T!
        
        // model type is NetworkError
        if T.self is NetworkError.Type {
            result = NetworkError.serverError(code: 404, message: currencyExchangeFailedResponse["error_description"].unwrappedValue) as! T
        }
        
        // model type is ValidationError
        if T.self is ValidationError.Type {
            result = ValidationError.notEnoughBalance(code: 101, message: currencyExchangeValidationFailedResponse["error_description"].unwrappedValue) as! T
        }
        
        return result
    }
    
    public static func getData<T: Codable>(type: T.Type) -> Data?{
        var response: [String : Any] = [String:Any]()
        var data: Data? = nil
        
        if T.self is Currency.Type {
            response = currencyExchangeSuccessResponse
        }
        
        data = try? JSONSerialization.data(withJSONObject: response, options: .fragmentsAllowed)
        AppLogger.info("StubResponseProvider -- get() -- response = \((try? JSONSerialization.jsonObject(with: data ?? Data([]), options: .allowFragments)) ?? NSDictionary())")
        
        return data
    }
}
