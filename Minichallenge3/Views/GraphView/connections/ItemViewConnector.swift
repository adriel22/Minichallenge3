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
//        for constraint in firstItemConnector.constraints {
//            constraint.isActive = false
//            firstItemConnector.removeConstraint(constraint)
//        }
//        for constraint in secondItemConnector.constraints {
//            constraint.isActive = false
//            secondItemConnector.removeConstraint(constraint)
//        }
//        for constraint in bendItemConnector.constraints {
//            constraint.isActive = false
//            bendItemConnector.removeConstraint(constraint)
//        }
        
        for constraint in allConstraints {
            constraint.isActive = false
        }
//        firstItemConnector.removeConstraints(firstItemConnector.constraints)
//        secondItemConnector.removeConstraints(secondItemConnector.constraints)
//        bendItemConnector.removeConstraints(bendItemConnector.constraints)
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
            secondItemConnector.topAnchor.constraint(equalTo: bendItemConnector.bottomAnchor),

            bendItemConnector.heightAnchor.constraint(equalToConstant: lineWidth),
            bendItemConnector.topAnchor.constraint(equalTo: firstItemConnector.bottomAnchor)
        ]

        switch direction {
        case .left:
            constraints.append(contentsOf: [
                bendItemConnector.leftAnchor.constraint(equalTo: secondItemConnector.leftAnchor),
                bendItemConnector.rightAnchor.constraint(equalTo: firstItemConnector.rightAnchor)
            ])
        case .right:
            constraints.append(contentsOf: [
                bendItemConnector.leftAnchor.constraint(equalTo: firstItemConnector.leftAnchor),
                bendItemConnector.rightAnchor.constraint(equalTo: secondItemConnector.rightAnchor)
            ])
        }

        removeAllConstraints()

        self.allConstraints = constraints
        NSLayoutConstraint.activate(constraints: constraints, withPriority: .defaultLow)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
