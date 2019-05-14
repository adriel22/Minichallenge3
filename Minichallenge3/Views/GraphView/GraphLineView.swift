//
//  GraphLineView.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class GraphLineView: UIView {

    var itemViews: [GraphItemView] {
        guard let itemViews = subviews as? [GraphItemView] else {
            fatalError("The GraphLineView items must be of type: GraphItemView")
        }

        return itemViews
    }

    var hasConnectionChildLine: Bool {
        for item in itemViews where item.connectors.count != 0 {
            return true
        }

        return false
    }
    
    var hasLeftSpace: Bool = false

    private var oldLineTopAnchor: NSLayoutConstraint?
    private var oldLineLeftAnchor: NSLayoutConstraint?

    /// It sets the constraints for a lineview.
    ///
    /// - Parameters:
    ///   - topAnchor: the top anchor of the line.
    /// If the line is bellow of other, this constraint must be the top line bottom anchor.
    /// If the line is the first one, this must be the container parent top anchor.
    ///   - lineMargin: a space beteween the lines
    func setConstraints(
        withTopAnchor topAnchor: NSLayoutYAxisAnchor,
        andLineMargin lineMargin: CGFloat,
        andLeftMargin leftMargin: CGFloat) {

        guard let containerView = superview else {
            return
        }

        if let oldTopAnchor = self.oldLineTopAnchor {
            oldTopAnchor.isActive = false
            removeConstraint(oldTopAnchor)
        }

        if let olfLeftAnchor = self.oldLineLeftAnchor {
            olfLeftAnchor.isActive = false
            removeConstraint(olfLeftAnchor)
        }

        translatesAutoresizingMaskIntoConstraints = false

        let lineViewHeightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: 150)
        lineViewHeightConstraint.priority = .defaultHigh

        let currentTopAnchor = self.topAnchor.constraint(equalTo: topAnchor, constant: lineMargin)
        self.oldLineTopAnchor = currentTopAnchor
        
        let currentLeftAnchor = leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: leftMargin)
        self.oldLineLeftAnchor = currentLeftAnchor

        NSLayoutConstraint.activate([
            currentTopAnchor,
            currentLeftAnchor,
            lineViewHeightConstraint
        ])
    }

    /// It sets the constraints to close the container view after many line views. Must be called to the last lineview.
    func setClosingConstraints() {
        guard let containerView = superview else {
            return
        }

        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}
