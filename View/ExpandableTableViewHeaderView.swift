//
//  ExpandableTableViewHeaderView.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 10/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
import SnapKit

class ExpandableTableViewHeaderView: UIView {

    var label: UILabel!
    var button: UIButton!
    var didTap: ((UIButton) -> Void)?
    var isCollapsed = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(rgb: 0xF7F7F7)
        
        label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        addSubview(label)
        
        button = UIButton()
        button.setTitleColor(UIColor(color: .darkBlue), for: .normal)
        button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        addSubview(button)
        
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
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented yet")
    }
    
    @objc private func tapped(_ sender: UIButton) {
        didTap?(sender)
    }

}
