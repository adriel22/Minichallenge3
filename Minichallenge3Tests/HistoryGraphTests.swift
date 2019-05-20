//
//  HistoryGraphTests.swift
//  Minichallenge3Tests
//
//  Created by Elias Paulino on 09/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import XCTest
@testable import HistoryGraph

class HistoryGraphTests: XCTestCase {

    let graph = HistoryGraph.init(
        withName: "Histony Name",
        sinopse: "History Sinopse",
        width: 2, andHeight: 2
    )

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()

        let gridWidth = graph.grid.graphWidth
        let gridHeight = graph.grid.graphHeight
        graph.grid = HistoryNodesGrid.init(width: gridWidth, andHeight: gridHeight)

        graph.nodes = []
    }

    func test_addNode_sucess() {
        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 0, andPositionY: 0
        )

        try? graph.addNode(rootNode)

        XCTAssertTrue(graph.nodes.count == 1)
        XCTAssertNotNil(graph.grid[rootNode.positionY, rootNode.positionX])
    }

    func test_addNode_wrongPosition() {
        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 0,
            andPositionY: 0
        )

        let node2 = HistoryNode.init(
            withResume: "Node 2",
            text: "Node 2 Text",
            positionX: 0, andPositionY: 0
        )

        try? graph.addNode(rootNode)

        node2.positionX = rootNode.positionX
        node2.positionY = rootNode.positionY

        do {
            try graph.addNode(node2)
            assert(false, "two nodes are in the same position")
        } catch HistoryError.wrongNodePosition {
            XCTAssertTrue(true)
        } catch {
            assert(false, "wrong error throwed")
        }
    }

    func test_addNode_duplicatedNode() {
        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 0, andPositionY: 0
        )

        try? graph.addNode(rootNode)

        rootNode.positionX = 0
        rootNode.positionY = 0

        do {
            try graph.addNode(rootNode)
            assert(false, "the node was duplicated")
        } catch HistoryError.duplicatedNode {
            XCTAssertTrue(true)
        } catch {
            assert(false, "wrong error throwed")
        }
    }

    func test_addBorders_columnToBegin() {
        let grid = HistoryNodesGrid.init(width: 2, andHeight: 2)
        grid.graph = self.graph

        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 0, andPositionY: 0
        )

        grid[0, 0] = rootNode
        graph.nodes.append(rootNode)
        graph.addBordersToNode(rootNode, grid: grid)

        XCTAssertTrue(grid.graphWidth == 3)
        XCTAssertTrue(grid[0, 1] === rootNode)
        XCTAssertTrue(rootNode.positionX == 1)
    }

    func test_addBorders_columnToEnd() {
        let grid = HistoryNodesGrid.init(width: 2, andHeight: 2)
        grid.graph = self.graph

        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 1, andPositionY: 0
        )

        grid[0, 1] = rootNode
        graph.nodes.append(rootNode)
        graph.addBordersToNode(rootNode, grid: grid)

        XCTAssertTrue(grid.graphWidth == 3)
        XCTAssertTrue(grid[0, 1] === rootNode)
        XCTAssertTrue(rootNode.positionX == 1)
    }

    func test_addBorders_lineToEnd() {
        let grid = HistoryNodesGrid.init(width: 3, andHeight: 3)
        grid.graph = self.graph

        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 1, andPositionY: 2
        )

        grid[2, 1] = rootNode
        graph.nodes.append(rootNode)
        graph.addBordersToNode(rootNode, grid: grid)

        XCTAssertTrue(grid.graphHeight == 4)
        XCTAssertTrue(grid[2, 1] === rootNode)
        XCTAssertTrue(rootNode.positionY == 2)
    }

    func test_removeNode_sucess() {
        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 0,
            andPositionY: 0
        )

        try? graph.addNode(rootNode)
        try? graph.removeNode(rootNode)

        XCTAssertTrue(graph.nodes.count == 0)
        XCTAssertTrue(graph.grid[rootNode.positionY, rootNode.positionX] == nil)
    }

    func test_removeNode_withParent() {
        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 0, andPositionY: 0
        )

        let node2 = HistoryNode.init(
            withResume: "Node 2 Resume",
            text: "Node 2 Text",
            positionX: 0, andPositionY: 0
        )

        try? graph.addNode(rootNode)
        try? graph.addNode(node2)
        try? graph.addPath(fromNode: rootNode, toNode: node2, withTitle: "action title")
        try? graph.removeNode(node2)

        XCTAssertTrue(graph.nodes.count == 1)
        XCTAssertTrue(graph.grid[node2.positionY, node2.positionX] == nil)
        XCTAssertTrue(!graph.containsNode(node2))
    }

    func test_removeNode_withConnections() {
        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 0, andPositionY: 0
        )

        let node2 = HistoryNode.init(
            withResume: "Node 2 Resume",
            text: "Node 2 Text",
            positionX: 0, andPositionY: 0
        )

        try? graph.addNode(rootNode)
        try? graph.addNode(node2)
        try? graph.addPath(fromNode: rootNode, toNode: node2, withTitle: "action title")
        try? graph.removeNode(rootNode)

        XCTAssertTrue(graph.nodes.count == 1)
        XCTAssertTrue(graph.grid[rootNode.positionY, rootNode.positionX] == nil)
        XCTAssertTrue(node2.parent == nil)
        XCTAssertTrue(!graph.containsNode(rootNode))
    }

    func test_checkConnection_sucess() {
        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 0, andPositionY: 0
        )

        let node2 = HistoryNode.init(
            withResume: "Node 2 Resume",
            text: "Node 2 Text",
            positionX: 0, andPositionY: 0
        )

        let node3 = HistoryNode.init(
            withResume: "Node 3 Resume",
            text: "Node 3 Text",
            positionX: 0, andPositionY: 0
        )

        try? graph.addNode(rootNode)
        try? graph.addNode(node3)
        try? graph.addNode(node2)
        try? graph.addPath(fromNode: rootNode, toNode: node2, withTitle: "action title")
        try? graph.addPath(fromNode: rootNode, toNode: node3, withTitle: "action title")

        XCTAssertTrue(graph.checkConnection(fromNode1: rootNode, toNode2: node2))
        XCTAssertTrue(graph.checkConnection(fromNode1: rootNode, toNode2: node3))
    }

    func test_checkConnection_fail() {
        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 0, andPositionY: 0
        )

        let node2 = HistoryNode.init(
            withResume: "Node 2 Resume",
            text: "Node 2 Text",
            positionX: 0, andPositionY: 0
        )

        try? graph.addNode(rootNode)
        try? graph.addNode(node2)

        XCTAssertTrue(!graph.checkConnection(fromNode1: rootNode, toNode2: node2))
    }

    func test_checkConnectionBetween_sucess() {
        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 0,
            andPositionY: 0
        )

        let node2 = HistoryNode.init(
            withResume: "Node 2 Resume",
            text: "Node 2 Text",
            positionX: 0,
            andPositionY: 0
        )

        try? graph.addNode(rootNode)
        try? graph.addNode(node2)
        try? graph.addPath(fromNode: rootNode, toNode: node2, withTitle: "action title")

        XCTAssertTrue(graph.checkConnectionBetween(node1: rootNode, andNode2: node2))
        XCTAssertTrue(graph.checkConnectionBetween(node1: node2, andNode2: rootNode))
    }

    func test_addConnection_hasConnectionAndIsBellow() {
        // [ ][r][ ]    |   [ ][r][ ]       |   [ ][r][ ]
        // [ ][ ][ ]    |   [ ][n2][ ]      |   [ ][n2][ ]
        //              |   [ ][ ][ ]       |   [ ][n2c][ ]
        //                                  |   [ ][ ][ ]

        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 0, andPositionY: 0
        )

        let node2 = HistoryNode.init(
            withResume: "Node 2 Resume",
            text: "Node 2 Text",
            positionX: 1, andPositionY: 1
        )

        let node2Child = HistoryNode.init(
            withResume: "Node 2 Child Resume",
            text: "Node 2 Child Text",
            positionX: 1, andPositionY: 2
        )

        try? graph.addNode(rootNode)
        try? graph.addNode(node2)
        try? graph.addNode(node2Child)

        try? graph.addPath(fromNode: node2, toNode: node2Child, withTitle: "action")

        XCTAssertNoThrow(try graph.addPath(fromNode: rootNode, toNode: node2, withTitle: "action"))
        XCTAssert(rootNode.positionX == 1 && rootNode.positionY == 0)
        XCTAssert(node2.positionX == 1 && node2.positionY == 1)
        XCTAssert(node2Child.positionX == 1 && node2Child.positionY == 2)
    }

    func test_addPathAndAddConnection_IsBellow() {
        // [ ][r][ ]    |   [ ][r][ ]
        // [ ][ ][ ]    |   [ ][n2][ ]
        //              |   [ ][ ][ ]

        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 0, andPositionY: 0
        )

        let node2 = HistoryNode.init(
            withResume: "Node 2 Resume",
            text: "Node 2 Text",
            positionX: 1, andPositionY: 1
        )

        try? graph.addNode(rootNode)
        try? graph.addNode(node2)

        XCTAssertNoThrow(try graph.addPath(fromNode: rootNode, toNode: node2, withTitle: "action"))
        XCTAssert(rootNode.positionX == 1 && rootNode.positionY == 0)
        XCTAssert(node2.positionX == 1 && node2.positionY == 1)
    }

    func test_addPathAndAddConnection_needMoveChild() {
        // [ ][r][ ]    |   [ ][n2][r][ ]   |   [ ][ ][r][ ]
        // [ ][ ][ ]    |   [ ][ ][ ][ ]    |   [ ][ ][n2][ ]

        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 1, andPositionY: 0
        )

        let node2 = HistoryNode.init(
            withResume: "Node 2 Resume",
            text: "Node 2 Text",
            positionX: 0, andPositionY: 0
        )

        try? graph.addNode(rootNode)
        try? graph.addNode(node2)

        XCTAssertNoThrow(try graph.addPath(fromNode: rootNode, toNode: node2, withTitle: "action"))
        
        XCTAssert(rootNode.positionX == 2 && rootNode.positionY == 0)
        XCTAssert(node2.positionX == 2 && node2.positionY == 1)
    }

    func test_addPathAndAddConnection_duplicatedConnection() {
        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 0, andPositionY: 0
        )

        let node2 = HistoryNode.init(
            withResume: "Node 2 Resume",
            text: "Node 2 Text",
            positionX: 1, andPositionY: 1
        )

        try? graph.addNode(rootNode)
        try? graph.addNode(node2)
        try? graph.addPath(fromNode: rootNode, toNode: node2, withTitle: "action")

        XCTAssertThrowsError(
            try graph.addPath(fromNode: rootNode, toNode: node2, withTitle: "action")
        )
    }

    func test_removeConnection_sucess() {
        let rootNode = HistoryNode.init(
            withResume: "Root Node Resume",
            text: "Root Node Text",
            positionX: 0, andPositionY: 0
        )

        let node2 = HistoryNode.init(
            withResume: "Node 2 Resume",
            text: "Node 2 Text",
            positionX: 0, andPositionY: 0
        )

        try? graph.addNode(rootNode)
        try? graph.addNode(node2)
        try? graph.addPath(fromNode: rootNode, toNode: node2, withTitle: "action")

        if let connection = rootNode.connections.first {
            try? graph.removeConnection(connection, fromNode: rootNode)
        }
        XCTAssert(rootNode.connections.count == 0)
    }

    func test_addShortcut_sucess() {
        let node1 = HistoryNode.init(withResume: "node1", text: "node1 text", positionX: 0, andPositionY: 0)
        let node2 = HistoryNode.init(withResume: "node2", text: "node2 text", positionX: 0, andPositionY: 1)

        try? graph.addNode(node1)
        try? graph.addNode(node2)
        try? graph.addPath(fromNode: node1, toNode: node2, withTitle: "The first connection")
        XCTAssertNoThrow(
        try graph.addShortcut(fromNode: node2, toNode: node1, withTitle: "Back to begin")
        )
    }

    func test_addPath_wrongNodePositionAndAddShortcut() {
        let node1 = HistoryNode.init(withResume: "node1", text: "node1 text", positionX: 0, andPositionY: 0)
        let node2 = HistoryNode.init(withResume: "node2", text: "node2 text", positionX: 0, andPositionY: 1)
        let node3 = HistoryNode.init(withResume: "node3", text: "node3 text", positionX: 2, andPositionY: 1)

        try? graph.addNode(node1)
        try? graph.addNode(node2)
        try? graph.addNode(node3)
        try? graph.addPath(fromNode: node1, toNode: node2, withTitle: "The first connection")
        try? graph.addPath(fromNode: node3, toNode: node2, withTitle: "the connection")
        XCTAssertTrue(node3.shortcuts.count > 0)
    }

    func test_addPath_wrongNodePositionAndImpossibleCreatPathToShortcut() {
        // [ ][r][ ]    |   [ ][  ][r][ ]   |   [ ][ ][r][ ]
        // [ ][ ][ ]    |   [ ][n2][ ][ ]   |   [ ][n2][n3][ ]
        //                  [ ][  ][ ][ ]   |   [ ][  ][ ][ ]
        let node1 = HistoryNode.init(withResume: "node1", text: "node1 text", positionX: 0, andPositionY: 0)
        let node2 = HistoryNode.init(withResume: "node2", text: "node2 text", positionX: 0, andPositionY: 1)
        let node3 = HistoryNode.init(withResume: "node3", text: "node3 text", positionX: 2, andPositionY: 1)

        try? graph.addNode(node1)
        try? graph.addNode(node2)
        try? graph.addNode(node3)
        try? graph.addPath(fromNode: node1, toNode: node2, withTitle: "The first connection")
        try? graph.addPath(fromNode: node3, toNode: node2, withTitle: "connection")
        let shortcut = node3.shortcuts.first!
        XCTAssertThrowsError(try graph.addPath(fromNode: node1, toNode: shortcut, withTitle: "the connection"))
    }
}
