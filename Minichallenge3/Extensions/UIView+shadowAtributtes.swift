//
//  UIView+shadowAtributtes.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 29/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

typealias ShadowAtributtes = (
    opacity: Float,
    radius: CGFloat,
    offset: CGSize,
    color: CGColor?,
    path: CGPath?
)

extension UIView {
    var shadowAtributtes: ShadowAtributtes {
        get {
            return (
                opacity: self.layer.shadowOpacity,
                radius: self.layer.shadowRadius,
                offset: self.layer.shadowOffset,
                color: self.layer.shadowColor,
                path: self.layer.shadowPath
            )
        }
        set {
            self.layer.shadowOpacity = newValue.opacity
            self.layer.shadowRadius = newValue.radius
            self.layer.shadowPath = newValue.path
            self.layer.shadowOffset = newValue.offset
            self.layer.shadowColor = newValue.color
        }
    }
}
