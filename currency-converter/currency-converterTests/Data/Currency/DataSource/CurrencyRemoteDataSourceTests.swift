//
//  CurrencyRemoteDataSourceTests.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

import XCTest
@testable import currency_converter
import RxSwift

class CurrencyRemoteDataSourceTests: XCTestCase {
    private var currencyRemoteDataSource: AbstractCurrencyRemoteDataSource!
    private var disposeBag: DisposeBag!

    override func setUp() {
        currencyRemoteDataSource = MockRemoteCurrencyDataSource(apiClient: MockAPIClient.shared)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        currencyRemoteDataSource = nil
        disposeBag = nil
    }
    
    func testDependencies() {
        XCTAssertNotNil(currencyRemoteDataSource)
        XCTAssertNotNil(currencyRemoteDataSource.apiClient)
        XCTAssertNotNil(currencyRemoteDataSource.apiClient.session)
    }
    
    func testGet() {
        let expectation = self.expectation(description: "Wait for currency remote data source to load.")
        let amount = "45875"
        let currency = "JPY"
        var result: CurrencyApiRequest.ItemType!
        var networkError: NetworkError?
        
        currencyRemoteDataSource.get(fromAmount: amount, fromCurrency: currency, toCurrency: currency)
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

}

