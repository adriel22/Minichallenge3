//
//  ExpandableTableViewHeaderView.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 10/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class ExpandableTableViewHeaderView: UIView {

    lazy var label: UILabel! = UILabel(frame: .zero)
    lazy var button: UIButton! = UIButton(frame: .zero)
    
    lazy var isCollapsed = true
    var didTap: ((UIButton) -> Void)?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        configureLabel()
        addSubview(label)

        configureButton()
        addSubview(button)
        
    }
    
    private func configureLabel() {
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(rgb: 0x8E8E93)
    }
    
    private func configureButton() {
        button.setTitleColor(UIColor(color: .darkBlue), for: .normal)
        button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
    }
    
    private func setConstraints() {
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc private func tapped(_ sender: UIButton) {
        didTap?(sender)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented yet")
    }

}
