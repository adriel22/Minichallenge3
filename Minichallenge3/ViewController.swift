//
//  ViewController.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 06/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
import HistoryGraph

class ViewController: UIViewController {

    @IBOutlet weak var graphView: GraphView!

    var graph: HistoryGraph = {
        let graph = HistoryGraph.init(withName: "HistoryName", sinopse: "HistorySinopse", width: 3, andHeight: 3)

        let rootNode = HistoryNode.init(withResume: "RootNode", text: "RootNode text", positionX: 2, andPositionY: 0)

        let node2 = HistoryNode.init(withResume: "Node 2", text: "Node2 Text", positionX: 1, andPositionY: 1)
        let node3 = HistoryNode.init(withResume: "Node 2", text: "Node2 Text", positionX: 2, andPositionY: 1)
        let node4 = HistoryNode.init(withResume: "Node 2", text: "Node2 Text", positionX: 1, andPositionY: 2)
        let node5 = HistoryNode.init(withResume: "Node 2", text: "Node2 Text", positionX: 2, andPositionY: 2)

        try? graph.addNode(rootNode)
        try? graph.addNode(node2)
        try? graph.addNode(node3)
        try? graph.addNode(node4)
        try? graph.addNode(node5)

        try? graph.addConnection(fromNode: rootNode, toNode: node2, withTitle: "action1")
        try? graph.addConnection(fromNode: rootNode, toNode: node3, withTitle: "action1")
        try? graph.addConnection(fromNode: node2, toNode: node4, withTitle: "action1")
        try? graph.addConnection(fromNode: node3, toNode: node5, withTitle: "action2")

        print(graph.grid)

        return graph
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        graphView.datasource = self

        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            self.graphView.addLine(inPosition: 0)
//            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
//                self.graphView.addLine(inPosition: 1)
//            })
        }
    }
}

extension ViewController: GraphViewDatasource {
    func connections(forGraphView graphView: GraphView, fromItemAtPosition itemPosition: GridPosition) -> [GridPosition] {
        guard let node = graph.grid[itemPosition.yPosition, itemPosition.xPosition] as? HistoryNode else {
            return []
        }

        return node.connections.compactMap({ (historyConnection) -> GridPosition? in
            guard let destinyNode = historyConnection.destinyNode else {
                return nil
            }

            return (xPosition: destinyNode.positionX, yPosition: destinyNode.positionY)
        })
    }

    func gridSize(forGraphView graphView: GraphView) -> GridSize {
        let gridSize = graph.grid

        return (width: gridSize.graphWidth, height: gridSize.graphHeight)
    }

    func gridNodeView(forGraphView graphView: GraphView, inPosition position: GridPosition) -> GraphItemView? {

        guard let _ = graph.grid[position.yPosition, position.xPosition] else {
            let graphView = GraphItemView.init()
            graphView.backgroundColor = UIColor.blue
            graphView.layer.opacity = 0.1
            return graphView
        }

        let view = GraphItemView.init()
        view.backgroundColor = UIColor.red
        view.translatesAutoresizingMaskIntoConstraints = false

        view.heightAnchor.constraint(equalToConstant: CGFloat.random(in: 100..<200)).isActive = true

        return view
    }

    func columnWidth(forGraphView graphView: GraphView, inXPosition xPosition: Int) -> CGFloat {
        return 200
    }

    func lineSpacing(forGraphView graphView: GraphView) -> CGFloat {
        return 50.0
    }

    func columnSpacing(forGraphView graphView: GraphView) -> CGFloat {
        return 10.0
    }

    func leftSpacing(forGraphView graphView: GraphView) -> CGFloat {
        return 100
    }
}
