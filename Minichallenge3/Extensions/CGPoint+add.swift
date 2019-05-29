//
//  CGPoint+add.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

extension CGPoint {
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public func addingToX(_ xAddition: CGFloat) -> CGPoint {
        return CGPoint(x: x + xAddition, y: y)
    }

    public func addingToY(_ yAddition: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y + yAddition)
    }

    public func translateToX(_ xPosition: CGFloat) -> CGPoint {
        return CGPoint(x: xPosition, y: y)
    }

    public func translateToY(_ yPosition: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: yPosition)
    }

    public func translateToX(of point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x, y: y)
    }

    public func translateToY(of point: CGPoint) -> CGPoint {
        return CGPoint(x: x, y: point.y)
    }
    
    public func distanceTo(otherPoint: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - otherPoint.x, 2) + pow(self.y - otherPoint.y, 2))
    }
}
