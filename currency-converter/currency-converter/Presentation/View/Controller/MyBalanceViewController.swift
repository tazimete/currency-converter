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
    public var myBalanceViewModel: AbstractMyBalanceViewModel!
    private let currencyListRelay: BehaviorRelay<[Currency]> = BehaviorRelay<[Currency]>(value: [])
    private let currencyConverterTrigger = PublishSubject<MyBalanceViewModel.CurrencyConverterInput>()
    
    // MARK: UI Proeprties
    public lazy var currencyListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
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
        collectionView.register(CurrencyItemCell.self, forCellWithReuseIdentifier: CurrencyItemCellConfig.reuseId)
        
        return collectionView
    }()


    // MARK: Constructors
    init(viewModel: AbstractMyBalanceViewModel) {
        super.init(viewModel: viewModel)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Overrriden Methods
    override func initView() {
        super.initView()
        //setup view
        view.addSubview(currencyListView)
        view.backgroundColor = .white
        
        let currencyListViewConstraint = [AdaptiveLayoutConstraint(item: currencyListView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: currencyListView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: currencyListView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: topBarHeight + 30, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: currencyListView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30, setAdaptiveLayout: true)]

        NSLayoutConstraint.activate(currencyListViewConstraint)
        
        //collection view
        observeCurrencyItems()
        onTapTableviewCell()
        
        currencyListRelay.accept([Currency(amount: "1000", title: "USD"), Currency(amount: "100", title: "EURO"), Currency(amount: "100", title: "JPY"), Currency(amount: "100", title: "TK")])
    }
    
    override func initNavigationBar() {
        super.initNavigationBar()
        
        self.navigationItem.title = "Currency Converter"
        let btnAction = UIBarButtonItem(title: "Convert", style: .done, target: self, action: #selector(didTapConvertButton))
        btnAction.tintColor = appColors.textColorLight
        self.navigationItem.rightBarButtonItem = btnAction
    }
    
    override func bindViewModel() {
        myBalanceViewModel = (viewModel as! AbstractMyBalanceViewModel)
        let currencyConverterInput = MyBalanceViewModel.MyBalanceInput(currencyConverterTrigger: currencyConverterTrigger)
        let currencyConverterOutput = myBalanceViewModel.getMyBalanceOutput(input: currencyConverterInput)
        
        //populate table view
//        currencyConverterOutput.currency.observe(on: MainScheduler.instance)
//            .bind(to: tableView.rx.items) { [weak self] tableView, row, model in
//                guard let weakSelf = self else {
//                    return UITableViewCell()
//                }
//
//                return weakSelf.populateTableViewCell(viewModel: model.asCellViewModel, indexPath: IndexPath(row: row, section: 0), tableView: tableView)
//            }.disposed(by: disposeBag)
        
        currencyConverterOutput.currency
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                AppLogger.info("\(response)")
                guard let weakSelf = self, let currencyRespone = response else {
                    return
                }
                
                AppLogger.info("commission = \(weakSelf.myBalanceViewModel.commissionCalculator.calculateCommissionAmount(conversionSerial: UserSessionDataClient.shared.conversionCount, conversionAmount: 250))")
                UserSessionDataClient.shared.setConversionCount(count: UserSessionDataClient.shared.getConversionCount() + 1 )
            }).disposed(by: disposeBag)
        
        // detect error
        currencyConverterOutput.errorTracker
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let weakSelf = self, let error = error else {
                    return
                }
            
                AppLogger.debug("code = \(error.errorCode), message = \(error.errorMessage)")
        }).disposed(by: disposeBag)
        
        convertCurrency(amount: "250", currency: "USD")
        
//        UserSessionDataClient.shared.setConversionCount(count: 0)
//        UserSessionDataClient.shared.kvContainer = Mock()
        AppLogger.info("conversionCount == \(UserSessionDataClient.shared.conversionCount)")
    }
    
    public func convertCurrency(amount: String, currency: String) {
        currencyConverterTrigger.onNext(MyBalanceViewModel.CurrencyConverterInput(amount: amount, currency: currency))
    }
    
    public func observeCurrencyItems() {
        currencyListRelay.observe(on: MainScheduler.instance)
            .bind(to: currencyListView.rx.items) { [weak self] collectionView, row, model in
                guard let weakSelf = self else {
                    return UICollectionViewCell()
                }
                
                return weakSelf.populateCurrencyViewCell(viewModel: model.asCellViewModel, indexPath: IndexPath(row: row, section: 0), collectionView: collectionView)
            }.disposed(by: disposeBag)
    }
    
    //populate collection view cell
    private func populateCurrencyViewCell(viewModel: AbstractCellViewModel, indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        let item: CellConfigurator = CurrencyItemCellConfig.init(item: viewModel)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item).reuseId, for: indexPath)
        item.configure(cell: cell)
        
        return cell
    }
    
    // MARK: Actions
    private func onTapTableviewCell() {
        Observable
            .zip(currencyListView.rx.itemSelected, currencyListView.rx.modelSelected(Currency.self))
            .bind { [weak self] indexPath, model in
                guard let weakSelf = self else {
                    return
                }
                
                AppLogger.debug(" Selected " + (model.title ?? "") + " at \(indexPath)")
            }
            .disposed(by: disposeBag)
    }
    
    @objc func didTapConvertButton(sender : AnyObject){
        showSearchDialog()
    }
    
    private func showSearchDialog() {
        let alertController = UIAlertController(title: "Search movie", message: "Enter movie name. Ex- The \n Enter releasing year. Ex- 2000", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Movie name"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Releasing year"
        }
        
        let saveAction = UIAlertAction(title: "Search", style: UIAlertAction.Style.default, handler: { [weak self] alert -> Void in
            let name = (alertController.textFields?[0])?.text ?? ""
            let year = (alertController.textFields?[1])?.text ?? ""
            
            if !name.isEmpty && !year.isEmpty {
                self?.convertCurrency(amount: name, currency: year)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

