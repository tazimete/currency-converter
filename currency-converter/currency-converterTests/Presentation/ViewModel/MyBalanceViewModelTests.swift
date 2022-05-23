//
//  CurrencyViewModelTests.swift
//  currency-converterTests
//
//  Created by AGM Tazim on 5/23/22.
//

import XCTest
@testable import currency_converter
import RxSwift

class MyBalanceViewModelTests: XCTestCase {
    private var myBalanceViewModel: MyBalanceViewModel!
    private var disposeBag: DisposeBag!

    override func setUp() {
        (UserSessionDataClient.shared as! UserSessionDataClient).changeIntegractor(interactor: MockLocalStorageInteractor())
        let dbClient = DatabaseClient.shared
        dbClient.changeIntegractor(interactor: MockLocalStorageInteractor.shared)
        let apiClient = MockAPIClient.shared
        
        let repository = CurrencyRepository(localDataSource: MockLocalCurrencyDataSource(dbClient: dbClient), remoteDataSource: MockRemoteCurrencyDataSource(apiClient: apiClient))
        let usecase = CurrencyUsecase(repository: repository)
        
        let commissionCalculator = ComissionCalculator(commissionOptions: ComissionDependency.shared, policies: [FirstFiveConversionComissionPolicy(commissionOptions: ComissionDependency.shared), EveryTenthComissionPolicy(commissionOptions: ComissionDependency.shared), UpToTwoHundredPolicy(commissionOptions: ComissionDependency.shared)])
        let balanceExecutor = BalanceOperationExecutor(operation: BalanceCheckOperation())
        
        myBalanceViewModel = MyBalanceViewModel(usecase: usecase, commissionCalculator: commissionCalculator, balanceExecutor: balanceExecutor)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        (UserSessionDataClient.shared as! UserSessionDataClient).changeIntegractor(interactor: UserDefaults.shared)
        myBalanceViewModel = nil
        disposeBag = nil
    }
    
    func testDependencies() {
        XCTAssertNotNil(myBalanceViewModel.commissionCalculator)
        XCTAssertEqual(myBalanceViewModel.commissionCalculator.policies.count, 3)
        XCTAssertNotNil(myBalanceViewModel.balanceExecutor)
        XCTAssertNotNil(myBalanceViewModel.balanceExecutor.operation)
        XCTAssertNotNil(myBalanceViewModel.usecase)
        XCTAssertNotNil(myBalanceViewModel.usecase.repository)
        XCTAssertNotNil(myBalanceViewModel.usecase.repository.localDataSource)
        XCTAssertNotNil(myBalanceViewModel.usecase.repository.remoteDataSource)
        XCTAssertNotNil(myBalanceViewModel.usecase.repository.localDataSource.dbClient)
        XCTAssertNotNil(myBalanceViewModel.usecase.repository.remoteDataSource.apiClient)
        XCTAssertNotNil(myBalanceViewModel.usecase.repository.localDataSource.dbClient.interactor)
        XCTAssertNotNil(myBalanceViewModel.usecase.repository.remoteDataSource.apiClient.session)
    }
    
    func testBalanceExchangeWithSuccessResponse() {
        let expectation = self.expectation(description: "Wait for my balance viewmodel to load.")
        let fromAmount = "100"
        let fromCurrency = "USD"
        let toCurrency = "EUR"
        var result: Balance!
        
        let input = MyBalanceViewModel.MyBalanceInput(currencyConverterTrigger: Observable.just(MyBalanceViewModel.CurrencyConverterInput(fromAmount: fromAmount, fromCurrency: fromCurrency , toCurrency: toCurrency)), addCurrencyTrigger: Observable.just(Balance(amount: 0.0, currency: "SGD")))
        let output = myBalanceViewModel.getMyBalanceOutput(input: input)
        
        // observe balance exchange response
        output.balance
            .asDriver()
            .drive(onNext: { response in
                guard let balance = response else {
                    return
                }
                
                result = balance
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        
        //stubbed response to check data which are received through non-mock components
        let entity = StubResponseProvider.getResponse(type: CurrencyApiRequest.ItemType.self)
        let stubbedResposne = Balance(amount: Double(entity.amount.unwrappedValue).unwrappedValue, currency: entity.title.unwrappedValue)
        
        //assertions
        XCTAssertNotNil(result)
        XCTAssertEqual(result.amount, stubbedResposne.amount)
        XCTAssertEqual(result.currency, stubbedResposne.currency)
        XCTAssertTrue((result.amount.unwrappedValue == stubbedResposne.amount.unwrappedValue))
        XCTAssertTrue((result.currency?.elementsEqual(stubbedResposne.currency.unwrappedValue)).unwrappedValue)
        XCTAssertEqual(try XCTUnwrap(result.currency, "Empty currency"), try XCTUnwrap(stubbedResposne.currency, "Empty currency"))
    }
    
    func testBalanceExchangeWithValidationErrorResponse() {
        let expectation = self.expectation(description: "Wait for my balance viewmodel to load.")
        let fromAmount = "122200"
        let fromCurrency = "USD"
        let toCurrency = "EUR"
        var validationError: ValidationError?
        
        let input = MyBalanceViewModel.MyBalanceInput(currencyConverterTrigger: Observable.just(MyBalanceViewModel.CurrencyConverterInput(fromAmount: fromAmount, fromCurrency: fromCurrency , toCurrency: toCurrency)), addCurrencyTrigger: Observable.just(Balance(amount: 0.0, currency: "SGD")))
        let output = myBalanceViewModel.getMyBalanceOutput(input: input)
        
        // detect validation error
        output.validationError
            .asDriver()
            .drive(onNext: { error in
                guard let error = error else {
                    return
                }
            
                validationError = error
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        
        wait(for: [expectation], timeout: 5)
        
        //stubbed response to check data which are received through non-mock components
        let stubbedResposne = StubResponseProvider.getErrorResponse(type: ValidationError.self)
        
        //assertions
        XCTAssertNotNil(validationError)
        XCTAssertEqual((validationError?.errorCode).unwrappedValue, stubbedResposne.errorCode)
        XCTAssertEqual(validationError?.errorMessage, stubbedResposne.errorMessage)
        XCTAssertEqual((validationError?.errorMessage).unwrappedValue, stubbedResposne.errorMessage)
    }
}

