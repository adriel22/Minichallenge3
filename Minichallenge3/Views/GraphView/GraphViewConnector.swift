//
//  GraphViewConnector.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

typealias Connection = (originItemView: GraphItemViewProtocol, destinyPosition: GridPosition)

class GraphViewConnector {

    weak var graphView: GraphView?

    init(withGraphView graphView: GraphView) {
        self.graphView = graphView
    }

    func build(withDatasource datasource: GraphViewDatasource) {

    }

    func findConnections(
        inLineViews lineViews: [GraphLineView],
        withDatasource datasource: GraphViewDatasource,
        andGraphView graphView: GraphView) -> [Connection] {

        var connections: [Connection] = []

        lineViews.forEach { (_, currentLineView, currentLineViewIndex) in
            currentLineView.itemViews.forEach(completion: { (_, currentItemView, currentItemViewIndex) in

                let currentItemPosition = (xPosition: currentItemViewIndex, yPosition: currentLineViewIndex)
                let connectionsFromCurrentPosition = datasource
                    .connections(forGraphView: graphView, fromItemAtPosition: currentItemPosition)
                    .map({ (gridPosition) -> Connection in

                        return (originItemView: currentItemView, destinyPosition: gridPosition)
                })
                connections.append(contentsOf: connectionsFromCurrentPosition)
            })
        }

        return connections
    }

//    func connectionViews(fromConnections connections: [Connection], withGraphView graphView: GraphView) -> [GraphConnectionView] {
//
//        connections.compactMap { (connection) -> GraphConnectionView? in
//            guard let endPoint = graphView.itemView(forPosition: connection.destinyPosition) else {
//                return nil
//            }
//
//            let originPoint = connection.originItemView.center
//
//        }
//    }
}
