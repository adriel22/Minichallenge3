//
//  GraphViewConnector.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

typealias Connection = (originPosition: GridPosition, destinyPosition: GridPosition)

class GraphViewConnector {

    weak var graphView: GraphView?

    init(withGraphView graphView: GraphView) {
        self.graphView = graphView
    }

    func build(withDatasource datasource: GraphViewDatasource) {
        guard let graphView = self.graphView else {
            return
        }

        let numberOfColumns = datasource.gridSize(forGraphView: graphView).width

        let connectorMargin: CGFloat = 5
        let connectorOffset = itemConnectorsOffset(
            withNumberOfColumns: numberOfColumns,
            connectorMargins: connectorMargin,
            datasource: datasource,
            andGraphView: graphView
        )

        addConnectionsToGraph(
            graphView,
            connections: connectionViews(
                fromConnections: findConnections(
                    inLineViews: graphView.lineViews,
                    withDatasource: datasource,
                    andGraphView: graphView
                ),
                withConnectorMargins: connectorMargin,
                connectorsOffset: connectorOffset,
                andGraphView: graphView
            )
        )
    }

    func addConnectionsToGraph(_ graphView: GraphView, connections: [GraphConnectionView]) {
        connections.forEach { (currentConnection) in
            graphView.insertSubview(currentConnection, at: 0)
        }
    }

    func findConnections(
        inLineViews lineViews: [GraphLineView],
        withDatasource datasource: GraphViewDatasource,
        andGraphView graphView: GraphView) -> [Connection] {

        let gridSize = datasource.gridSize(forGraphView: graphView)
        var connections: [Connection] = []

        (0..<gridSize.height).forEach { (currentLineIndex) in
            (0..<gridSize.width).forEach({ (currentColumnIndex) in
                let currentItemPosition = (xPosition: currentColumnIndex, yPosition: currentLineIndex)

                let connectionsFromCurrentPosition = datasource
                    .connections(forGraphView: graphView, fromItemAtPosition: currentItemPosition)
                    .map({ (currentDestinyPosition) -> Connection in

                        return (originPosition: currentItemPosition, destinyPosition: currentDestinyPosition)
                    })
                connections.append(contentsOf: connectionsFromCurrentPosition)
            })
        }

        return connections
    }

    func itemConnectorsOffset(
        withNumberOfColumns numberOfColumns: Int,
        connectorMargins: CGFloat,
        datasource: GraphViewDatasource,
        andGraphView graphView: GraphView) -> CGFloat {

        let connectorsArea = datasource.lineSpacing(forGraphView: graphView) - (connectorMargins * 2)

        let offset = connectorsArea / CGFloat(numberOfColumns)

        return offset
    }

    func connectionViews(
        fromConnections connections: [Connection],
        withConnectorMargins connectorMargins: CGFloat,
        connectorsOffset: CGFloat,
        andGraphView graphView: GraphView) -> [GraphConnectionView] {

        return connections.compactMap { (connection) -> GraphConnectionView? in
            guard let destinyItemView = graphView.itemView(forPosition: connection.destinyPosition),
                  let originItemView = graphView.itemView(forPosition: connection.originPosition) else {
                return nil
            }

            let originPoint = originItemView.center

            let bendPointX = originPoint.x
            let bendPointY = connectorMargins + (connectorsOffset * CGFloat(connection.originPosition.xPosition))
            let bendPoint = CGPoint(x: bendPointX, y: bendPointY)

            let destinyPoint = destinyItemView.center

            return GraphConnectionView(
                withOriginPoint: originPoint,
                bendPoint: bendPoint,
                andDestinyPoint: destinyPoint
            )
        }
    }
}
