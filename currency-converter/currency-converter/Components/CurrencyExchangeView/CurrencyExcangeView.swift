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
    public let selectionHandler: BehaviorSubject<Balance?> = BehaviorSubject<Balance?>(value: nil)

    public var currencies: [String]! {
        didSet{
            self.currencyDropdown.dataSource = currencies
        }
    }
    
    public var titleIconText: String {
        set(newValue) {
            self.titleIcon.text = newValue
        }
        
        get{
            return titleIcon.text ?? ""
        }
    }
    
    public var titleIconBackground: UIColor {
        set(newValue) {
            self.titleIcon.backgroundColor = newValue
        }
        
        get{
            return self.titleIcon.backgroundColor ?? .white
        }
    }
    
    public var titleText: String {
        set(newValue) {
            self.titleLabel.text = newValue
        }
        
        get{
            return titleLabel.text ?? ""
        }
    }
    
    public var amountText: String {
        set(newValue) {
            self.amountField.text = newValue
        }
        
        get{
            return amountField.text ?? ""
        }
    }
    
    public var amountTextColor: UIColor {
        set(newValue) {
            self.amountField.textColor = newValue
        }
        
        get{
            return self.amountField.textColor ?? .white
        }
    }
    
    public var isAmountFieldEditable: Bool {
        set(newValue) {
            self.amountField.isEnabled = newValue
        }
        
        get{
            return self.amountField.isEnabled
        }
    }
    
    public var selectedCurrencyIndex: Int {
        set(newValue) {
            if self.currencyDropdown.dataSource.count > newValue {
                self.currencyDropdown.selectRow(at: newValue)
                self.currencyLabel.addTrailing(image: UIImage(named: "ic_dropdown")!, text: self.currencyDropdown.dataSource[newValue])
                //observe default value
                self.observeCurrencyValue(amount: "0.00", currency: currencyDropdown.dataSource[newValue] )
            }
        }
        
        get{
            return self.currencyDropdown.indexForSelectedRow.unwrappedValue
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
    
    private let titleIcon: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        label.textColor = .white
        label.text = "???" // "???"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        label.clipsToBounds = true
        label.layer.cornerRadius = CGFloat(20).relativeToIphone8Width()
        label.applyAdaptiveLayout()
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sell"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.applyAdaptiveLayout()
        return label
    }()
    
    private let amountField: UITextField = {
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0.00"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.textAlignment = .right
        label.keyboardType = .numberPad
        label.applyAdaptiveLayout()
        return label
    }()
    
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addTrailing(image: UIImage(named: "ic_dropdown")!)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.applyAdaptiveLayout()
        return label
    }()
    
    private lazy var currencyDropdown: DropDown = {
        let dropDown = DropDown()
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        dropDown.anchorView = currencyLabel
        dropDown.selectRow(at: 0)
        
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
        containerView.addSubview(amountField)
        containerView.addSubview(currencyLabel)
        containerView.addSubview(currencyDropdown)
        
        let contentViewConstraint = [
            AdaptiveLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: containerView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0, setAdaptiveLayout: true)
        ]
        
        let titleIconConstraint = [
            AdaptiveLayoutConstraint(item: titleIcon, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 5, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: titleIcon, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: titleIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 40, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: titleIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40, setAdaptiveLayout: true)
        ]
        
        let titleViewConstraint = [
            AdaptiveLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: titleIcon, attribute: .trailing, multiplier: 1, constant: 20, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 80, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: titleIcon, attribute: .centerY, multiplier: 1, constant: 0, setAdaptiveLayout: true)
        ]
        
        let amountViewConstraint = [
            AdaptiveLayoutConstraint(item: amountField, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 20, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: amountField, attribute: .trailing, relatedBy: .equal, toItem: currencyLabel, attribute: .leading, multiplier: 1, constant: -25, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: amountField, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0, setAdaptiveLayout: true)
        ]
        
        let currencyLabelConstraint = [
            AdaptiveLayoutConstraint(item: currencyLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: -15, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: currencyLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: currencyLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 80, setAdaptiveLayout: true),
            AdaptiveLayoutConstraint(item: currencyLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40, setAdaptiveLayout: true)
        ]

        NSLayoutConstraint.activate(contentViewConstraint + titleIconConstraint + titleViewConstraint + amountViewConstraint + currencyLabelConstraint)
    }
    
    public func addActionsToSubViews() {
        // open currency dropdown on tap
        currencyLabel
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.currencyDropdown.show()
            })
            .disposed(by: disposeBag)
        
        // observe currency dropdown selection value
        currencyDropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let weakSelf = self else {
                return
            }
            
            AppLogger.info("Selected item: \(item) at index: \(index)")
            weakSelf.currencyLabel.addTrailing(image: UIImage(named: "ic_dropdown")!, text: item)
            weakSelf.observeCurrencyValue(amount: weakSelf.amountField.text ?? "", currency: item)
        }
        
        // observe amount field text change
        amountField
            .rx.controlEvent([.editingChanged])
            .asObservable()
            .withLatestFrom(amountField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] value in
                guard let weakSelf = self else {
                    return
                }
                
                weakSelf.observeCurrencyValue(amount: value, currency: weakSelf.currencyDropdown.dataSource[weakSelf.currencyDropdown.indexForSelectedRow ?? 0] )
            }).disposed(by: disposeBag)
    }
    
    override func didMoveToSuperview() {
        //observe default value
//        observeCurrencyValue(amount: "0.00", currency: currencyDropdown.dataSource[currencyDropdown.indexForSelectedRow ?? 0] )
    }
    
    private func observeCurrencyValue(amount: String, currency: String) {
        selectionHandler.onNext(Balance(amount: Double(amount) ?? 0.00, currency: currency))
    }
}


