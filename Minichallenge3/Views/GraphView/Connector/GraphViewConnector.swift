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
            withContext: (
                graphView: graphView,
                containerView: containerView,
                datasource: datasource
            )
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
        withContext context: Context) {

        connections.forEach { (connection) in
            guard let destinyItemView = context.graphView.itemView(forPosition: connection.destinyPosition),
                  let originItemView = context.graphView.itemView(forPosition: connection.originPosition),
                  let originLineView = originItemView.parentLine,
                  let destinyLineView = destinyItemView.parentLine else {

                return
            }

            let itemConnector = ItemViewConnector(
                withContainerView: context.containerView,
                lineWidth: context.datasource.connectionWidth(forGraphView: context.graphView),
                originLineView: originLineView, andDestinyLineView: destinyLineView
            )

            self.currentItemConnectors.append(itemConnector)

            let layoutChangeCompletion = { [weak self, weak itemConnector] in
                guard self != nil, let itemConnector = itemConnector else {
                    return
                }

                let bendDistance = connectorMargins +
                    (connectorsOffset * CGFloat(connection.originPosition.xPosition))

                itemConnector.createLine(
                    fromItemView1: originItemView,
                    toItemView2: destinyItemView,
                    withBendDistance: bendDistance,
                    andButtonInfo: (
                        context.datasource.connectionsImage(forGraphView: context.graphView),
                        context.datasource.connectionButtonColor(forGraphView: context.graphView)
                    ),
                    inContainerView: context.containerView
                )

                guard let delegate = context.graphView.graphDelegate else {
                    return
                }

                itemConnector.setEventHandler(forDelegate: delegate, andConnection: connection, atGraphView: context.graphView)
            }

            layoutChangeCompletion()

            destinyItemView.didLayoutSubViewsCompletions.append(layoutChangeCompletion)
            originItemView.didLayoutSubViewsCompletions.append(layoutChangeCompletion)
            originLineView.didLayoutSubViewsCompletions.append(layoutChangeCompletion)
            destinyLineView.didLayoutSubViewsCompletions.append(layoutChangeCompletion)
            (context.containerView as? NotifierView)?.didLayoutSubViewsCompletions.append(layoutChangeCompletion)
        }
    }

    func removeConnectors(fromContainerView containerView: UIView) {
        for connector in currentItemConnectors {
            connector.erase()
        }
        
        currentItemConnectors = []
    }
}
