//
//  UpNodeDetails.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class NodeDetailsView: UIView {
    
    enum NodeType {
        case up
        case down
        case cell
        case rootCell
    }
    
    lazy var textView = UITextView(frame: .zero)
    
    private lazy var branches = UICollectionView(frame: .zero, collectionViewLayout: .flow)
    private lazy var addBranchButton = UIButton(frame: .zero)
    private lazy var goOnButton = UIButton(frame: .zero)
    private lazy var goBackButton = UIButton(frame: .zero)
    
    let collectionHeight: CGFloat = 48
    private var position: NodeType!
    
    private var collectionTrailingContraint: NSLayoutConstraint!
    private var goBackTrailingLayoutConstraint: NSLayoutConstraint!
    private var goOnLeadingLayoutConstraint: NSLayoutConstraint!
    
    var text: String? = "" {
        didSet {
            textView.text = text
        }
    }
    
    weak var textViewDelegate: UITextViewDelegate? {
        didSet {
            textView.delegate = textViewDelegate
        }
    }
    
    weak var collectionDelegate: UICollectionViewDelegateFlowLayout? {
        didSet {
            branches.delegate = collectionDelegate
        }
    }
    
    weak var dataSource: UICollectionViewDataSource? {
        didSet {
            branches.dataSource = dataSource
        }
    }
    
    convenience init(type: NodeType) {
        self.init(frame: .zero)
        self.position = type
        positionSet()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureTextView()
        addSubview(textView)
        
        configureAddBranchButton()
        addSubview(addBranchButton)
        
        configureBranchesCollectionView()
        addSubview(branches)
        
        configureGoOnButton()
        addSubview(goOnButton)
        
        configureGoBackButton()
        addSubview(goBackButton)
        
        setConstraints()
        
    }
    
    private func configureTextView() {
        textView.backgroundColor = .clear
        textView.textColor = UIColor(color: .darkerBlue)
        textView.font = UIFont(name: "Baskerville", size: 17)
    }
    
    private func configureAddBranchButton() {
        addBranchButton.setImage(UIImage(named: "addBranch"), for: .normal)
//        addBranchButton.backgroundColor = UIColor(color: .darkBlue)
//        addBranchButton.round(radius: collectionHeight/2)
    }
    
    func addTargetForAddBranchButton(target: Any?, selector: Selector, forEvent event: UIControl.Event) {
        addBranchButton.addTarget(target, action: selector, for: event)
    }
    
    func addTargetForGoOnButton(target: Any?, selector: Selector, forEvent event: UIControl.Event) {
        goOnButton.addTarget(target, action: selector, for: event)
    }
    
    func addTargetForGoBackButton(target: Any?, selector: Selector, forEvent event: UIControl.Event) {
        goBackButton.addTarget(target, action: selector, for: event)
    }
    
    private func configureBranchesCollectionView() {
        let layout = branches.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        branches.collectionViewLayout = layout!
        branches.backgroundColor = .clear
        branches.showsHorizontalScrollIndicator = false
        branches.showsVerticalScrollIndicator = false
        branches.register(BranchCollectionViewCell.self, forCellWithReuseIdentifier: "branchCell")
    }
    
    private func configureGoOnButton() {
        goOnButton.backgroundColor = UIColor(color: .darkBlue)
        goOnButton.setTitle("Continuar", for: .normal)
        goOnButton.setTitleColor(UIColor(color: .purpleWhite), for: .normal)
        goOnButton.round(radius: 4)
    }
    
    private func configureGoBackButton() {
        goBackButton.backgroundColor = UIColor(color: .red)
        goBackButton.setTitle("Voltar", for: .normal)
        goBackButton.setTitleColor(UIColor(color: .purpleWhite), for: .normal)
        goBackButton.round(radius: 4)
    }
    
    private func setConstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        
        addBranchButton.translatesAutoresizingMaskIntoConstraints = false
        addBranchButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor).isActive = true
        addBranchButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8).isActive = true
        addBranchButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        addBranchButton.widthAnchor.constraint(equalTo: addBranchButton.heightAnchor).isActive = true
        addBranchButton.heightAnchor.constraint(equalToConstant: collectionHeight).isActive = true
        
        branches.translatesAutoresizingMaskIntoConstraints = false
        branches.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
        collectionTrailingContraint = branches.trailingAnchor.constraint(equalTo: addBranchButton.leadingAnchor, constant: -16)
        collectionTrailingContraint.isActive = true
