//
//  NSLayoutConstraint+activate.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    static func activate(constraints: [NSLayoutConstraint], withPriority priority: UILayoutPriority) {
        constraints.forEach { (currentConstraint) in
            currentConstraint.priority = priority
        }

        NSLayoutConstraint.activate(constraints)
    }
}
