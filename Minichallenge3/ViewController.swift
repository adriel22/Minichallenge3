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

    var rootNode = HistoryNode.init(withResume: "RootNode", text: "RootNode text", positionX: 2, andPositionY: 0)
    
    lazy var graph: HistoryGraph = {
        let graph = HistoryGraph.init(withName: "HistoryName", sinopse: "HistorySinopse", width: 3, andHeight: 3)

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
        
        graph.grid.delegate = self

        return graph
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        graphView.datasource = self

        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
            let node6 = HistoryNode.init(withResume: "Node 2", text: "Node2 Text", positionX: 0, andPositionY: 1)
            try? self.graph.addNode(node6)
            print(self.graph.grid)
//            self.graphView.addItem(atPositon: (xPosition: 0, yPosition: 1))
//            self.graphView.addColumn(inPosition: 0)
//            self.graphView.addItem(atPositon: (xPosition: 1, yPosition: 1))
//            self.graphView.appendLine()
//            self.graphView.addItem(atPositon: (xPosition: 1, yPosition: 3))
//            print(self.graph.grid)
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (_) in
//                let node7 = HistoryNode.init(withResume: "Node 2", text: "Node2 Text", positionX: 1, andPositionY: 3)
//                try? self.graph.addNode(node7)
//
//                let node8 = HistoryNode.init(withResume: "Node 2", text: "Node2 Text", positionX: 1, andPositionY: 2)
//                try? self.graph.addNode(node8)
//
//                print(self.graph.grid)
//                self.graphView.appendLine()
//                self.graphView.addItem(atPositon: (xPosition: node7.positionX, yPosition: node7.positionY))
//                self.graphView.addItem(atPositon: (xPosition: node8.positionX, yPosition: node8.positionY))
//
//                self.graphView.reloadConnections()
                
//                self.graphView.removeItem(atPositon: (xPosition: 1, yPosition: 3))
//                self.graphView.addColumn(inPosition: 0)
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
//                    try? self.graph.addConnection(fromNode: node8, toNode: node7, withTitle: "bla")
//                    try? self.graph.addConnection(fromNode: node6, toNode: node8, withTitle: "bla")
//
//                    try? self.graph.addConnection(fromNode: self.rootNode, toNode: node6, withTitle: "bla")

//                    self.graphView.reloadData()

//                    self.graphView.addLine(inPosition: 3)
//                    self.graphView.removeColumn(atPosition: 4)
                })
//                self.graphView.addLine(inPosition: 3)
//                self.graphView.addLine(inPosition: 3)
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
//                    self.graphView.addColumn(inPosition: 3)
//                    self.graphView.addLine(inPosition: 2)
//                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
//                        self.graphView.addLine(inPosition: 3)
//                    })
                })
            })
        }
    }
}

extension ViewController: HistoryGridDelegate {
    func removedShortcut(atPosition position: Position) {
        
    }
    
    func addedColumToGrid(inPosition position: Int) {
        if position == self.graph.grid.graphWidth - 1 {
            self.graphView.appendColumn()
        } else {
            self.graphView.addColumn(inPosition: position)
        }
    }
    
    func addedLineToGrid(inPosition position: Int) {
        if position == self.graph.grid.graphHeight - 1 {
            self.graphView.appendLine()
        } else {
            self.graphView.addLine(inPosition: position)
        }
    }
    
    func movedNodeToPosition(fromPosition originPosition: Position, toPosition destinyPosition: Position) {
        self.graphView.removeItem(atPositon: (xPosition: originPosition.x, yPosition: originPosition.y))
        self.graphView.addItem(atPositon: (xPosition: destinyPosition.x, yPosition: destinyPosition.y))
    }
    
    func addNode(inPosition position: Position) {
        self.graphView.addItem(atPositon: (xPosition: position.x, yPosition: position.y))
    }
    
    func addShortcut(inPosition position: Position) {
        self.graphView.addItem(atPositon: (xPosition: position.x, yPosition: position.y))
    }
}

extension ViewController: GraphViewDatasource {
    
    func parents(forGraphView graphView: GraphView, fromItemAtPosition itemPosition: GridPosition) -> [GridPosition] {
        return []
    }
    
    func connectionButtonColor(forGraphView graphView: GraphView) -> UIColor? {
        return nil
    }
    
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
//            let graphView = GraphItemView.init()
//            graphView.backgroundColor = UIColor.blue
//            graphView.layer.opacity = 0.1
//            return graphView
            return nil
        }

//        let view = GraphItemView.init()
//        view.backgroundColor = UIColor.red
//        let view = CardView.init()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.setCardText("Certo dia, Jurema descobriu uma fofoca super intrigante. Porém, contudo, todavia, entretanto, ela está receosa em contá-la para sua mais que amiga, sua friend, Marivalda. E aí você contaria?")
        
        let view = ShortcutView.init()
        view.translatesAutoresizingMaskIntoConstraints = false

//        if position.xPosition == 1 && position.yPosition == 3 {
//            view.backgroundColor = UIColor.green
//        }

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
    
    func connectionsImage(forGraphView graphView: GraphView) -> UIImage? {
        return nil
    }
    
    func connectionWidth(forGraphView graphView: GraphView) -> CGFloat {
        return 4
    }
}
