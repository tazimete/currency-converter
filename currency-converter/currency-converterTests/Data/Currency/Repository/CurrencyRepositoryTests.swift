//
//  CurrencyRepositoryTests.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

import XCTest
@testable import currency_converter
import RxSwift

class CurrencyRepositoryTests: XCTestCase {
    private var currencyRepository: AbstractCurrencyRepository!
    private var disposeBag: DisposeBag!

    override func setUp() {
        let dbClient = DatabaseClient.shared
        dbClient.changeIntegractor(interactor: MockLocalStorageInteractor.shared)
        currencyRepository = CurrencyRepository(localDataSource: MockLocalCurrencyDataSource(dbClient: dbClient), remoteDataSource: MockRemoteCurrencyDataSource(apiClient: MockAPIClient.shared))
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        currencyRepository = nil
        disposeBag = nil
    }
    
    func testDependencies() {
        XCTAssertNotNil(currencyRepository.localDataSource)
        XCTAssertNotNil(currencyRepository.remoteDataSource)
        XCTAssertNotNil(currencyRepository.localDataSource.dbClient)
        XCTAssertNotNil(currencyRepository.remoteDataSource.apiClient)
        XCTAssertNotNil(currencyRepository.localDataSource.dbClient.interactor)
        XCTAssertNotNil(currencyRepository.remoteDataSource.apiClient.session)
    }
    
    func testGetWithSuccessResponse() {
        let expectation = self.expectation(description: "Wait for currency repository to load.")
        let amount = "45875"
        let currency = "JPY"
        var result: CurrencyApiRequest.ItemType!
        var networkError: NetworkError?
        
        currencyRepository.get(fromAmount: amount, fromCurrency: currency, toCurrency: currency)
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
    
    func testGetWithErrorResponse() {
        let expectation = self.expectation(description: "Wait for currency remote data source to load for error response...")
        let amount = "45875"
        let currency = "JPY"
        var result: CurrencyApiRequest.ItemType!
        var networkError: NetworkError?
        
        let dbClient = DatabaseClient.shared
        dbClient.changeIntegractor(interactor: MockLocalStorageInteractor.shared)
        
        let apiClient = MockAPIClient(session: MockURLSessionFailed(configuration: URLSessionConfigHolder.config))
        
        currencyRepository = CurrencyRepository(localDataSource: MockLocalCurrencyDataSource(dbClient: dbClient), remoteDataSource: MockRemoteCurrencyDataSource(apiClient: apiClient))
        
        currencyRepository.get(fromAmount: amount, fromCurrency: currency, toCurrency: currency)
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

}
