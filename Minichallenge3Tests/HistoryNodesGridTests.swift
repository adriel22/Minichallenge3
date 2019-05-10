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
}
