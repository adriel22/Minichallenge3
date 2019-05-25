//
//  HistoryNodesGrid.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

public class HistoryNodesGrid: CustomStringConvertible {

    public var graphWidth: Int
    public var graphHeight: Int
    public weak var graph: HistoryGraph?

    public weak var delegate: HistoryGridDelegate?

    lazy var grid: [[HistoryNodeProtocol?]] = {
        let gridLine = [HistoryNodeProtocol?](repeating: nil, count: graphWidth)
        let grid = [[HistoryNodeProtocol?]](repeating: gridLine, count: graphHeight)

        return grid
    }()

    public var description: String {
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

    public subscript(yIndex: Int, xIndex: Int) -> HistoryNodeProtocol? {
        get {
            return grid[yIndex][xIndex]
        }
        set {
            grid[yIndex][xIndex] = newValue
        }
    }

    public init(width: Int, andHeight height: Int) {
        self.graphWidth = width
        self.graphHeight = height
    }

    /// add a column to the begin of the grid
    func addColumToGridBegin() {
        guard let graph = self.graph else {
            fatalError("The grid must have a associeted graph")
        }
        
        for lineIndex in 0..<graphHeight {
            grid[lineIndex].insert(nil, at: 0)
        }

        graph.nodes.forEach({ (currentNode) in
            currentNode.positionX += 1
        })

        graphWidth += 1

        delegate?.addedColumToGrid(inPosition: 0)
    }

    /// add a column to the end of the grid
    func addColumToGrid() {
        for lineIndex in 0..<graphHeight {
            grid[lineIndex].append(nil)
        }

        graphWidth += 1
        delegate?.addedColumToGrid(inPosition: graphWidth - 1)
    }

    /// add a line in the vertical end of the grid
    func addLineToGrid() {

        grid.append([HistoryNodeProtocol?].init(repeating: nil, count: graphWidth))
        graphHeight += 1

        delegate?.addedLineToGrid(inPosition: graphHeight - 1)
    }

    /// Move a node to the given position. Only works if it parent is nill, and it has no connections.
    ///
    /// - Parameters:
    ///   - node: the target node
    ///   - positionX: position in horizontal axis
    ///   - positionY: position in the vertical axis
    /// - Throws:
    ///   - HistoryError.wrongNodePosition if target position is not free or is not valid.
    ///   - HistoryError.impossibleMoving if the target node cant move because has connections or a parent node.
    func moveNodeToPosition(node: HistoryNodeProtocol,
                            toPositionX positionX: Int,
                            andPositionY positionY: Int,
                            removeFromOrigin: Bool = true) throws {

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

        if removeFromOrigin {
            grid[node.positionY][node.positionX] = nil
        }

        let oldPosition = (node.positionX, node.positionY)
        let newPosition = (positionX, positionY)

        delegate?.movedNodeToPosition(fromPosition: oldPosition, toPosition: newPosition)

        node.positionX = positionX
        node.positionY = positionY

        grid[positionY][positionX] = node
    }

    /// Move a node to bellow of other.
    ///
    /// - Parameters:
    ///   - bellowNode: the node to be bellow
    ///   - node: the node that is on the top
    /// - Throws:
    ///   - HistoryError.impossibleMoving if the target node cant move because has connections or a parent node.
    func moveNode(
        _ bellowNode: HistoryNodeProtocol,
        toBellowOfNode node: HistoryNodeProtocol,
        removeFromOrigin: Bool = true) throws {
        let destinyNodeNewLinePosition = node.positionY + 1

        if let newColPosition = findPositionInLine(atIndex: destinyNodeNewLinePosition, nearIndex: node.positionX) {
            try moveNodeToPosition(
                node: bellowNode,
                toPositionX: newColPosition,
                andPositionY: destinyNodeNewLinePosition,
                removeFromOrigin: removeFromOrigin
            )
        }
    }

    /// It find the first position in the lineIndex line that is free
    ///
    /// - Parameter lineIndex: the index of the target line
    /// - Returns: the column of the found position
    public func findPositionInLine(atIndex lineIndex: Int, nearIndex: Int) -> Int? {
        return (0..<graphWidth).compactMap { (currentXIndex) -> Int? in
            grid[lineIndex][currentXIndex] == nil ? currentXIndex : nil
        }.sorted { (firstIndex, secondIndex) -> Bool in
            abs(nearIndex - firstIndex) < abs(nearIndex - secondIndex)
        }.first
    }

    /// Checks if the grid has the given position
    ///
    /// - Parameters:
    ///   - yIndex: position y
    ///   - xIndex: position x
    /// - Returns: true if the grid has the position, false if not
    public func hasPosition(yIndex: Int, xIndex: Int) -> Bool {
        let existPosition: Bool = xIndex < graphWidth && yIndex < graphHeight

        return existPosition
    }

    /// Checks is the position is free on the grid
    ///
    /// - Parameters:
    ///   - yIndex: position y
    ///   - xIndex: position x
    /// - Returns: true if the position is free, false if not
    public func positionIsFree(yIndex: Int, xIndex: Int) -> Bool {
        let positionIsFree: Bool = self[yIndex, xIndex] == nil

        return positionIsFree
    }
}
