//
//  ToolboxView.swift
//  Minichallenge3
//
//  Created by Alan Victor Paulino de Oliveira on 20/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class ToolboxView: UIView {

    lazy var addView = UIImageView(imageNamed: "addTool")
    
    lazy var connectionView = UIImageView(imageNamed: "connectionTool")
    
    lazy var trashView = UIImageView(imageNamed: "trashTool")
    
    var currentOption: Int = -1
    
    var lineView: UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    weak var delegate: ToolboxViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(color: .darkBlue)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        addSubview(addView)
        addConstraintToImageView(referenceTopView: self, constraintView: addView)
        let line1 = addLineViewWithConstraints(referenceTopView: addView)
        addSubview(trashView)
        addConstraintToImageView(referenceTopView: line1, constraintView: trashView)
        let line2 = addLineViewWithConstraints(referenceTopView: trashView)
        addSubview(connectionView)
        addConstraintToImageView(referenceTopView: line2, constraintView: connectionView, lastView: true)
        createTapGesture(inView: addView, withFunctionObserver: #selector(tappedInAddNode(_:)))
        createTapGesture(inView: connectionView, withFunctionObserver: #selector(tappedInConnection(_:)))
        createTapGesture(inView: trashView, withFunctionObserver: #selector(tappedInTrash(_:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLineViewWithConstraints(referenceTopView: UIView) -> UIView {
        let line = lineView
        addSubview(line)
        
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: referenceTopView.bottomAnchor, constant: 16),
            line.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4),
            self.rightAnchor.constraint(equalTo: line.rightAnchor, constant: 4),
            line.heightAnchor.constraint(equalToConstant: 2)
            ])
        
        return line
    }
    
    private func addConstraintToImageView(referenceTopView: UIView, constraintView: UIView, lastView: Bool = false) {
        let topAnchorEqualTo: NSLayoutYAxisAnchor = referenceTopView == self ? referenceTopView.topAnchor : referenceTopView.bottomAnchor
        
        NSLayoutConstraint.activate([
            
            constraintView.topAnchor.constraint(equalTo: topAnchorEqualTo, constant: 16),
            constraintView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            constraintView.heightAnchor.constraint(equalTo: constraintView.widthAnchor),
            constraintView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        if lastView {
            NSLayoutConstraint.activate([constraintView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)])
        }
    }
    
    func createTapGesture(inView view: UIView, withFunctionObserver action: Selector?) {
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tappedInAddNode(_ tapGesture: UIGestureRecognizer) {
        if currentOption != 0 {
            reloadImages()
            setImageCheckout(imageView: tapGesture.view)
            delegate?.tappedButtonAddNode()
            currentOption = 0
        } else {
            currentOption = -1
            delegate?.tappedButtonCheck()
            reloadImages()
        }
    }
    
    @objc func tappedInTrash(_ tapGesture: UIGestureRecognizer) {
        if currentOption != 1 {
            reloadImages()
            setImageCheckout(imageView: tapGesture.view)
            delegate?.tappedButtonTrash()
            currentOption = 1
        } else {
            currentOption = -1
            delegate?.tappedButtonCheck()
            reloadImages()
        }
    }
    
    @objc func tappedInConnection(_ tapGesture: UIGestureRecognizer) {
        if currentOption != 2 {
            reloadImages()
            setImageCheckout(imageView: tapGesture.view)
            delegate?.tappedButtonConnection()
            currentOption = 2
        } else {
            currentOption = -1
            delegate?.tappedButtonCheck()
            reloadImages()
        }
    }
    
    func setImageCheckout(imageView: UIView?) {
        guard let imageView = imageView as? UIImageView else {
            return
        }
        
        imageView.image = UIImage(named: "check")
    }
    
    func reloadImages() {
        addView.image = UIImage(named: "addTool")
        connectionView.image = UIImage(named: "connectionTool")
        trashView.image = UIImage(named: "trashTool")
    }
}

extension UIImageView {
    convenience init(imageNamed: String) {
        self.init()
        self.image = UIImage(named: imageNamed)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
    }
}
