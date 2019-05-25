//
//  ExpandableTableViewHeaderView.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 10/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class ExpandableTableViewHeaderView: UIView {

    private lazy var label: UILabel! = UILabel(frame: .zero)
    private lazy var button: UIButton! = UIButton(frame: .zero)
    var didTap: ((UIButton) -> Void)?
    
    var isTheLastSection = false {
        didSet {
            button.isHidden = !isTheLastSection
        }
    }
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configureLabel()
        addSubview(label)
        
        configureButton()
        addSubview(button)
        
        backgroundColor = UIColor(rgb: 0xEFEFF4)
        setConstraints()
        
    }
    
    private func configureLabel() {
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(rgb: 0x8E8E93)
    }
    
    private func configureButton() {
        button.isHidden = true
        button.round(radius: 4)
        button.backgroundColor = UIColor(color: .darkBlue)
        button.setTitleColor(UIColor(color: .yellowWhite), for: .normal)
        button.setTitle("Desfazer", for: .normal)
        button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
    }
    
    private func setConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
    
    @objc private func tapped(_ sender: UIButton) {
        didTap?(sender)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented yet")
    }

}
