//
//  ItemViewConnector.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

/// A class responsible for make views that connects two specific item views
class ItemViewConnector {
    var originLineView: GraphLineView
    var destinyLineView: GraphLineView

    var lineWidth: CGFloat

    var lineLayer: CAShapeLayer?

    /// Initialize the view components of the connection
    ///
    /// - Parameters:
    ///   - containerView: the containerView
    ///   - lineWidth: the width of the connection line
    ///   - originLineView: the line view for the origin item
    ///   - destinyLineView: the line view for the destiny item
    init(
        withContainerView containerView: UIView,
        lineWidth: CGFloat,
        originLineView: GraphLineView,
        andDestinyLineView destinyLineView: GraphLineView) {

        self.lineWidth = lineWidth

        self.originLineView = originLineView
        self.destinyLineView = destinyLineView
    }

    func createLine(
        fromItemView1 originItemView: GraphItemView,
        toItemView2 destinyItemView: GraphItemView,
        withBendDistance bendDistance: CGFloat,
        inContainerView containerView: UIView) {

        lineLayer?.removeFromSuperlayer()

        let originLineViewBottom = originLineView.frame.maxY

        let positionInContainerForOrigin = originLineView.convert(
            originItemView.center.translateToY(originItemView.frame.maxY),
            to: containerView
        )

        let positionInContainerForDestiny = destinyLineView.convert(
            destinyItemView.center.translateToY(destinyItemView.frame.minY),
            to: containerView
        )

        let connectionPoints = [
            positionInContainerForOrigin,
            positionInContainerForOrigin.translateToY(originLineViewBottom + bendDistance),
            positionInContainerForOrigin.translateToY(originLineViewBottom + bendDistance).translateToX(of: positionInContainerForDestiny),
            positionInContainerForDestiny
        ]

        let bezierPath = UIBezierPath()
        bezierPath.addPolygon(withPoints: connectionPoints, closePolygon: false)

        let connectorLayer = CAShapeLayer()
        connectorLayer.path = bezierPath.cgPath
        connectorLayer.strokeColor = UIColor.green.cgColor
        connectorLayer.lineWidth = lineWidth
        connectorLayer.fillColor = UIColor.clear.cgColor

        containerView.layer.insertSublayer(connectorLayer, at: 0)
        self.lineLayer = connectorLayer
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
