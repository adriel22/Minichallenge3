//
//  HistoryConnectionTests.swift
//  Minichallenge3Tests
//
//  Created by Elias Paulino on 10/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import XCTest
@testable import HistoryGraph

class HistoryConnectionTests: XCTestCase {

    func test_connectionCompare_lessThen() {
        let node = HistoryNode.init(withResume: "Node Resume", text: "Node Text", positionX: 0, andPositionY: 0)
        let connection1 = HistoryConnection.init(destinyNode: node, title: "action1")

        let connection2 = HistoryConnection.init(destinyNode: node, title: "action2")

        XCTAssert(connection1 < connection2)
    }

    func test_connectionCompare_equal() {
        let node = HistoryNode.init(withResume: "Node Resume", text: "Node Text", positionX: 0, andPositionY: 0)
        let connection1 = HistoryConnection.init(destinyNode: node, title: "action1")

        let connection2 = HistoryConnection.init(destinyNode: node, title: "action1")

        XCTAssert(connection1 == connection2)
    }

    func test_connectionCompare_notEqualByName() {
        let node = HistoryNode.init(withResume: "Node Resume", text: "Node Text", positionX: 0, andPositionY: 0)

        let connection1 = HistoryConnection.init(destinyNode: node, title: "action1")

        let connection2 = HistoryConnection.init(destinyNode: node, title: "action2")

        XCTAssert(connection1 != connection2)
    }

    func test_connectionCompare_notEqualByNode() {
        let node = HistoryNode.init(withResume: "Node Resume", text: "Node Text", positionX: 0, andPositionY: 0)

        let node2 = HistoryNode.init(withResume: "Node 2 Resume", text: "Node 2 Text", positionX: 0, andPositionY: 0)

        let connection1 = HistoryConnection.init(destinyNode: node, title: "action1")

        let connection2 = HistoryConnection.init(destinyNode: node2, title: "action1")

        XCTAssert(connection1 != connection2)
    }
}
