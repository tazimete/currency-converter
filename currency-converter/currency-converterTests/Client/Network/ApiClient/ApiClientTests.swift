//
//  ApiClientTests.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/22/22.
//

import XCTest
@testable import currency_converter
import RxSwift


class ApiClientTest: XCTestCase {
    private var apiClient: ApiClient!
    private var disposeBag: DisposeBag!

    override func setUp() {
        apiClient = ApiClient.shared
        apiClient.changeMockSession(session: MockURLSessionSucess(configuration: URLSessionConfigHolder.config))
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        apiClient = nil
        disposeBag = nil
    }
    
    func testApiClientWithCurrencyExchangeSucces() {
        let amount = "45875"
        let currency = "JPY"
        
        let request = CurrencyApiRequest.convert(params: CurrencyConverterParams(fromAmount: amount, fromCurrency: currency, toCurrency: currency))
        let expectation = self.expectation(description: "Wait for \(request.path) to load.")
        var result: CurrencyApiRequest.ItemType!
        var networkError: NetworkError?
        
        apiClient.send(apiRequest: request, type: CurrencyApiRequest.ItemType.self)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                result = response
                expectation.fulfill()
            }, onError: { error in
                networkError = error as? NetworkError
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        
        //stubbed response to check data which are received through non-mock components
        let stubbedResposne = StubResponseProvider.getResponse(type: CurrencyApiRequest.ItemType.self)
        
        //assertions
        XCTAssertNotNil(result)
        XCTAssertEqual(result.amount, stubbedResposne.amount)
        XCTAssertEqual(result.title, stubbedResposne.title)
        XCTAssertNotEqual(result.amount, stubbedResposne.title)
        XCTAssertNotEqual(result.title, stubbedResposne.amount)
        XCTAssertTrue((result.amount?.elementsEqual(stubbedResposne.amount.unwrappedValue)).unwrappedValue)
        XCTAssertTrue((result.title?.elementsEqual(stubbedResposne.title.unwrappedValue)).unwrappedValue)
        XCTAssertEqual(try XCTUnwrap(result.amount, "Empty amount"), try XCTUnwrap(stubbedResposne.amount, "Empty amount"))
        XCTAssertEqual(try XCTUnwrap(result.title, "Empty title"), try XCTUnwrap(stubbedResposne.title, "Empty title"))
        XCTAssertNil(networkError)
    }
    
    func testApiClientWithCurrencyExchangeFailed() {
        let amount = "45875"
        let currency = "JPY"
        
        let request = CurrencyApiRequest.convert(params: CurrencyConverterParams(fromAmount: amount, fromCurrency: currency, toCurrency: currency))
        let expectation = self.expectation(description: "Wait for \(request.path) to load.")
        var result: CurrencyApiRequest.ItemType!
        var networkError: NetworkError?
        
        apiClient.changeMockSession(session: MockURLSessionFailed(configuration: URLSessionConfigHolder.config))
        
        apiClient.send(apiRequest: request, type: CurrencyApiRequest.ItemType.self)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                result = response
                expectation.fulfill()
            }, onError: { error in
                networkError = error as? NetworkError
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        
        //stubbed response to check data which are received through non-mock components
        let stubbedResposne = StubResponseProvider.getErrorResponse(type: NetworkError.self)
        
        //assertions
        XCTAssertNil(result)
        XCTAssertNotNil(networkError)
        XCTAssertEqual((networkError?.errorCode).unwrappedValue, stubbedResposne.errorCode)
        XCTAssertEqual(networkError?.errorMessage, stubbedResposne.errorMessage)
        XCTAssertEqual((networkError?.errorMessage).unwrappedValue, stubbedResposne.errorMessage)
    }
    
    func testApiClientPerformance() throws {
        // This is performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let amount = "45875"
            let currency = "JPY"
            
            let request = CurrencyApiRequest.convert(params: CurrencyConverterParams(fromAmount: amount, fromCurrency: currency, toCurrency: currency))
            let expectation = self.expectation(description: "Wait for \(request.path) to load.")
            var result: CurrencyApiRequest.ItemType!
            var networkError: NetworkError?
            
            apiClient.send(apiRequest: request, type: CurrencyApiRequest.ItemType.self)
                .observe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
                .subscribe(on: MainScheduler.instance)
                .subscribe(onNext: { response in
                    result = response
                    expectation.fulfill()
                }, onError: { error in
                    networkError = error as? NetworkError
                    expectation.fulfill()
                }).disposed(by: disposeBag)
            
            wait(for: [expectation], timeout: 5)
            
            //stubbed response to check data which are received through non-mock components
            let stubbedResposne = StubResponseProvider.getResponse(type: CurrencyApiRequest.ItemType.self)
            
            //assertions
            XCTAssertNotNil(result)
            XCTAssertEqual(result.amount, stubbedResposne.amount)
            XCTAssertEqual(result.title, stubbedResposne.title)
            XCTAssertNotEqual(result.amount, stubbedResposne.title)
            XCTAssertNotEqual(result.title, stubbedResposne.amount)
            XCTAssertTrue((result.amount?.elementsEqual(stubbedResposne.amount.unwrappedValue)).unwrappedValue)
            XCTAssertTrue((result.title?.elementsEqual(stubbedResposne.title.unwrappedValue)).unwrappedValue)
            XCTAssertNil(networkError)
        }
    }
}

