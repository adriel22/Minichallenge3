//
//  ItemViewConnector.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class ItemViewConnector {
    typealias ConnectionViewDescriptor = (originConnector: UIView, destinyConnector: UIView, bendConnector: UIView)

    var firstItemConnector: UIView
    var secondItemConnector: UIView
    var bendItemConnector: UIView
    var lineWidth: CGFloat

    init(containerView: UIView, lineWidth: CGFloat) {
        self.firstItemConnector = GraphConnectionView()
        firstItemConnector.backgroundColor = UIColor.black
        firstItemConnector.translatesAutoresizingMaskIntoConstraints = false

        self.secondItemConnector = GraphConnectionView()
        secondItemConnector.backgroundColor = UIColor.black
        secondItemConnector.translatesAutoresizingMaskIntoConstraints = false

        self.bendItemConnector = GraphConnectionView()
        bendItemConnector.backgroundColor = UIColor.black
        bendItemConnector.translatesAutoresizingMaskIntoConstraints = false

        self.lineWidth = lineWidth

        containerView.addSubview(firstItemConnector)
        containerView.addSubview(secondItemConnector)
        containerView.addSubview(bendItemConnector)
    }

    func setConstraints(
        fromOriginItem originItem: GraphItemView,
        toDestinyItem destinyItem: GraphItemView,
        withBendDistance bendDistance: CGFloat,
        andOriginLineView originLineView: GraphLineView,
        andDestinyLineView destinyLineView: GraphLineView,
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

        NSLayoutConstraint.activate(constraints: constraints, withPriority: .defaultLow)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