//        branches.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8).isActive = true
        branches.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        branches.heightAnchor.constraint(equalToConstant: collectionHeight).isActive = true
        
        goOnButton.translatesAutoresizingMaskIntoConstraints = false
        goOnButton.trailingAnchor.constraint(equalTo: addBranchButton.trailingAnchor).isActive = true
        goOnLeadingLayoutConstraint = goOnButton.leadingAnchor.constraint(equalTo: goBackButton.trailingAnchor, constant: 8)
        goOnLeadingLayoutConstraint.isActive = true
        goOnButton.topAnchor.constraint(equalTo: branches.topAnchor).isActive = true
        goOnButton.bottomAnchor.constraint(equalTo: branches.bottomAnchor).isActive = true
        
        goBackButton.translatesAutoresizingMaskIntoConstraints = false
        goBackTrailingLayoutConstraint = goBackButton.trailingAnchor.constraint(equalTo: textView.centerXAnchor, constant: -4)
        goBackTrailingLayoutConstraint.isActive = true
        goBackButton.leadingAnchor.constraint(equalTo: branches.leadingAnchor).isActive = true
        goBackButton.topAnchor.constraint(equalTo: branches.topAnchor).isActive = true
        goBackButton.bottomAnchor.constraint(equalTo: branches.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func positionSet() {
        if position == .up {
            backgroundColor = UIColor(color: .purpleWhite)
            branches.isHidden = false
            addBranchButton.isHidden = false
            goOnButton.isHidden = true
            goBackButton.isHidden = true
            textView.addDoneButtonOnKeyboard()
        } else if position == .down {
            backgroundColor = UIColor(color: .yellowWhite)
            branches.isHidden = true
            addBranchButton.isHidden = true
            goOnButton.isHidden = false
            goBackButton.isHidden = false
            textView.addDoneButtonOnKeyboard()
        } else if position == .cell {
            backgroundColor = UIColor(color: .purpleWhite)
            branches.isHidden = false
            addBranchButton.isHidden = true
            goOnButton.isHidden = true
            goBackButton.isHidden = true
            collectionTrailingContraint.isActive = false
            textView.isEditable = false
            branches.trailingAnchor.constraint(equalTo: textView.trailingAnchor).isActive = true
        } else {
            backgroundColor = UIColor(color: .purpleWhite)
            branches.isHidden = true
            addBranchButton.isHidden = true
            goOnButton.isHidden = true
            goBackButton.isHidden = true
            textView.isEditable = false
        }
    }
    
    func enableBranches(_ enabled: Bool) {
        branches.isUserInteractionEnabled = enabled
    }
    
    func reload(withText text: String?, animateWithFade: Bool = true) {
        let reloadBlock = {
            self.text = text
            if self.branches.isHidden == false { self.branches.reloadData() }
        }
        
        if animateWithFade {
            UIView.animate(withDuration: 0.35,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.7,
                           options: [.allowUserInteraction, .curveEaseInOut, .layoutSubviews], animations: {
                            self.textView.alpha = 0
                            self.branches.alpha = 0
            }, completion: { _ in
                reloadBlock()
                UIView.animate(withDuration: 1,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 0.7,
                               options: [.allowUserInteraction, .curveEaseOut, .layoutSubviews], animations: {
                                self.textView.alpha = 1
                                self.branches.alpha = 1
                }, completion: nil)
            })
        } else {
            reloadBlock()
        }
    }
    
    func reload() {
        branches.reloadData()
    }
    
    func collapseWhenIsTheLastNode() {
        if position == .down {
            backgroundColor = UIColor(color: .purpleWhite)
        }
    }
    
    func expandWhenIsNotTheLastNode() {
        if position == .down {
            backgroundColor = UIColor(color: .yellowWhite)
        }
    }
    
    func adjustTextViewAndGoOnButton(offset: CGFloat) {
        textView.frame.size.height += offset
        goOnButton.frame.origin.y += offset
        goBackButton.frame.origin.y += offset
    }
    
    func hideGoBackButton() {
        goBackTrailingLayoutConstraint.isActive = false
        goBackTrailingLayoutConstraint = goBackButton.trailingAnchor.constraint(equalTo: goBackButton.leadingAnchor)
        goBackTrailingLayoutConstraint.isActive = true
        
        goOnLeadingLayoutConstraint.isActive = false
        goOnLeadingLayoutConstraint = goOnButton.leadingAnchor.constraint(equalTo: textView.leadingAnchor)
        goOnLeadingLayoutConstraint.isActive = true
        
        UIView.animate(withDuration: 0.7) { self.layoutIfNeeded() }
    }
    
    func hideGoOnButton() {
        goBackTrailingLayoutConstraint.isActive = false
        goBackTrailingLayoutConstraint = goBackButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor)
        goBackTrailingLayoutConstraint.isActive = true
        UIView.animate(withDuration: 0.7) { self.layoutIfNeeded() }
    }
    
    func showAllButtons() {
        goBackTrailingLayoutConstraint.isActive = false
        goBackTrailingLayoutConstraint = goBackButton.trailingAnchor.constraint(equalTo: textView.centerXAnchor, constant: -4)
        goBackTrailingLayoutConstraint.isActive = true
        
        goOnLeadingLayoutConstraint.isActive = false
        goOnLeadingLayoutConstraint = goOnButton.leadingAnchor.constraint(equalTo: goBackButton.trailingAnchor, constant: 8)
        goOnLeadingLayoutConstraint.isActive = true
        
        UIView.animate(withDuration: 0.7) { self.layoutIfNeeded() }
    }

}

extension UICollectionViewLayout {
    static var flow = UICollectionViewFlowLayout()
}
