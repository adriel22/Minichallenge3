//
//  GraphViewConnector.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

typealias Connection = (originPosition: GridPosition, destinyPosition: GridPosition)

/// A class responsible for connect the itemViews of a graphView
class GraphViewConnector {
    
    var currentItemConnectors: [ItemViewConnector] = []

    /// Place the connector views in the graph containerView
    ///
    /// - Parameters:
    ///   - datasource: the graph datasource
    ///   - graphView: the graphView
    ///   - containerView: the containerView
    func build(withDatasource datasource: GraphViewDatasource,
               graphView: GraphView,
               andContainerView containerView: UIView) {

        let numberOfColumns = datasource.gridSize(forGraphView: graphView).width
        let connectorMargin = connectionMargin(forLineSpacing: datasource.lineSpacing(forGraphView: graphView))

        let connectorOffset = itemConnectorsOffset(
            withNumberOfColumns: numberOfColumns,
            connectorMargins: connectorMargin,
            datasource: datasource,
            andGraphView: graphView
        )

        addConnectionViews(
            fromConnections: findConnections(
                inLineViews: graphView.lineViews,
                withDatasource: datasource,
                andGraphView: graphView
            ),
            withConnectorMargins: connectorMargin,
            connectorsOffset: connectorOffset,
            containerView: containerView,
            andGraphView: graphView
        )
    }

    /// Finds the connections of each graph item
    ///
    /// - Parameters:
    ///   - lineViews: the lineViews of the graph
    ///   - datasource: the datasource of de graph
    ///   - graphView: the graphView
    /// - Returns: the connections found in the search
    func findConnections(
        inLineViews lineViews: [GraphLineView],
        withDatasource datasource: GraphViewDatasource,
        andGraphView graphView: GraphView) -> [Connection] {

        let gridSize = datasource.gridSize(forGraphView: graphView)
        var connections: [Connection] = []

        (0..<gridSize.height).forEach { (currentLineIndex) in
            (0..<gridSize.width).forEach({ (currentColumnIndex) in
                let currentItemPosition = (xPosition: currentColumnIndex, yPosition: currentLineIndex)

                connections.append(contentsOf:
                    findConnection(
                        atPosition: currentItemPosition,
                        withDatasource: datasource,
                        andGraphView: graphView
                    )
                )
            })
        }
        return connections
    }

    func findConnection(
        atPosition position: GridPosition,
        withDatasource datasource: GraphViewDatasource,
        andGraphView graphView: GraphView) -> [Connection] {

        return datasource.connections(forGraphView: graphView, fromItemAtPosition: position)
                         .map({ (currentDestinyPosition) -> Connection in

                            return (originPosition: position, destinyPosition: currentDestinyPosition)
                        })
    }

    func connectionMargin(forLineSpacing lineSpacing: CGFloat) -> CGFloat {
        let connectorMargin = lineSpacing / 10

        return connectorMargin
    }

    /// Calculate the offset for the connector horizontal line height.
    /// This offset is the differente between the conncetors, it solve the superposition problem for the connectors
    ///
    /// - Parameters:
    ///   - numberOfColumns: the numberOfColumns in the graph.
    ///   - connectorMargins: the distance between the lineviews and the connector area.
    ///   - datasource: the
    ///   - graphView: the graphView
    /// - Returns: the offset
    func itemConnectorsOffset(
        withNumberOfColumns numberOfColumns: Int,
        connectorMargins: CGFloat,
        datasource: GraphViewDatasource,
        andGraphView graphView: GraphView) -> CGFloat {

        let connectorsArea = datasource.lineSpacing(forGraphView: graphView) - (connectorMargins * 2)

        let offset = connectorsArea / CGFloat(numberOfColumns)

        return offset
    }

    /// Add the connector views based on the given connections.
    ///
    /// - Parameters:
    ///   - connections: the connections between the items
    ///   - connectorMargins: the distance between the lineviews and the connectorArea
    ///   - connectorsOffset: the distance between the connector views of the items in the same line
    ///   - containerView: the containerView
    ///   - graphView: the graphView
    func addConnectionViews(
        fromConnections connections: [Connection],
        withConnectorMargins connectorMargins: CGFloat,
        connectorsOffset: CGFloat,
        containerView: UIView,
        andGraphView graphView: GraphView) {

        connections.forEach { (connection) in
            guard let destinyItemView = graphView.itemView(forPosition: connection.destinyPosition),
                  let originItemView = graphView.itemView(forPosition: connection.originPosition),
                  let originLineView = originItemView.parentLine,
                  let destinyLineView = destinyItemView.parentLine else {

                return
            }

            let itemConnector = ItemViewConnector(
                withContainerView: containerView,
                lineWidth: 3, originLineView: originLineView,
                andDestinyLineView: destinyLineView
            )

//            originItemView.connectors.append(itemConnector)
            self.currentItemConnectors.append(itemConnector)

            let layoutChangeCompletion = { [weak self] in
                guard self != nil else {
                    return
                }
                
                let posForOrigin = originItemView.convert(originItemView.bounds.origin, to: containerView)
                let posForDestiny = destinyItemView.convert(destinyItemView.bounds.origin, to: containerView)
                let positionInContainerForOrigin = originLineView.convert(originItemView.center, to: containerView)
                let positionInContainerForDestiny = destinyLineView.convert(destinyItemView.center, to: containerView)
//                if posForOrigin.x.isEqual(to: 0.0) || posForDestiny.x.isEqual(to: 0.0) {
//                    return
//                }
//                print(positionInContainerForOrigin.x, positionInContainerForDestiny.x, posForOrigin.x, posForDestiny.x )

//                let direction = posForOrigin.x > posForDestiny.x ?
//                    ItemViewConnectorDirection.left :
//                    ItemViewConnectorDirection.right

                /// The bendDistance is the distance from the originLineView to the begin of the connector view
                let bendDistance = connectorMargins +
                    (connectorsOffset * CGFloat(connection.originPosition.xPosition))

                itemConnector.createLine(fromPoint: positionInContainerForOrigin, toPoint: positionInContainerForDestiny, inContainerView: containerView)

//                itemConnector.setConstraints(
//                    fromOriginItem: originItemView, toDestinyItem: destinyItemView,
//                    withBendDistance: bendDistance,
//                    andDirection: direction
//                )
            }

            GraphLineView.waitForSubviewLayout(line1: originLineView, line2: destinyLineView, completion: layoutChangeCompletion)
            GraphItemView.waitForSubviewLayout(item1: originItemView, item2: destinyItemView, completion: layoutChangeCompletion)
            destinyItemView.didLayoutSubViewsCompletions.append(layoutChangeCompletion)
            originItemView.didLayoutSubViewsCompletions.append(layoutChangeCompletion)
            originLineView.didLayoutSubViewsCompletions.append(layoutChangeCompletion)
            destinyLineView.didLayoutSubViewsCompletions.append(layoutChangeCompletion)

            (containerView as? GraphLineView)?.didLayoutSubViewsCompletions.append(layoutChangeCompletion)
        }
    }

    func removeConnectors(fromContainerView containerView: UIView) {
        for connector in currentItemConnectors {
            connector.lineLayer?.removeFromSuperlayer()
        }
    }

    /// Remove all the connector views from the containerView
    ///
    /// - Parameter containerView: the containerView
    func removeAllConnectors(fromContainerView containerView: UIView) {
        containerView.subviews.compactMap { (subview) -> GraphConnectionView? in
            return subview as? GraphConnectionView
        }.forEach { (connectorView) in
            connectorView.removeFromSuperview()
        }
    }
}
