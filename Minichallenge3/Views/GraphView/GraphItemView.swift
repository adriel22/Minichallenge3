//
//  GraphItemView.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class GraphItemView: UIView {
    var didLayoutSubViewsCompletions: [(() -> Void)] = []

    var parentLine: GraphLineView? {
        return self.superview as? GraphLineView
    }

    var connectors: [ItemViewConnector] = []

    var oldLeftAnchor: NSLayoutConstraint?
    var oldRightAnchor: NSLayoutConstraint?

    override func layoutSubviews() {
        didLayoutSubViewsCompletions.forEach { (completion) in
            completion()
        }
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
//        width.priority = .defaultHigh
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

    /// Wait for the layout of subviews of two Graph Items
    ///
    /// - Parameters:
    ///   - item1: the first item
    ///   - item2: the second item
    ///   - completion: a completion called when the layout happens
    static public func waitForSubviewLayout(
        item1: GraphItemView,
        item2: GraphItemView,
        completion: @escaping () -> Void) {

        var item1WasLayout = false
        var item2WasLayout = false

        item1.didLayoutSubViewsCompletions.append {
            item1WasLayout = true
            if item2WasLayout {
                completion()
                item2WasLayout = false
                item1WasLayout = false
            }
        }

        item2.didLayoutSubViewsCompletions.append {
            item2WasLayout = true
            if item1WasLayout {
                completion()
                item2WasLayout = false
                item1WasLayout = false
            }
        }
    }
}
