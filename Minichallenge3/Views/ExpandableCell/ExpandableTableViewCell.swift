//
//  ExpandableTableViewCell.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 09/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

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

        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true

        separator = UIView(frame: .zero)
        separator.backgroundColor = .clear
        addSubview(separator)

        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        separator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 16).isActive = true

        button = UIButton(frame: .zero)
        button.setTitle("Ver mais", for: .normal)
        button.backgroundColor = UIColor(color: .darkBlue)
        button.setTitleColor(UIColor(color: .yellowWhite), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.round(radius: 4)
        addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        let screenWidthWithEdges = UIScreen.main.bounds.width - 32
        button.widthAnchor.constraint(equalToConstant: screenWidthWithEdges/3).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        button.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: (screenWidthWithEdges/3)/3.5).isActive = true

        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        buttonAction?(sender)
    }
}
