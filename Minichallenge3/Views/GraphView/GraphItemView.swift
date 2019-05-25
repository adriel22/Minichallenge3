//
//  GraphItemView.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class GraphItemView: NotifierView {
    var parentLine: GraphLineView? {
        return self.superview as? GraphLineView
    }

    var connectors: [ItemViewConnector] = []

    var oldLeftAnchor: NSLayoutConstraint?
    var oldRightAnchor: NSLayoutConstraint?
    
    var eventHandler: GraphViewItemEventHandler?
    
    var shouldShake: Bool {
        return true
    }

    /// It sets the constraints for a item view
    ///
    /// - Parameters:
    ///   - leftAnchor: the item view left anchor.
    /// If the item is the first in the column, this must be the line left anchor.
    /// If the item is after other item, this must be the first item right anchor.
    ///   - widthAnchor: the width of the item.
    ///   - columnMargin: a margin between the columns
    func setConstraintsFor(
        leftAnchor: NSLayoutXAxisAnchor,
        widthAnchor: CGFloat,
        columnMargin: CGFloat) {

        guard let lineView = superview as? GraphLineView else {
            return
        }

        removeOpenConstraints()

        translatesAutoresizingMaskIntoConstraints = false

        let currentLeftAnchor = self.leftAnchor.constraint(equalTo: leftAnchor, constant: columnMargin)
        self.oldLeftAnchor = currentLeftAnchor

        let width = self.widthAnchor.constraint(equalToConstant: widthAnchor)
        NSLayoutConstraint.activate([
            width,
            currentLeftAnchor,
            self.topAnchor.constraint(equalTo: lineView.topAnchor),
            self.bottomAnchor.constraint(lessThanOrEqualTo: lineView.bottomAnchor)
        ])
    }

    func removeOpenConstraints() {
        if let leftAnchor = self.oldLeftAnchor {
            leftAnchor.isActive = false
            removeConstraint(leftAnchor)
        }
    }

    func removeClosingConstraints() {
        if let rightAnchor = self.oldRightAnchor {
            rightAnchor.isActive = false
            removeConstraint(rightAnchor)
        }
    }

    func setClosingConstraints() {
        guard let lineView = superview else {
            return
        }

        removeClosingConstraints()
        let currentRightAnchor = rightAnchor.constraint(equalTo: lineView.rightAnchor)
        currentRightAnchor.isActive = true
        self.oldRightAnchor = currentRightAnchor
    }
    
    func shake(repeatCount: Float) {
        guard shouldShake else {
            return
        }
        
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        shakeAnimation.duration = 0.07
        shakeAnimation.repeatCount = repeatCount
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = 0.02
        shakeAnimation.toValue = -0.02
        
        scaleAnimation.duration = 0.07
        scaleAnimation.repeatCount = repeatCount
        scaleAnimation.autoreverses = true
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 1.01
        
        self.layer.removeAnimation(forKey: "item_shaking")
        self.layer.removeAnimation(forKey: "item_scaling")
        self.layer.add(shakeAnimation, forKey: "item_shaking")
        self.layer.add(scaleAnimation, forKey: "item_scaling")
    }
}
