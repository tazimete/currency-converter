//
//  CurrencyExcangeView.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/16/22.
//

import UIKit
import RxSwift
import RxCocoa
                                                                       

class CurrencyExcangeView: UIView {
    private let disposeBag = DisposeBag()
    private let currencyListRelay: BehaviorRelay<[Currency]> = BehaviorRelay<[Currency]>(value: [])
    public let itemTapHandler: PublishSubject<Currency> = PublishSubject<Currency>()
    public var navigationItems: [Currency]! {
        didSet{
            self.currencyListRelay.accept(navigationItems)
        }
    }
    
    public var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.cornerRadius = 0
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sell"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.applyAdaptiveLayout()
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "100"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.applyAdaptiveLayout()
        return label
    }()
    
    public lazy var currencyListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 60, height: 25)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
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
//        collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        collectionView.register(CurrencyItemCell.self, forCellWithReuseIdentifier: CurrencyItemCellConfig.reuseId)
        
        return collectionView
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        addActionsToSubViews()
        onTapCollectionviewCell()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        
    }
    
    override func removeFromSuperview() {

    }
    
    public func setupSubViews() {
        addSubview(containerView)
        containerView.addSubview(currencyListView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(amountLabel)
        
        let contentViewConstraint = [AdaptiveLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: containerView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0, setAdaptiveLayout: true)]
        
        let titleViewConstraint = [AdaptiveLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 5, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 60, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0, setAdaptiveLayout: true)]
        
        let amountViewConstraint = [AdaptiveLayoutConstraint(item: amountLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 5, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: amountLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 120, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: amountLabel, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0, setAdaptiveLayout: true)]
        
        let currencyListViewConstraint = [AdaptiveLayoutConstraint(item: currencyListView, attribute: .leading, relatedBy: .equal, toItem: amountLabel, attribute: .leading, multiplier: 1, constant: 5, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: currencyListView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: -5, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: currencyListView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: currencyListView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30, setAdaptiveLayout: true)]

        NSLayoutConstraint.activate(contentViewConstraint + titleViewConstraint + amountViewConstraint + currencyListViewConstraint)
    }
    
    public func addActionsToSubViews() {
        observeNavigationItems()
    }
    
    public func observeNavigationItems() {
        currencyListRelay.observe(on: MainScheduler.instance)
            .bind(to: currencyListView.rx.items) { [weak self] collectionView, row, model in
                guard let weakSelf = self else {
                    return UICollectionViewCell()
                }
                
                return weakSelf.populateNavigationViewItem(viewModel: model.asCellViewModel, indexPath: IndexPath(row: row, section: 0), collectionView: collectionView)
            }.disposed(by: disposeBag)
    }
    
    //populate collection view cell
    public func populateNavigationViewItem(viewModel: AbstractCellViewModel, indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        let item: CellConfigurator = CurrencyItemCellConfig.init(item: viewModel)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item).reuseId, for: indexPath)
        item.configure(cell: cell)
        
        return cell
    }
        
    // MARK: Actions
    public func onTapCollectionviewCell() {
        Observable
            .zip(currencyListView.rx.itemSelected, currencyListView.rx.modelSelected(Currency.self))
            .bind { [weak self] indexPath, model in
                guard let weakSelf = self else {
                    return
                }
                
                AppLogger.debug("Did tap genre section item vcell - \(model.title)")
                
                weakSelf.itemTapHandler.onNext(model)
            }
            .disposed(by: disposeBag)
    }
}


