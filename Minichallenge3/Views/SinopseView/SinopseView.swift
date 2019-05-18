//
//  SinopseView.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class SinopseView: UIView {
    
    var text: String? {
        set {
            label.text = newValue
        }
        get {
            return label.text
        }
    }
    
    lazy var label: SinopseLabel = {
        let label = SinopseLabel()
        
        return label
    }()
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.frame = self.bounds
        
        blurEffectView.backgroundColor = UIColor.clear
        blurEffectView.alpha = 0.9
        
        return blurEffectView
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurEffectView)
        addSubview(label)
        
        backgroundColor = UIColor.clear
    }
    
    func setConstraints(superView: UIView) {
        let constraints = [
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            leftAnchor.constraint(equalTo: superView.leftAnchor),
            rightAnchor.constraint(equalTo: superView.rightAnchor),
            topAnchor.constraint(equalTo: superView.topAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func didMoveToSuperview() {
        guard let superView = self.superview else {
            return
        }
        
        setConstraints(superView: superView)
    }
}
