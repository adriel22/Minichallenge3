//
//  UIBezierPath+addPolygon.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

extension UIBezierPath {
    func addPolygon(withPoints polygonPoints: [CGPoint], closePolygon: Bool = false) {
        guard let firstPoint = polygonPoints.first else {
            return
        }

        move(to: firstPoint)
        polygonPoints.forEach { (currentPoint) in
            addLine(to: currentPoint)
        }

        if closePolygon {
            move(to: firstPoint)
        }
    }
}
