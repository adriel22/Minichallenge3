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
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
     
    }
}
