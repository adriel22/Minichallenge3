//
//  GraphConnectionView.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class GraphConnectionView: UIView {

    var originPoint: CGPoint
    var destinyPoint: CGPoint
    var bendPoint: CGPoint

    init(withOriginPoint originPoint: CGPoint, bendPoint: CGPoint, andDestinyPoint destinyPoint: CGPoint) {
        self.originPoint = originPoint
        self.destinyPoint = destinyPoint
        self.bendPoint = bendPoint

        super.init(frame: CGRect.zero)
    }

    func drawConnection() {
        layer.addSublayer(
            makeConnection(
                withOriginPoint: self.originPoint,
                bendPoint: self.bendPoint,
                andDestinyPoint: self.destinyPoint
            )
        )
    }

    private func makeConnection(
        withOriginPoint originPoint: CGPoint,
        bendPoint: CGPoint,
        andDestinyPoint destinyPoint: CGPoint) -> CAShapeLayer {

        let bezier = UIBezierPath()
        let bezierPoints = [
            originPoint, bendPoint,
            bendPoint.translateToX(destinyPoint.x),
            destinyPoint
        ]
        bezier.addPolygon(withPoints: bezierPoints)

        let connectionPath = bezier.cgPath
        let connectionLayer = CAShapeLayer()
        connectionLayer.path = connectionPath
        connectionLayer.fillColor = UIColor.blue.cgColor

        return connectionLayer
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
