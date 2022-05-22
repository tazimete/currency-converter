//
//  MockApiClient.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/22/22.
//

import Foundation
@testable import currency_converter
import RxSwift


protocol MockSessionable {
    func setMockSession(session: AbstractURLSession)
}

extension ApiClient: MockSessionable {
    func setMockSession(session: AbstractURLSession) {
        self.session = session
    }
}

class MockAPIClient: AbstractApiClient{
    public static let shared = MockAPIClient()
    var session: AbstractURLSession
    let queueManager: QueueManager

    
    public init(session: AbstractURLSession = MockURLSessionSucess(config: URLSessionConfigHolder.config), withQueueManager queueManager: QueueManager = QueueManager()) {
        self.session = session
        self.queueManager = queueManager
    }
    
    public func enqueue<T: Codable>(apiRequest: APIRequest, type: T.Type, completionHandler: @escaping (NetworkCompletionHandler<T>)) {
        let operation = NetworkOperation(apiRequest: apiRequest, type: type, completionHandler: completionHandler)
        operation.qualityOfService = .utility
        queueManager.enqueue(operation)
    }
    
    public func send<T: Codable>(apiRequest: APIRequest, type: T.Type) -> Observable<T> {
        let request = apiRequest.request(with: apiRequest.baseURL)
//        let session = URLSession(configuration: config)
        
        return Observable.create { [weak self] observer -> Disposable in
            let task: URLSessionDataTask? = self?.session.dataTask(with: request, type: type) { [weak self] data, response, error in
                let resDictionary = (try? JSONSerialization.jsonObject(with: data ?? Data([]), options: .allowFragments)) as? NSDictionary
                AppLogger.debug("response = \(resDictionary)")
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    if (400...499).contains((response as? HTTPURLResponse)?.statusCode ?? 401) {
                        observer.onError(NetworkError.serverError(code: 404, message: ((resDictionary)?.value(forKey: "error_description") as? String) ?? ""))
                    }
                    
                    observer.onError(NetworkError.serverError(code: (response as? HTTPURLResponse)?.statusCode ?? 401, message: "Request failed"))
                    
                    return
                }
                
                guard let mime = response.mimeType, mime == "application/json" else {
                    observer.onError(NetworkError.wrongMimeTypeError(code: response.statusCode, message: "Wrong mimetype"))
                    return
                }

                guard let responseData = data else{
                    observer.onError(NetworkError.noDataError(code: response.statusCode, message: "No data found in response"))
                    return
                }
                 
                let resultData = try? JSONDecoder().decode(type, from: responseData)
                
                 if let result = resultData{
                    observer.onNext(result)
                 }else{
                    observer.onError(NetworkError.decodingError(code: response.statusCode, message: "Decoding error, Wrong response type"))
                 }
                
                observer.onCompleted()
            }
            task?.resume()
            
            return Disposables.create()
        }
    }
}
