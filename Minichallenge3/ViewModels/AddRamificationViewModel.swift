//
//  AddRamificationViewModel.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 16/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import HistoryGraph
class AddRamificationViewModel {
    let graph: HistoryGraph
    let parentNode: HistoryNode

    init(inGraph graph: HistoryGraph, withParent parentNode: HistoryNode) {
        self.graph = graph
        self.parentNode = parentNode
    }

    func addNode(_ nodeTitle: String) {
        let nodePositionY = parentNode.positionY + 1

        let nodePositionX = graph.grid.findPositionInLine(atIndex: nodePositionY) ?? 0

        let newNode = HistoryNode(withResume: nodeTitle, text: "", positionX: nodePositionX, andPositionY: parentNode.positionY + 1)

        try? graph.addNode(newNode)

        try? graph.addConnection(fromNode: parentNode, toNode: newNode, withTitle: "")
    }
}
