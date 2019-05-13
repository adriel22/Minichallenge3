//
//  BranchCollectionViewCell.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class BranchCollectionViewCell: UICollectionViewCell {

    private var selectionBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionBackground = UIView(frame: .zero)
        selectionBackground.backgroundColor = .clear
        addSubview(selectionBackground)
        selectionBackground.translatesAutoresizingMaskIntoConstraints = false
        selectionBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
        selectionBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        selectionBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        selectionBackground.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func select() {
        selectionBackground.backgroundColor = UIColor()
    }
    
    func deselect() {
        
    }

}
