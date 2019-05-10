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
    weak var graph: HistoryGraph?

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

    subscript(yIndex: Int, xIndex: Int) -> HistoryNodeProtocol? {
        get {
            return grid[yIndex][xIndex]
        }
        set {
            grid[yIndex][xIndex] = newValue
        }
    }

    init(width: Int, andHeight height: Int) {
        self.graphWidth = width
        self.graphHeight = height
    }

    /// add a column to the begin of the grid
    func addColumToGridBegin() {
        for lineIndex in 0..<graphHeight {
            grid[lineIndex].insert(nil, at: 0)
        }

        graph?.nodes.forEach({ (currentNode) in
            currentNode.positionX += 1
        })

        graphWidth += 1
    }

    /// add a column to the end of the grid
    func addColumToGrid() {
        for lineIndex in 0..<graphHeight {
            grid[lineIndex].append(nil)
        }

        graphWidth += 1
    }

    /// add a line in the vertical end of the grid
    func addLineToGrid() {

        grid.append([HistoryNodeProtocol?].init(repeating: nil, count: graphWidth))
        graphHeight += 1
    }

    /// Move a node to the given position. Only works if it parent is nill, and it has no connections.
    ///
    /// - Parameters:
    ///   - node: the target node
    ///   - positionX: position in horizontal axis
    ///   - positionY: position in the vertical axis
    func moveNodeToPosition(node: HistoryNodeProtocol,
                            toPositionX positionX: Int,
                            andPositionY positionY: Int) throws {

        let validPosition: Bool = hasPosition(yIndex: positionY, xIndex: positionX)

        guard validPosition else {
            throw HistoryError.wrongNodePosition
        }

        let positionFree: Bool = positionIsFree(yIndex: positionY, xIndex: positionX)
        let hasNoParent: Bool = node.parent == nil
        let hasNoConnections: Bool

        if let historyNode = node as? HistoryNode, historyNode.connections.count == 0 {
            hasNoConnections = true
        } else if node is HistoryShortcut {
            hasNoConnections = true
        } else {
            hasNoConnections = false
        }

        guard positionFree else {
            throw HistoryError.wrongNodePosition
        }

        guard hasNoParent, hasNoConnections else {
            throw HistoryError.impossibleMoving
        }

        grid[node.positionY][node.positionX] = nil

        node.positionX = positionX
        node.positionY = positionY

        grid[positionY][positionX] = node
    }

    func moveNode(_ bellowNode: HistoryNodeProtocol, toBellowOfNode node: HistoryNodeProtocol) throws {
        let destinyNodeNewLinePosition = node.positionY + 1

        if let newColPosition = findPositionInLine(atIndex: destinyNodeNewLinePosition) {
            try moveNodeToPosition(
                node: bellowNode,
                toPositionX: newColPosition,
                andPositionY: destinyNodeNewLinePosition
            )
        }
    }

    func findPositionInLine(atIndex lineIndex: Int) -> Int? {
        for colIndex in 0..<graphWidth where grid[lineIndex][colIndex] == nil {
            return colIndex
        }

        return nil
    }

    func hasPosition(yIndex: Int, xIndex: Int) -> Bool {
        let existPosition: Bool = xIndex < graphWidth && yIndex < graphHeight

        return existPosition
    }

    func positionIsFree(yIndex: Int, xIndex: Int) -> Bool {
        let positionIsFree: Bool = self[yIndex, xIndex] == nil

        return positionIsFree
    }
}
