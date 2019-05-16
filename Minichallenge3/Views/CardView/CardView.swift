//
//  CardView.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 15/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import UIKit

enum States {
    case normal
    case create
    case erase
    case empty
}
class CardView: GraphItemView {
    private var state: States {
        didSet {
            resetCard()
        }
    }
    private let textView: UITextView

    init() {
        textView = UITextView()
        state = .normal
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        changeState(to: .normal)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeState(to stateType: States) {
        switch stateType {
        case .normal:
            self.state = .normal

            self.backgroundColor = UIColor(color: .yellowWhite)

            self.addSubview(textView)
            setTextView()

            addShadow()

        case .empty:
            self.state = .empty

            self.backgroundColor = UIColor.clear
            self.layoutSubviews()

        case .erase:
            self.state = .erase
            self.backgroundColor = UIColor(color: .yellowWhite)

            self.addSubview(textView)
            setTextView()

            setOpacityLayer()

            setIcon(withImage: UIImage(named: "garbage")!, andColor: UIColor(color: .red))

            addShadow()

        case .create:
            self.state = .create
            self.backgroundColor = UIColor(color: .yellowWhite)

            self.addSubview(textView)
            setTextView()

            setOpacityLayer()

            setIcon(withImage: UIImage(named: "add")!, andColor: UIColor(color: .darkBlue))

            addShadow()

        }
    }

    private func setTextView() {
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        textView.textAlignment = .center
        textView.font = UIFont(name: "Baskerville", size: CGFloat(17))

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        textView.tag = 1

    }

    private func setOpacityLayer() {
        let opacityView = UIView()
        opacityView.backgroundColor = UIColor.white
        opacityView.alpha = 0.9

        self.addSubview(opacityView)

        opacityView.translatesAutoresizingMaskIntoConstraints = false
        opacityView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        opacityView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        opacityView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = translatesAutoresizingMaskIntoConstraints
        opacityView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        opacityView.tag = 1
    }
    private func setIcon(withImage image: UIImage, andColor color: UIColor) {
        let icon = UIImageView(image: image)
        icon.contentMode = .scaleAspectFit
        icon.sizeThatFits(CGSize(width: 10, height: 10))
        icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = color
        self.addSubview(icon)

        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        icon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        icon.tag = 1
    }
    private func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
    }

    func setCardText(_ text: String) {
        self.textView.text = text
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if self.state == .empty {
            let borderView = CAShapeLayer()
            borderView.strokeColor = UIColor.gray.cgColor
            borderView.lineDashPattern = [10, 10]
            borderView.lineWidth = CGFloat(3)
            borderView.frame = self.bounds
            borderView.fillColor = nil
            borderView.path = UIBezierPath(rect: self.bounds).cgPath
            self.layer.addSublayer(borderView)

            borderView.name = "borderView"
        }
    }
    private func resetCard() {
        self.subviews.forEach({if $0.tag == 1 {
            $0.removeFromSuperview()
        }

        })
        self.backgroundColor = UIColor.clear
        self.layer.sublayers?.forEach({if $0.name == "borderView"{
            $0.removeFromSuperlayer()
            }})
        self.layer.shadowOpacity = 0
    }
}
