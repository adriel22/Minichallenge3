//
//  HistoryNodesGrid.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

class HistoryNodesGrid: CustomStringConvertible {

    var graphWidth: Int
    var graphHeight: Int
    unowned var graph: HistoryGraph!

    lazy var grid: [[HistoryNodeProtocol?]] = {
        let gridLine = [HistoryNodeProtocol?](repeating: nil, count: graphWidth)
        let grid = [[HistoryNodeProtocol?]](repeating: gridLine, count: graphHeight)

        return grid
    }()

    var description: String {
        var description = ""

        for line in grid {
            description += "["
            for node in line {
                description += node == nil ? "[ ]" : "[x]"
            }
            description += "]\n"
        }

        return description
    }

    subscript(xIndex: Int, yIndex: Int) -> HistoryNodeProtocol? {
        get {
            return grid[xIndex][yIndex]
        }
        set {
            grid[xIndex][yIndex] = newValue
        }
    }

    init(width: Int, andHeight height: Int) {
        self.graphWidth = width
        self.graphHeight = height
    }

    func addColumToGridBegin() {
        for lineIndex in 0..<graphHeight {
            grid[lineIndex].insert(nil, at: 0)
        }

        for node in graph.nodes {
            node.positionX += 1
        }

        graphWidth += 1
    }

    func addColumToGrid() {
        for lineIndex in 0..<graphHeight {
            grid[lineIndex].append(nil)
        }

        graphWidth += 1
    }

    func addLineToGrid() {

        grid.append([HistoryNodeProtocol?].init(repeating: nil, count: graphWidth))
        graphHeight += 1
    }

    func moveNodeToPosition(node: HistoryNodeProtocol,
                            toPositionX positionX: Int,
                            andPositionY positionY: Int) {

        guard let node = node as? HistoryNode,
            node.parent == nil,
            node.connections.count == 0,
            positionY < graphHeight,
            positionX < graphWidth else {
                return
        }

        grid[node.positionY][node.positionX] = nil

        node.positionX = positionX
        node.positionY = positionY

        grid[positionY][positionX] = node
    }

    func findPositionInLine(atIndex lineIndex: Int) -> Int? {
        for colIndex in 0..<graphWidth where grid[lineIndex][colIndex] == nil {
            return colIndex
        }

        return nil
    }
}
