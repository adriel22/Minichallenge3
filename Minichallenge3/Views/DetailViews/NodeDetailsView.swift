//
//  UpNodeDetails.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class NodeDetailsView: UIView {
    
    enum Position {
        case up
        case down
    }
    
    lazy var textView = UITextView(frame: .zero)
    
    private lazy var branches = UICollectionView(frame: .zero, collectionViewLayout: .flow)
    private lazy var addBranchButton = UIButton(frame: .zero)
    private lazy var goOnButton = UIButton(frame: .zero)
    
    private let collectionHeight: CGFloat = 48
    private var position: Position!
    
    var text: String? = "" {
        didSet {
            textView.text = text
        }
    }
    
    typealias NodeDetailsViewDelegate = UICollectionViewDelegateFlowLayout & UITextViewDelegate
    weak var delegate: NodeDetailsViewDelegate? {
        didSet {
            branches.delegate = delegate
            textView.delegate = delegate
        }
    }
    
    weak var dataSource: UICollectionViewDataSource? {
        didSet {
            branches.dataSource = dataSource
        }
    }
    
    convenience init(position: Position) {
        self.init(frame: .zero)
        self.position = position
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
        
        setConstraints()
        
    }
    
    private func configureTextView() {
        textView.backgroundColor = .clear
        textView.textColor = UIColor(color: .darkerBlue)
        textView.font = UIFont(name: "Baskerville", size: 17)
        textView.addDoneButtonOnKeyboard()
    }
    
    private func configureAddBranchButton() {
        addBranchButton.backgroundColor = UIColor(color: .darkBlue)
        addBranchButton.round(radius: collectionHeight/2)
    }
    
    func addTargetForAddBranchButton(target: Any?, selector: Selector, forEvent event: UIControl.Event) {
        addBranchButton.addTarget(target, action: selector, for: event)
    }
    
    func addTargetForGoOnButton(target: Any?, selector: Selector, forEvent event: UIControl.Event) {
        goOnButton.addTarget(target, action: selector, for: event)
    }
    
    private func configureBranchesCollectionView() {
        let layout = branches.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        branches.collectionViewLayout = layout!
        branches.backgroundColor = .clear
        branches.showsHorizontalScrollIndicator = false
        branches.showsVerticalScrollIndicator = false
        branches.register(BranchCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func configureGoOnButton() {
        goOnButton.backgroundColor = UIColor(color: .darkBlue)
        goOnButton.setTitle("Continuar", for: .normal)
        goOnButton.setTitleColor(UIColor(color: .purpleWhite), for: .normal)
        goOnButton.round(radius: 4)
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
        branches.trailingAnchor.constraint(equalTo: addBranchButton.leadingAnchor, constant: -16).isActive = true
        branches.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8).isActive = true
        branches.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        branches.heightAnchor.constraint(equalTo: addBranchButton.heightAnchor).isActive = true
        
        goOnButton.translatesAutoresizingMaskIntoConstraints = false
        goOnButton.leadingAnchor.constraint(equalTo: branches.leadingAnchor).isActive = true
        goOnButton.trailingAnchor.constraint(equalTo: addBranchButton.trailingAnchor).isActive = true
        goOnButton.topAnchor.constraint(equalTo: branches.topAnchor).isActive = true
        goOnButton.bottomAnchor.constraint(equalTo: branches.bottomAnchor).isActive = true
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
        } else {
            backgroundColor = UIColor(color: .yellowWhite)
            branches.isHidden = true
            addBranchButton.isHidden = true
            goOnButton.isHidden = false
        }
    }
    
    func reload(withText text: String?) {
        self.text = text
        if branches.isHidden == false { self.branches.reloadData() }
    }
    
    func adjustTextViewAndGoOnButton(offset: CGFloat) {
        textView.frame.size.height += offset
        goOnButton.frame.origin.y += offset
    }

}

extension UICollectionViewLayout {
    static var flow = UICollectionViewFlowLayout()
}