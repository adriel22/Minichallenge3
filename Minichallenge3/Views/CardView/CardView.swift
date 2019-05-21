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
class CardView: GraphItemView, CardViewProtocol {
    private var state: States {
        didSet {
            resetCard()
        }
    }
    private let textView: UILabel
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        
        containerView.backgroundColor = UIColor(color: .yellowWhite)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        return containerView
    }()
    
    lazy var actionLabel: UILabel = {
        let actionLabel = UILabel()

        actionLabel.numberOfLines = 1
        actionLabel.text = "loading ..."
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionLabel.textAlignment = .center
        actionLabel.font = UIFont(name: "Baskerville", size: CGFloat(15))
        actionLabel.isHidden = true

        return actionLabel
    }()

    init() {
        textView = UILabel()
        textView.numberOfLines = 0
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

            containerView.backgroundColor = UIColor(color: .yellowWhite)

            self.addSubview(containerView)
            self.addSubview(actionLabel)
            containerView.addSubview(textView)
            setTextView()

            addShadow()

        case .empty:
            self.state = .empty

            self.containerView.backgroundColor = UIColor.clear
            self.layoutSubviews()

        case .erase:
            self.state = .erase
            self.containerView.backgroundColor = UIColor(color: .yellowWhite)

            self.addSubview(containerView)
            self.addSubview(actionLabel)
            containerView.addSubview(textView)
            setTextView()

            setOpacityLayer()

            setIcon(withImage: UIImage(named: "garbage")!, andColor: UIColor(color: .red))

            addShadow()

        case .create:
            self.state = .create
            self.containerView.backgroundColor = UIColor(color: .yellowWhite)

            self.addSubview(containerView)
            self.addSubview(actionLabel)
            containerView.addSubview(textView)
            setTextView()

            setOpacityLayer()

            setIcon(withImage: UIImage(named: "add")!, andColor: UIColor(color: .darkBlue))

            addShadow()
        }
    }

    private func setTextView() {
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.font = UIFont(name: "Baskerville", size: CGFloat(17))

        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            actionLabel.topAnchor.constraint(equalTo: self.topAnchor),
            actionLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            actionLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            containerView.topAnchor.constraint(equalTo: actionLabel.bottomAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        
        let heightConstraint = textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        heightConstraint.priority = .defaultHigh
        
        heightConstraint.isActive = true
        
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
        self.containerView.backgroundColor = UIColor.clear
        self.layer.sublayers?.forEach({if $0.name == "borderView"{
            $0.removeFromSuperlayer()
            }})
        self.layer.shadowOpacity = 0
    }

    func setup(withViewModel viewModel: HistoryNodeViewModel) {
        switch viewModel.currentState {
        case .normal:
            changeState(to: .normal)
        case .adding:
            changeState(to: .create)
        case .connecting:
            changeState(to: .empty)
        case .removing:
            changeState(to: .erase)
        }
        self.textView.text = viewModel.nodeResume
        if let optionName = viewModel.optionName {
            self.actionLabel.text = optionName
            self.actionLabel.isHidden = false
        }
    }
}
