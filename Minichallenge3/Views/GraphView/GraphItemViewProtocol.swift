//
//  GraphItemViewProtocol.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

protocol GraphItemViewProtocol where Self: UIView {
    func setConstraintsFor(leftAnchor: NSLayoutXAxisAnchor, widthAnchor: CGFloat, columnMargin: CGFloat)
}

extension GraphItemViewProtocol {

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
}
