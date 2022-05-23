//
//  ViewController.swift
//  currency-converter
//
//  Created by AGM Tazimon 29/10/21.
//

import UIKit
import RxSwift
import RxCocoa

class MyBalanceViewController: BaseViewController {
    // MARK: Non UI Proeprties
    public var myBalanceViewModel: MyBalanceViewModel!
    private let currencyConverterTrigger = PublishSubject<MyBalanceViewModel.CurrencyConverterInput>()
    private let addCurrencyTrigger = PublishSubject<Balance>()
    
    // MARK: UI Proeprties
    private let balanceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false 
        label.text = "MY BALANCES"
        label.textColor = AppConfig.shared.getTheme().getColors().disabledTextColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.applyAdaptiveLayout()
        return label
    }()
    
    private lazy var balanceListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 40)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = AppConfig.shared.getTheme().getColors().primaryBackgroundColor
        collectionView.isUserInteractionEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        collectionView.isPagingEnabled = false
        collectionView.clipsToBounds = true
        
        if #available(iOS 11.0, *) {
          collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        //cell registration
        collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        collectionView.register(BalanceItemCell.self, forCellWithReuseIdentifier: BalanceItemCellConfig.reuseId)
        
        return collectionView
    }()
    
    private let currencyExchangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CURRENCY EXCHANGE"
        label.textColor = AppConfig.shared.getTheme().getColors().disabledTextColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.applyAdaptiveLayout()
        return label
    }()

    private lazy var currencyExchangeSellView: CurrencyExcangeView = {
        let view = CurrencyExcangeView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.currencies = self.myBalanceViewModel.balanceListRelay.value.map({ return $0.currency ?? ""})
        view.amountText = "0.00"
        return view
    }()
    
    private lazy var currencyExchangeReceivedView: CurrencyExcangeView = {
        let view = CurrencyExcangeView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleIconBackground = .systemGreen
        view.titleText = "Received"
        view.amountTextColor = .systemGreen
        view.amountText = "+ 0.00"
        view.isAmountFieldEditable = false
        view.currencies = self.myBalanceViewModel.balanceListRelay.value.map({ return $0.currency ?? ""})
        return view
    }()

    private let submitButton: UIButton = {
        let button = UIButton(frame: .zero, setAdaptive: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppConfig.shared.getTheme().getColors().primaryDark
        button.setTitle("SUBMIT", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.borderWidth = 1
        button.borderColor = AppConfig.shared.getTheme().getColors().primaryBackgroundColor
        button.layer.cornerRadius = CGFloat(20).relativeToIphone8Width()
        button.addShadow()
        
        return button
    }()
    
    // MARK: Constructors
    init(viewModel: MyBalanceViewModel) {
        super.init(viewModel: viewModel)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Overrriden MethodS
    override func initView() {
        super.initView()
        //setup view
        view.backgroundColor = .white
        
        //collection view
        observeBalanceItems()
        onTapTableviewCell()
    }
    
    override func initNavigationBar() {
        super.initNavigationBar()
        
        self.navigationItem.title = "Currency Converter"
        let btnAction = UIBarButtonItem(title: "ADD", style: .done, target: self, action: #selector(didTapAddButton))
        btnAction.tintColor = appColors.textColorLight
        self.navigationItem.rightBarButtonItem = btnAction
    }
    
    override func addSubviews() {
        addBalanceView()
        addCurrencyExchangeView()
        addSubmitButton()
    }
    
    override func addActionsToSubviews() {
        // observe sell currency to exchange
        currencyExchangeSellView.selectionHandler
            .subscribe(onNext: { [weak self] currency in
                guard let weakSelf = self, let currency =  currency else {
                    return
                }
                
                AppLogger.info("Selected currency : \(currency)")
                weakSelf.myBalanceViewModel.currencyExchange.sell = currency
            }).disposed(by: disposeBag)
        
        // observe receive currency to exchange
        currencyExchangeReceivedView.selectionHandler
            .subscribe(onNext: { [weak self] currency in
                guard let weakSelf = self, let currency =  currency else {
                    return
                }
                
                AppLogger.info("Selected currency : \(currency)")
                weakSelf.myBalanceViewModel.currencyExchange.receive = currency
            }).disposed(by: disposeBag)
        
        // did tap submit button
        submitButton.rx.tap
            .bind { [weak self] in
                guard let weakSelf = self, let amount = weakSelf.myBalanceViewModel.currencyExchange.sell?.amount, amount != 0 else {
                return
            }
            
            weakSelf.exchangeCurrency(currencyExchange: weakSelf.myBalanceViewModel.currencyExchange)
        }
        .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        myBalanceViewModel = (viewModel as! MyBalanceViewModel)
        let currencyConverterInput = MyBalanceViewModel.MyBalanceInput(currencyConverterTrigger: currencyConverterTrigger, addCurrencyTrigger: addCurrencyTrigger)
        let currencyConverterOutput = myBalanceViewModel.getMyBalanceOutput(input: currencyConverterInput)
        
        // observe balance exchange response
        currencyConverterOutput.balance
            .asDriver()
            .drive(onNext: { [weak self] response in
                AppLogger.info("Response = \(response)")
                
                guard let weakSelf = self, let balance = response else {
                    return
                }
                
                weakSelf.setConversionCount()
                weakSelf.setReceivedAmount(amount: balance.amount ?? 0.00)
                
                let sell = weakSelf.myBalanceViewModel.currencyExchange.sell.unwrappedValue
                let receive = weakSelf.myBalanceViewModel.currencyExchange.receive.unwrappedValue
                
                let message = "You have converted \(sell.amount.unwrappedValue) \(sell.currency.unwrappedValue) to \(receive.amount.unwrappedValue) \(receive.currency.unwrappedValue). Commission free - \(weakSelf.myBalanceViewModel.calculateCommission().round(to: 2)) \(sell.currency.unwrappedValue)"
                
                weakSelf.showAlertDialog(title: "Currency Converted", message: message)
            }).disposed(by: disposeBag)
        
        // detect validation error
        currencyConverterOutput.validationError
            .asDriver()
            .drive(onNext: { [weak self] error in
                guard let weakSelf = self, let error = error else {
                    return
                }
            
                AppLogger.debug("validationError -- code = \(error.errorCode), message = \(error.errorMessage)")
                weakSelf.showAlertDialog(title: "No Balance", message: error.errorMessage)
                
        }).disposed(by: disposeBag)
        
        // detect network error
        currencyConverterOutput.errorResponse
            .asDriver()
            .drive(onNext: { [weak self] error in
                guard let weakSelf = self, let error = error else {
                    return
                }
            
                AppLogger.debug("errorResponse -- code = \(error.errorCode), message = \(error.errorMessage)")
                weakSelf.showAlertDialog(title: "Conversion Failed", message: error.errorMessage)
        }).disposed(by: disposeBag)
        
        AppLogger.info("conversionCount == \(UserSessionDataClient.shared.conversionCount)")
    }
    
    
    // MARK: EVENT FIRE & OBSERVE
    public func observeBalanceItems() {
        // bind balance list view
        myBalanceViewModel.balanceListRelay
            .asDriver()
            .drive(balanceListView.rx.items) { [weak self] collectionView, row, model in
                guard let weakSelf = self else {
                    return UICollectionViewCell()
                }
                
                return weakSelf.populateBalanceViewCell(viewModel: model.asCellViewModel, indexPath: IndexPath(row: row, section: 0), collectionView: collectionView)
            }.disposed(by: disposeBag)
        
        // observe balance list
        myBalanceViewModel.balanceListRelay
            .asDriver()
            .drive(onNext: { [weak self] balances in
               guard let weakSelf = self else {
                   return
               }
           
                weakSelf.currencyExchangeSellView.currencies = balances.map({$0.currency.unwrappedValue})
                weakSelf.currencyExchangeReceivedView.currencies = balances.map({$0.currency.unwrappedValue})
            })
            .disposed(by: disposeBag)
    }
    
    func exchangeCurrency(currencyExchange: CurrencyExchange) {
        let amount = "\((currencyExchange.sell?.amount).unwrappedValue)"
        currencyConverterTrigger.onNext(MyBalanceViewModel.CurrencyConverterInput(fromAmount: amount, fromCurrency: (currencyExchange.sell?.currency).unwrappedValue, toCurrency: (currencyExchange.receive?.currency).unwrappedValue))
    }
    
    func addBalance(balance: Balance) {
        addCurrencyTrigger.onNext(balance)
    }
    
    func setConversionCount() {
        UserSessionDataClient.shared.setConversionCount(count: UserSessionDataClient.shared.getConversionCount() + 1 )
    }
    
    
    //MARK: UI METHODS
    func addBalanceView() {
        view.addSubview(balanceListView)
        view.addSubview(balanceTitleLabel)
        
        let balanceTitleLabelConstraint = [
            AdaptiveLayoutConstraint(item: balanceTitleLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: balanceTitleLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: balanceTitleLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: topBarHeight+20, setAdaptiveLayout: true)
        ]
        
        let currencyListViewConstraint = [
            AdaptiveLayoutConstraint(item: balanceListView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: balanceListView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: balanceListView, attribute: .top, relatedBy: .equal, toItem: balanceTitleLabel, attribute: .bottom, multiplier: 1, constant: 30, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: balanceListView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30, setAdaptiveLayout: true)
        ]

        NSLayoutConstraint.activate(balanceTitleLabelConstraint + currencyListViewConstraint)
    }
    
    func addCurrencyExchangeView() {
        view.addSubview(currencyExchangeLabel)
        view.addSubview(currencyExchangeSellView)
        view.addSubview(currencyExchangeReceivedView)
        
        let currencyExchangeLabelConstraint = [
            AdaptiveLayoutConstraint(item: currencyExchangeLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: currencyExchangeLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: currencyExchangeLabel, attribute: .top, relatedBy: .equal, toItem: balanceListView, attribute: .bottom, multiplier: 1, constant: 40, setAdaptiveLayout: true)
        ]
        
        let currencyExchangeSellViewConstraint = [
            AdaptiveLayoutConstraint(item: currencyExchangeSellView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: currencyExchangeSellView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: currencyExchangeSellView, attribute: .top, relatedBy: .equal, toItem: currencyExchangeLabel, attribute: .bottom, multiplier: 1, constant: 40, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: currencyExchangeSellView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40, setAdaptiveLayout: true)
        ]
        
        let currencyExchangeReceivedViewConstraint = [
            AdaptiveLayoutConstraint(item: currencyExchangeReceivedView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: currencyExchangeReceivedView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: currencyExchangeReceivedView, attribute: .top, relatedBy: .equal, toItem: currencyExchangeSellView, attribute: .bottom, multiplier: 1, constant: 15, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: currencyExchangeReceivedView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40, setAdaptiveLayout: true)
        ]
        
        NSLayoutConstraint.activate(currencyExchangeLabelConstraint + currencyExchangeSellViewConstraint + currencyExchangeReceivedViewConstraint)
    }
    
    func addSubmitButton() {
        view.addSubview(submitButton)
        
        let submitButtonConstraint = [
            AdaptiveLayoutConstraint(item: submitButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 40, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: submitButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -40, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: submitButton, attribute: .top, relatedBy: .equal, toItem: currencyExchangeReceivedView, attribute: .bottom, multiplier: 1, constant: 30, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: submitButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 45, setAdaptiveLayout: true)
        ]
        
        NSLayoutConstraint.activate(submitButtonConstraint)
    }
    
    func setReceivedAmount(amount: Double) {
        currencyExchangeReceivedView.amountText = "+\(amount)"
    }
    
    
    // MARK: LIST VIEW
    //populate collection view cell
    private func populateBalanceViewCell(viewModel: AbstractCellViewModel, indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        let item: CellConfigurator = BalanceItemCellConfig.init(item: viewModel)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item).reuseId, for: indexPath)
        item.configure(cell: cell)
        
        return cell
    }
    
    private func onTapTableviewCell() {
        Observable
            .zip(balanceListView.rx.itemSelected, balanceListView.rx.modelSelected(Balance.self))
            .bind { [weak self] indexPath, model in
                guard let weakSelf = self else {
                    return
                }
                
                AppLogger.debug(" Selected " + (model.currency ?? "") + " at \(indexPath)")
            }
            .disposed(by: disposeBag)
    }
    
    @objc func didTapAddButton(sender : AnyObject){
        showAddCurrencyDialog()
    }
    
    
    // MARK: DIALOG VIEW
    private func showAlertDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAddCurrencyDialog() {
        let alertController = UIAlertController(title: "Add currency", message: "Enter currency name. Ex - SGD, YEN, BDT", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Currency name"
        }
        
        let saveAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { [weak self] alert -> Void in
            let currency = (alertController.textFields?[0])?.text?.uppercased() ?? ""
            
            if !currency.isEmpty {
                self?.addBalance(balance: Balance(amount: 0.00, currency: currency))
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

