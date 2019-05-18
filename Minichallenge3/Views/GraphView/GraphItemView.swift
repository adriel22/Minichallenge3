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
    
    var eventHandler: GraphViewEventHandler?

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
}
