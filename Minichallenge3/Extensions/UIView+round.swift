//
//  UIView+Extensions.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

extension UIView {
    func round(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
