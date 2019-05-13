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

        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: widthAnchor),
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: columnMargin),
            self.topAnchor.constraint(equalTo: lineView.topAnchor),
            self.bottomAnchor.constraint(lessThanOrEqualTo: lineView.bottomAnchor)
        ])
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
