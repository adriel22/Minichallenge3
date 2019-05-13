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
    
    var text: UITextView!
    var branches: UICollectionView!
    var addBranchButton: UIButton!
    var goOnButton: UIButton!
    
    var position: Position! {
        didSet {
            positionSet()
        }
    }
    
    convenience init(position: Position) {
        self.init(frame: .zero)
        self.position = position
        positionSet()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(color: .purpleWhite)
        
        text = UITextView(frame: .zero)
        text.backgroundColor = .clear
        text.textColor = UIColor(color: .darkerBlue)
        text.font = UIFont(name: "Baskerville", size: 17)
        addSubview(text)
        
        text.translatesAutoresizingMaskIntoConstraints = false
        text.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        text.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        text.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        
        addBranchButton = UIButton(frame: .zero)
        addBranchButton.backgroundColor = UIColor(color: .darkBlue)
        addBranchButton.round(radius: 24)
        addSubview(addBranchButton)
        
        addBranchButton.translatesAutoresizingMaskIntoConstraints = false
        addBranchButton.trailingAnchor.constraint(equalTo: text.trailingAnchor).isActive = true
        addBranchButton.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 8).isActive = true
        addBranchButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        addBranchButton.widthAnchor.constraint(equalTo: addBranchButton.heightAnchor).isActive = true
        addBranchButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        let layout = UICollectionViewLayout.flow
        layout.scrollDirection = .horizontal
        branches = UICollectionView(frame: .zero, collectionViewLayout: layout)
        branches.backgroundColor = .clear
        branches.showsHorizontalScrollIndicator = false
        branches.showsVerticalScrollIndicator = false
        addSubview(branches)
        
        branches.translatesAutoresizingMaskIntoConstraints = false
        branches.leadingAnchor.constraint(equalTo: text.leadingAnchor).isActive = true
        branches.trailingAnchor.constraint(equalTo: addBranchButton.leadingAnchor, constant: -16).isActive = true
        branches.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 8).isActive = true
        branches.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        branches.heightAnchor.constraint(equalTo: addBranchButton.heightAnchor).isActive = true
        
        let nib = UINib(nibName: "BranchCollectionViewCell", bundle: .main)
        branches.register(nib, forCellWithReuseIdentifier: "cell")
        
        goOnButton = UIButton(frame: .zero)
        goOnButton.backgroundColor = UIColor(color: .darkBlue)
        goOnButton.setTitle("Continuar", for: .normal)
        goOnButton.setTitleColor(UIColor(color: .purpleWhite), for: .normal)
        goOnButton.round(radius: 4)
        addSubview(goOnButton)
    
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
            branches.isHidden = false
            addBranchButton.isHidden = false
            goOnButton.isHidden = true
        } else {
            branches.isHidden = true
            addBranchButton.isHidden = true
            goOnButton.isHidden = false
        }
    }

}

extension UICollectionViewLayout {
    static var flow = UICollectionViewFlowLayout()
}
