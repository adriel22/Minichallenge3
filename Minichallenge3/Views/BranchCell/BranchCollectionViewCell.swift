//
//  BranchCollectionViewCell.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class BranchCollectionViewCell: UICollectionViewCell {

    private lazy var selectionBackground: UIView! = UIView(frame: .zero)
    private lazy var label: UILabel! = UILabel(frame: .zero)
    
    var title: String? = "" {
        didSet {
            if let label = label {
                label.text = title
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        round(radius: 4)
        
        configureBackground()
        addSubview(selectionBackground)
        
        configureLabel()
        setConstraints()
        
    }
    
    private func configureBackground() {
        selectionBackground.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        selectionBackground.round(radius: 4)
    }
    
    private func configureLabel() {
        label.textColor = UIColor(color: .darkerBlue)
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        addSubview(label)
    }
    
    private func setConstraints() {
        selectionBackground.translatesAutoresizingMaskIntoConstraints = false
        selectionBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
        selectionBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        selectionBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        selectionBackground.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func select() {
        selectionBackground.backgroundColor = UIColor(color: .darkBlue)
        label.textColor = UIColor(color: .purpleWhite)
        label.font = .systemFont(ofSize: 13, weight: .semibold)
    }
    
    func deselect() {
        selectionBackground.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        label.textColor = UIColor(color: .darkerBlue)
        label.font = .systemFont(ofSize: 13, weight: .regular)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
