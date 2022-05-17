//
//  CurrencyExcangeView.swift
//  currency-converter
//
//  Created by AGM Tazim on 5/16/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import DropDown
                                                                       

class CurrencyExcangeView: UIView {
    private let disposeBag = DisposeBag()
    private let currencyListRelay: BehaviorRelay<[Currency]> = BehaviorRelay<[Currency]>(value: [])
    public let itemTapHandler: PublishSubject<Currency> = PublishSubject<Currency>()
    public var currencies: [Currency]! {
        didSet{
            self.currencyListRelay.accept(currencies)
            self.currencyDropdown.dataSource.append(contentsOf: currencies.map({return $0.title ?? ""}))
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
    
    let titleIcon: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        label.textColor = .white
        label.text = "↑" // "↓"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.clipsToBounds = true
        label.layer.cornerRadius = CGFloat(20).relativeToIphone8Width()
        label.applyAdaptiveLayout()
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sell"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.applyAdaptiveLayout()
        return label
    }()
    
    let amountLabel: UITextField = {
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "100"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textAlignment = .right
        label.keyboardType = .numberPad
        label.applyAdaptiveLayout()
        return label
    }()
    
    let currencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addTrailing(image: .checkmark, text: "USD")
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.applyAdaptiveLayout()
        return label
    }()
    
    lazy var currencyDropdown: DropDown = {
        let dropDown = DropDown()
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        dropDown.anchorView = currencyLabel
        dropDown.dataSource = ["USD", "EURO", "JPY"]
        
        return dropDown
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        addActionsToSubViews()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupSubViews() {
        addSubview(containerView)
        containerView.addSubview(titleIcon)
        containerView.addSubview(titleLabel)
        containerView.addSubview(amountLabel)
        containerView.addSubview(currencyLabel)
        containerView.addSubview(currencyDropdown)
        
        let contentViewConstraint = [AdaptiveLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: containerView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0, setAdaptiveLayout: true)]
        
        let titleIconConstraint = [AdaptiveLayoutConstraint(item: titleIcon, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 5, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: titleIcon, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: titleIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 40, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: titleIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40, setAdaptiveLayout: true)]
        
        let titleViewConstraint = [AdaptiveLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: titleIcon, attribute: .trailing, multiplier: 1, constant: 20, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 50, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: titleIcon, attribute: .centerY, multiplier: 1, constant: 0, setAdaptiveLayout: true)]
        
        let amountViewConstraint = [AdaptiveLayoutConstraint(item: amountLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 20, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: amountLabel, attribute: .trailing, relatedBy: .equal, toItem: currencyLabel, attribute: .leading, multiplier: 1, constant: -25, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: amountLabel, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0, setAdaptiveLayout: true)]
        
        let currencyLabelConstraint = [AdaptiveLayoutConstraint(item: currencyLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: -15, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: currencyLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: currencyLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 80, setAdaptiveLayout: true), AdaptiveLayoutConstraint(item: currencyLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40, setAdaptiveLayout: true)]

        NSLayoutConstraint.activate(contentViewConstraint + titleIconConstraint + titleViewConstraint + amountViewConstraint + currencyLabelConstraint)
    }
    
    public func addActionsToSubViews() {
        currencyLabel.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.currencyDropdown.show()
                })
                .disposed(by: disposeBag)
        
        currencyDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            AppLogger.info("Selected item: \(item) at index: \(index)")
            
            guard let weakSelf = self else {
                return
            }
            
            weakSelf.currencyLabel.addTrailing(image: .checkmark, text: item)
        }
    }
    
//    public func observeNavigationItems() {
//        currencyListRelay.observe(on: MainScheduler.instance)
//            .bind(to: currencyListView.rx.items) { [weak self] collectionView, row, model in
//                guard let weakSelf = self else {
//                    return UICollectionViewCell()
//                }
//
//                return weakSelf.populateNavigationViewItem(viewModel: model.asCellViewModel, indexPath: IndexPath(row: row, section: 0), collectionView: collectionView)
//            }.disposed(by: disposeBag)
//    }
//
//    //populate collection view cell
//    public func populateNavigationViewItem(viewModel: AbstractCellViewModel, indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
//        let item: CellConfigurator = CurrencyItemCellConfig.init(item: viewModel)
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item).reuseId, for: indexPath)
//        item.configure(cell: cell)
//
//        return cell
//    }
//
//    // MARK: Actions
//    public func onTapCollectionviewCell() {
//        Observable
//            .zip(currencyListView.rx.itemSelected, currencyListView.rx.modelSelected(Currency.self))
//            .bind { [weak self] indexPath, model in
//                guard let weakSelf = self else {
//                    return
//                }
//
//                AppLogger.debug("Did tap genre section item vcell - \(model.title)")
//                weakSelf.currencyDropdown.show()
//                weakSelf.itemTapHandler.onNext(model)
//            }
//            .disposed(by: disposeBag)
//    }
}


