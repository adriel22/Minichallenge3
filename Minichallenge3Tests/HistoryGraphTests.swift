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
            positionX: 0,
            andPositionY: 0
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
            positionX: 0,
            andPositionY: 0
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
            positionX: 0,
            andPositionY: 0
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
            positionX: 0,
            andPositionY: 0
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
            positionX: 1,
            andPositionY: 0
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
            positionX: 1,
            andPositionY: 2
        )

        grid[2, 1] = rootNode
        graph.nodes.append(rootNode)
        graph.addBordersToNode(rootNode, grid: grid)

        XCTAssertTrue(grid.graphHeight == 4)
        XCTAssertTrue(grid[2, 1] === rootNode)
        XCTAssertTrue(rootNode.positionY == 2)
    }
//    
//    func test_removeNode_sucess() {
//        let rootNode = HistoryNode.init(
//            withResume: "Root Node Resume",
//            text: "Root Node Text",
//            positionX: 0,
//            andPositionY: 0
//        )
//        
//        graph.addNode(rootNode)
//        
//        graph.removeNode(rootNode)
//        
//        
//    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
