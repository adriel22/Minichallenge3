//
//  ExpandableTableViewCell.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 09/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
import SnapKit

class ExpandableTableViewCell: UITableViewCell {

    var label: UILabel!
    private var separator: UIView!
    var button: UIButton!
    
    var buttonAction: ((UIButton) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(color: .purpleWhite)

        label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "Baskerville", size: 17)
        label.text = "Jurema é uma verdadeira aventureira. Todos os seus dias são recheados de dificuldades e desafios. Embarque nessa aventura e ajude-a a conseguir alcançar suas metas."
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
        
        separator = UIView(frame: .zero)
        separator.backgroundColor = .clear
        addSubview(separator)
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.leading.equalTo(0)
            make.height.equalTo(16)
        }

        button = UIButton(frame: .zero)
        button.setTitle("Ver mais", for: .normal)
        button.backgroundColor = UIColor(color: .darkBlue)
        button.setTitleColor(UIColor(color: .yellowWhite), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.round(radius: 4)
        addSubview(button)

        button.snp.makeConstraints { make in
            let screenWidthWithEdges = UIScreen.main.bounds.width - 32
            make.width.equalTo(screenWidthWithEdges/3)
            make.trailing.equalTo(-16)
            make.top.equalTo(separator.snp.bottom)
            make.height.equalTo((screenWidthWithEdges/3)/3.5)
        }
        
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

    }

    @objc private func buttonTapped(_ sender: UIButton) {
        buttonAction?(sender)
    }

}
