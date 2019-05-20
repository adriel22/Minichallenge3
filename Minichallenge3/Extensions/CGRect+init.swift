//
//  CGFrame+init.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 17/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

extension CGRect {
    init(fromPoint point1: CGPoint, toPoint point2: CGPoint) {
        let relativePoint = point2 - point1
        self.init(origin: point1, size: CGSize(width: relativePoint.x, height: relativePoint.y) )
    }
}
