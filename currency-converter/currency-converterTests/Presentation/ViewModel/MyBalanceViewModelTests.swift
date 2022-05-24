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
        (myBalanceViewModel.usecase.repository.remoteDataSource.apiClient as! MockAPIClient).changeMockSession(session: MockURLSessionSucess())
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
    
    func test_balanceExchange_withSuccess_response() {
        let expectation = self.expectation(description: "Wait for my balance viewmodel -> test_balanceExchange_withSuccess_response() to load.")
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
    
    func test_balanceExchange_with_validationError() {
        let expectation = self.expectation(description: "Wait for my balance viewmodel -> test_balanceExchange_with_validationError() to load.")
        let fromAmount = "122200"
        let fromCurrency = "USD"
        let toCurrency = "EUR"
        var validationError: ValidationError?
        
        myBalanceViewModel.currencyExchange.sell = Balance(amount: Double(fromAmount).unwrappedValue, currency: fromCurrency)
        myBalanceViewModel.currencyExchange.receive = Balance(amount: nil, currency: toCurrency)
        
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
    
    func test_balanceExchange_with_errorResponse() {
        let expectation = self.expectation(description: "Wait for my balance viewmodel -> test_balanceExchange_with_errorResponse() to load.")
        let fromAmount = "100"
        let fromCurrency = "USD"
        let toCurrency = "EUR"
        var networkError: NetworkError?
        
        myBalanceViewModel.currencyExchange.sell = Balance(amount: Double(fromAmount).unwrappedValue, currency: fromCurrency)
        myBalanceViewModel.currencyExchange.receive = Balance(amount: nil, currency: toCurrency)
        (myBalanceViewModel.usecase.repository.remoteDataSource.apiClient as! MockAPIClient).changeMockSession(session: MockURLSessionFailed())
        
        let input = MyBalanceViewModel.MyBalanceInput(currencyConverterTrigger: Observable.just(MyBalanceViewModel.CurrencyConverterInput(fromAmount: fromAmount, fromCurrency: fromCurrency , toCurrency: toCurrency)), addCurrencyTrigger: Observable.just(Balance(amount: 0.0, currency: "SGD")))
        let output = myBalanceViewModel.getMyBalanceOutput(input: input)
        
        // detect validation error
        output.errorResponse
            .asDriver()
            .drive(onNext: { error in
                guard let error = error else {
                    return
                }
            
                networkError = error
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        
        //stubbed response to check data which are received through non-mock components
        let stubbedResposne = StubResponseProvider.getErrorResponse(type: NetworkError.self)
        
        //assertions
        XCTAssertNotNil(networkError)
        XCTAssertEqual((networkError?.errorCode).unwrappedValue, stubbedResposne.errorCode)
        XCTAssertEqual(networkError?.errorMessage, stubbedResposne.errorMessage)
        XCTAssertEqual((networkError?.errorMessage).unwrappedValue, stubbedResposne.errorMessage)
    }
    
    func test_balanceList() {
        let expectation = self.expectation(description: "Wait for my balance viewmodel -> testBalanceList() to load.")
        var balanceList: [Balance]!
        
        // detect validation error
        myBalanceViewModel.balanceListRelay
            .asDriver()
            .drive(onNext: { balances in
                balanceList = balances
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        
        //stubbed response to check data which are received through non-mock components
        let stubbedData: [Balance] = EntityFactory().createList(type: .balance) as! [Balance]
        
        //assertions
        XCTAssertNotNil(balanceList)
        XCTAssertEqual(balanceList.count, stubbedData.count)
        XCTAssertEqual(balanceList.first?.currency, stubbedData.first?.currency)
        XCTAssertEqual((balanceList.first?.currency).unwrappedValue, (stubbedData.first?.currency).unwrappedValue)
        XCTAssertNotEqual((balanceList.first?.currency).unwrappedValue, (stubbedData.last?.currency).unwrappedValue)
    }
    
    func test_hasEnoughBalance_with_true() {
        let fromAmount = "100"
        let fromCurrency = "USD"
        var result: Bool?
        
        myBalanceViewModel.currencyExchange.sell = Balance(amount: Double(fromAmount).unwrappedValue, currency: fromCurrency)
        
        result = myBalanceViewModel.hasEnoughBalance()
        
        //assertions
        XCTAssertNotNil(result)
        XCTAssertEqual(result.unwrappedValue, true)
        XCTAssertNotEqual(result.unwrappedValue, false)
    }
    
    func test_hasEnoughBalance_with_false() {
        let fromAmount = "25000"
        let fromCurrency = "USD"
        var result: Bool?
        
        myBalanceViewModel.currencyExchange.sell = Balance(amount: Double(fromAmount).unwrappedValue, currency: fromCurrency)
        
        result = myBalanceViewModel.hasEnoughBalance()
        
        //assertions
        XCTAssertNotNil(result)
        XCTAssertEqual(result.unwrappedValue, false)
        XCTAssertNotEqual(result.unwrappedValue, true)
    }
    
    func test_calculateCommission_withConversionCount_lessThanFive_amount_100() {
        let fromAmount = "100"
        let fromCurrency = "USD"
        var result: Double?
        
        myBalanceViewModel.currencyExchange.sell = Balance(amount: Double(fromAmount).unwrappedValue, currency: fromCurrency)
        UserSessionDataClient.shared.setConversionCount(count: 1)
        
        result = myBalanceViewModel.calculateCommission()
        
        //assertions
        XCTAssertNotNil(result)
        XCTAssertEqual(result.unwrappedValue, 0.0)
        XCTAssertNotEqual(result.unwrappedValue, 1.40)
    }
    
    func test_calculateCommission_withConversionCoutn_greaterThanFive_amount_100() {
        let fromAmount = "100"
        let fromCurrency = "USD"
        var result: Double?
        
        myBalanceViewModel.currencyExchange.sell = Balance(amount: Double(fromAmount).unwrappedValue, currency: fromCurrency)
        UserSessionDataClient.shared.setConversionCount(count: 6)
        
        result = myBalanceViewModel.calculateCommission()
        
        //assertions
        XCTAssertNotNil(result)
        XCTAssertEqual(result.unwrappedValue, 0.0)
        XCTAssertNotEqual(result.unwrappedValue, 1.40)
    }
    
    func test_calculateCommission_withConversionCount_greaterThanFive_amount_250() {
        let fromAmount = "250"
        let fromCurrency = "USD"
        var result: Double?
        
        myBalanceViewModel.currencyExchange.sell = Balance(amount: Double(fromAmount).unwrappedValue, currency: fromCurrency)
        UserSessionDataClient.shared.setConversionCount(count: 6)
        
        result = myBalanceViewModel.calculateCommission()
        
        //assertions
        XCTAssertNotNil(result)
        XCTAssertEqual(result.unwrappedValue, 1.75)
        XCTAssertNotEqual(result.unwrappedValue, 0.0)
        XCTAssertNotEqual(result.unwrappedValue, 2.00)
    }
    
    func test_calculateCommission_withConversionCount_lessThanFive_amount_250() {
        let fromAmount = "250"
        let fromCurrency = "USD"
        var result: Double?
        
        myBalanceViewModel.currencyExchange.sell = Balance(amount: Double(fromAmount).unwrappedValue, currency: fromCurrency)
        UserSessionDataClient.shared.setConversionCount(count: 1)
        
        result = myBalanceViewModel.calculateCommission()
        
        //assertions
        XCTAssertNotNil(result)
        XCTAssertEqual(result.unwrappedValue, 0.00)
        XCTAssertNotEqual(result.unwrappedValue, 1.75)
        XCTAssertNotEqual(result.unwrappedValue, 2.00)
    }
    
    func test_calculateCommission_withConversionCount_greaterThanFive_amount_100() {
        let fromAmount = "100"
        let fromCurrency = "USD"
        var result: Double?
        
        myBalanceViewModel.currencyExchange.sell = Balance(amount: Double(fromAmount).unwrappedValue, currency: fromCurrency)
        UserSessionDataClient.shared.setConversionCount(count: 15)
        
        result = myBalanceViewModel.calculateCommission()
        
        //assertions
        XCTAssertNotNil(result)
        XCTAssertEqual(result.unwrappedValue, 0.00)
        XCTAssertNotEqual(result.unwrappedValue, 1.75)
        XCTAssertNotEqual(result.unwrappedValue, 2.00)
    }
    
    func test_calculateCommission_withConversionCount_everyTenth_amount_250() {
        let fromAmount = "250"
        let fromCurrency = "USD"
        var result: Double?
        
        myBalanceViewModel.currencyExchange.sell = Balance(amount: Double(fromAmount).unwrappedValue, currency: fromCurrency)
        UserSessionDataClient.shared.setConversionCount(count: 50)
        
        result = myBalanceViewModel.calculateCommission()
        
        //assertions
        XCTAssertNotNil(result)
        XCTAssertEqual(result.unwrappedValue, 0.00)
        XCTAssertNotEqual(result.unwrappedValue, 1.75)
        XCTAssertNotEqual(result.unwrappedValue, 2.00)
    }
    
    func test_convetCurrency_withSuccessResponse() {
        let expectation = self.expectation(description: "Wait for my balance viewmodel -> test_convetCurrency_withSuccessResponse() to load.")
        let fromAmount = "100"
        let fromCurrency = "USD"
        let toCurrency = "EUR"
        var result: Currency!
        var networkError: NetworkError!
        
        myBalanceViewModel.convert(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency)
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .utility))
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { currency in
                result = currency
                expectation.fulfill()
            }, onError: { error in
                networkError = error as! NetworkError
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
        
        //stubbed response to check data which are received through non-mock components
        let stubbedResposne = StubResponseProvider.getResponse(type: CurrencyApiRequest.ItemType.self)
        
        //assertions
        XCTAssertNotNil(result)
        XCTAssertNil(networkError)
        XCTAssertEqual(result.amount, stubbedResposne.amount)
        XCTAssertEqual(result.title, stubbedResposne.title)
        XCTAssertTrue((result.amount.unwrappedValue == stubbedResposne.amount.unwrappedValue))
        XCTAssertTrue((result.title?.elementsEqual(stubbedResposne.title.unwrappedValue)).unwrappedValue)
        XCTAssertEqual(try XCTUnwrap(result.title, "Empty currency"), try XCTUnwrap(stubbedResposne.title, "Empty currency"))
    }
    
    func test_convetCurrency_withFailedResponse() {
        let expectation = self.expectation(description: "Wait for my balance viewmodel -> test_convetCurrency_withFailedResponse() to load.")
        let fromAmount = "100"
        let fromCurrency = "USD"
        let toCurrency = "EUR"
        var result: Currency!
        var networkError: NetworkError!
        
        (myBalanceViewModel.usecase.repository.remoteDataSource.apiClient as! MockAPIClient).changeMockSession(session: MockURLSessionFailed())
        
        myBalanceViewModel.convert(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency)
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .utility))
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { currency in
                result = currency
                expectation.fulfill()
            }, onError: { error in
                networkError = error as! NetworkError
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
    
    func test_calculateFinalBalance_withSellAmount_250_usd() {
        let fromAmount = 250.00
        let fromCurrency = "USD"
        let toAmount = 233.53
        let toCurrency = "EUR"
        let balances: [Balance] = EntityFactory().createList(type: .balance) as! [Balance]
        var result: [Balance]?
        
        let fromBalanceIndex = balances.firstIndex(where: {($0.currency?.elementsEqual(fromCurrency)).unwrappedValue}).unwrappedValue
        let toBalanceIndex = balances.firstIndex(where: {($0.currency?.elementsEqual(toCurrency)).unwrappedValue}).unwrappedValue
        
        let fromAmountPrevious = balances[fromBalanceIndex].amount.unwrappedValue
        let toAmountPrevious = balances[toBalanceIndex].amount.unwrappedValue
        
        myBalanceViewModel.currencyExchange.sell = Balance(amount: fromAmount, currency: fromCurrency)
        myBalanceViewModel.currencyExchange.receive = Balance(amount: toAmount, currency: toCurrency)
        
        UserSessionDataClient.shared.setConversionCount(count: 35)
        
        result = myBalanceViewModel.calculatFinalBalances()
        
        let fromBalanceNow = (fromAmountPrevious-fromAmount-myBalanceViewModel.calculateCommission())
        let toBalanceNow = (100+toAmount)
        
        //assertions
        XCTAssertNotNil(result)
        XCTAssertEqual((result?.count).unwrappedValue, 3)
        XCTAssertEqual((result?[fromBalanceIndex].amount).unwrappedValue, fromBalanceNow)
        XCTAssertEqual((result?[fromBalanceIndex].currency).unwrappedValue, fromCurrency)
        XCTAssertEqual((result?[toBalanceIndex].amount).unwrappedValue, toBalanceNow)
        XCTAssertEqual((result?[toBalanceIndex].currency).unwrappedValue, toCurrency)
    }
}

