//
//  HistoryNodesGridTests.swift
//  Minichallenge3Tests
//
//  Created by Elias Paulino on 10/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import XCTest
@testable import HistoryGraph

class HistoryNodesGridTests: XCTestCase {

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

    func test_moveNodeToPosition_sucess() {
        // [ ][r][ ]    |   [ ][n2][r][ ]   |   [ ][ ][r][ ]
        // [ ][ ][ ]    |   [ ][ ][ ][ ]    |   [ ][ ][n2][ ]
        //              |                   |   [ ][ ][ ][ ]

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

        XCTAssertNoThrow(
            try graph.grid.moveNodeToPosition(node: node2, toPositionX: 2, andPositionY: 1)
        )
    }

    func test_moveNodeToPosition_invalidPositionUsedPosition() {
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

        do {
            try graph.grid.moveNodeToPosition(node: node2, toPositionX: 1, andPositionY: 0)
            XCTAssert(false)
        } catch HistoryError.wrongNodePosition {
            XCTAssert(true)
        } catch {
            XCTAssert(false)
        }
    }

    func test_moveNodeToPosition_invalidPositionWrongPosition() {
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

        do {
            try graph.grid.moveNodeToPosition(node: node2, toPositionX: 3, andPositionY: 3)
            XCTAssert(false)
        } catch HistoryError.wrongNodePosition {
            XCTAssert(true)
        } catch {
            XCTAssert(false)
        }
    }

    func test_moveNodeToPosition_impossibleMoveHasParent() {
        // [ ][r][ ]    |   [ ][n2][r][ ]   |   [ ][ ][r][ ]
        // [ ][ ][ ]    |   [ ][ ][ ][ ]    |   [ ][ ][n2][ ]
        //              |                   |   [ ][ ][ ][ ]

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
        try? graph.addConnection(fromNode: rootNode, toNode: node2, withTitle: "action")

        do {
            try graph.grid.moveNodeToPosition(node: node2, toPositionX: 3, andPositionY: 2)
            XCTAssert(false)
        } catch HistoryError.impossibleMoving {
            XCTAssert(true)
        } catch {
            XCTAssert(false)
        }
    }

    func test_moveNodeToPosition_impossibleMoveHasConnections() {
        // [ ][r][ ]    |   [ ][n2][r][ ]   |   [ ][ ][r][ ]
        // [ ][ ][ ]    |   [ ][ ][ ][ ]    |   [ ][ ][n2][ ]
        //              |                   |   [ ][ ][ ][ ]

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
        try? graph.addConnection(fromNode: rootNode, toNode: node2, withTitle: "action")

        do {
            try graph.grid.moveNodeToPosition(node: rootNode, toPositionX: 3, andPositionY: 2)
            XCTAssert(false)
        } catch HistoryError.impossibleMoving {
            XCTAssert(true)
        } catch {
            XCTAssert(false)
        }
    }
}
