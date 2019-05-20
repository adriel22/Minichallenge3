//
//  SinopseLabel.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class SinopseLabel: UITextView {
    override var text: String? {
        set {
            super.text = "\"\(newValue ?? " ")\""
        }
        get {
            return super.text
        }
    }
    
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        font = UIFont(name: "Baskerville", size: CGFloat(17))
        textAlignment = .center
        textColor = UIColor(color: .darkBlue)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clear
    }
}
