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
            sinopseTextView.text = newValue
        }
        get {
            return sinopseTextView.text
        }
    }
    
    lazy var sinopseTextView: SinopseTextView = {
        let sinopseTextView = SinopseTextView()
        
        return sinopseTextView
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
        sinopseTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurEffectView)
        addSubview(sinopseTextView)
        
        backgroundColor = UIColor.clear
    }
    
    func setConstraints(superView: UIView) {
        let constraints = [
            sinopseTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            sinopseTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            sinopseTextView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            sinopseTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            sinopseTextView.heightAnchor.constraint(equalToConstant: 60),
            
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
