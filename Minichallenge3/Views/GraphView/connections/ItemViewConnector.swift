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
    typealias ConnectionViewDescriptor = (originConnector: UIView, destinyConnector: UIView, bendConnector: UIView)

    var firstItemConnector = ItemViewConnector.makeConnector()
    var secondItemConnector = ItemViewConnector.makeConnector()
    var bendItemConnector = ItemViewConnector.makeConnector()

    var originLineView: GraphLineView
    var destinyLineView: GraphLineView

    var lineWidth: CGFloat

    var allConstraints: [NSLayoutConstraint] = []
    
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

        containerView.addSubview(firstItemConnector)
        containerView.addSubview(secondItemConnector)
        containerView.addSubview(bendItemConnector)
    }

    private static func makeConnector() -> GraphConnectionView {
        let connector = GraphConnectionView()
        connector.backgroundColor = UIColor.black
        connector.translatesAutoresizingMaskIntoConstraints = false

        return connector
    }

    func removeAllConstraints() {
        for constraint in allConstraints {
            constraint .isActive = false
            //remover
        }
    }

    func removeFromSuperview() {
        firstItemConnector.removeFromSuperview()
        secondItemConnector.removeFromSuperview()
        bendItemConnector.removeFromSuperview()
    }

    /// Set the constraints for the connection view components.
    ///
    /// - Parameters:
    ///   - originItem: the origin item view
    ///   - destinyItem: the destiny item view
    ///   - bendDistance: the bendDistance is the distance
    /// between the origin item lineview end the begin of the connection view
    ///   - direction: the direction of the connection
    func setConstraints(
        fromOriginItem originItem: GraphItemView,
        toDestinyItem destinyItem: GraphItemView,
        withBendDistance bendDistance: CGFloat,
        andDirection direction: ItemViewConnectorDirection) {

        var constraints = [
            firstItemConnector.centerXAnchor.constraint(equalTo: originItem.centerXAnchor),
            firstItemConnector.topAnchor.constraint(equalTo: originItem.bottomAnchor),
            firstItemConnector.widthAnchor.constraint(equalToConstant: lineWidth),
            firstItemConnector.bottomAnchor.constraint(equalTo: originLineView.bottomAnchor, constant: bendDistance),

            secondItemConnector.centerXAnchor.constraint(equalTo: destinyItem.centerXAnchor),
            secondItemConnector.bottomAnchor.constraint(equalTo: destinyLineView.topAnchor),
            secondItemConnector.widthAnchor.constraint(equalToConstant: lineWidth),
            secondItemConnector.topAnchor.constraint(equalTo: firstItemConnector.bottomAnchor, constant: CGFloat(-3)),

            bendItemConnector.heightAnchor.constraint(equalToConstant: lineWidth),
//            bendItemConnector.widthAnchor.constraint(equalToConstant: 50)
        ]

//        switch direction {
//        case .left:
//            constraints.append(contentsOf: [
//                bendItemConnector.leftAnchor.constraint(equalTo: secondItemConnector.leftAnchor),
//                bendItemConnector.rightAnchor.constraint(equalTo: firstItemConnector.rightAnchor)
//            ])
//        case .right:
//            constraints.append(contentsOf: [
//                firstItemConnector.leftAnchor.constraint(equalTo: bendItemConnector.leftAnchor),
//                secondItemConnector.rightAnchor.constraint(equalTo: bendItemConnector.rightAnchor)
//            ])
//        }

        switch direction {
        case .left:
            constraints.append(contentsOf: [
//                bendItemConnector.leftAnchor.constraint(equalTo: secondItemConnector.leftAnchor),
//                bendItemConnector.rightAnchor.constraint(equalTo: firstItemConnector.rightAnchor)
                secondItemConnector.trailingAnchor.constraint(equalTo: bendItemConnector.leadingAnchor),
                bendItemConnector.topAnchor.constraint(equalTo: secondItemConnector.topAnchor),
                bendItemConnector.trailingAnchor.constraint(equalTo: firstItemConnector.leadingAnchor)

            ])

            secondItemConnector.backgroundColor = .red
            firstItemConnector.backgroundColor = .red
            bendItemConnector.backgroundColor = .red
        case .right:
            constraints.append(contentsOf: [
//                firstItemConnector.leftAnchor.constraint(equalTo: bendItemConnector.leftAnchor),
//                secondItemConnector.rightAnchor.constraint(equalTo: bendItemConnector.rightAnchor)
                bendItemConnector.topAnchor.constraint(equalTo: secondItemConnector.topAnchor),
                bendItemConnector.leadingAnchor.constraint(equalTo: firstItemConnector.leadingAnchor),
                bendItemConnector.trailingAnchor.constraint(equalTo: secondItemConnector.leadingAnchor)
            ])

            secondItemConnector.backgroundColor = .blue
            firstItemConnector.backgroundColor = .blue
            bendItemConnector.backgroundColor = .blue
        }

        removeAllConstraints()
        self.allConstraints = constraints
//        NSLayoutConstraint.activate(constraints: constraints, withPriority: .defaultLow)
        NSLayoutConstraint.activate(constraints)
    }

    func createLine(fromPoint point1: CGPoint, toPoint point2: CGPoint, inContainerView containerView: UIView) {
        lineLayer?.removeFromSuperlayer()

//        let bezierRect = CGRect(fromPoint: point1, toPoint: point2)
        self.lineLayer?.removeFromSuperlayer()
        let bezierPath = UIBezierPath()
        bezierPath.move(to: point1)
        bezierPath.addLine(to: point2)

        let connectorLayer = CAShapeLayer()
        connectorLayer.path = bezierPath.cgPath
        connectorLayer.strokeColor = UIColor.green.cgColor
        connectorLayer.fillColor = UIColor.green.cgColor
        connectorLayer.lineWidth = lineWidth

        containerView.layer.insertSublayer(connectorLayer, at: 0)
        self.lineLayer = connectorLayer
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
