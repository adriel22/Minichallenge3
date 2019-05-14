//
//  HistoryGraph.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

public class HistoryGraph: CustomStringConvertible {

    var nodes: [HistoryNodeProtocol] = []
    var historyName: String
    var sinopse: String

    var grid: HistoryNodesGrid

    public var description: String {
        var description = ""

        for node in nodes {
            description += node.description + "\n"
        }

        return description
    }

    public init(withName name: String, sinopse: String, width: Int, andHeight height: Int) {
        self.historyName = name
        self.sinopse = sinopse
        self.grid = HistoryNodesGrid(width: width, andHeight: height)
        self.grid.graph = self
    }

    /// Adds a connection between two nodes
    ///
    /// - Parameters:
    ///   - originNode: the origin node
    ///   - destinyNode: the destiny node
    public func addConnection(fromNode originNode: HistoryNode,
                              toNode destinyNode: HistoryNode,
                              withTitle title: String) throws {
        /*
         if there is a connection origin-destiny, it stops
         
         if the destiny has a parent, it create a shortcut

         if there is a connection "backing", it create a shortcut
         
         if the destiny has no parent neither connections, move the destiny node to origins bellow and connect them.
         
         if the destiny has no parents, but has connections, create a shortcut
         
         if there is no parent and connections but the destiny is bellow the origin, connect them.
         */

        guard !checkConnection(fromNode1: originNode, toNode2: destinyNode) else {
            throw HistoryError.duplicatedConnection
        }

        if destinyNode.parent == nil {
            let connection = HistoryConnection(destinyNode: destinyNode, title: title)

            if destinyNode.positionY == originNode.positionY + 1 {
                originNode.connections.append(connection)
                destinyNode.parent = originNode
            } else {
                do {
                    try grid.moveNode(destinyNode, toBellowOfNode: originNode)

                    addBordersToNode(destinyNode)

                    //connect them
                    originNode.connections.append(connection)
                    destinyNode.parent = originNode
                } catch {
                    //create the shortcut
                    addShortcut(fromNode: originNode, toNode: destinyNode)
                }
            }
        } else {
            addShortcut(fromNode: originNode, toNode: destinyNode)
        }
    }

    /// add a shortcut to a node
    ///
    /// - Parameters:
    ///   - originNode: the shortcut`s parent node
    ///   - destinyNode: the node represented by the shortcut
    public func addShortcut(fromNode originNode: HistoryNodeProtocol, toNode destinyNode: HistoryNodeProtocol) {

    }

    /// checks if a node is the graph
    ///
    /// - Parameter node: the node to be checked
    /// - Returns: true if the graph contains the node, false if not
    public func containsNode(_ node: HistoryNodeProtocol) -> Bool {
        let graphContainsNode: Bool = nodes.contains(where: { currentNode in
            currentNode === node
        })

        return graphContainsNode
    }

    /// add a node to the graph
    ///
    /// - Parameter node: the node
    public func addNode(_ node: HistoryNodeProtocol) throws {

        let existPosition: Bool = grid.hasPosition(yIndex: node.positionY, xIndex: node.positionX)
        let positionIsFree: Bool = grid[node.positionY, node.positionX] == nil
        let graphContainsNode: Bool = containsNode(node)

        guard existPosition, positionIsFree else {
            throw HistoryError.wrongNodePosition
        }

        guard !graphContainsNode else {
            throw HistoryError.duplicatedNode
        }

        grid[node.positionY, node.positionX] = node

        nodes.append(node)

        addBordersToNode(node)
    }

    /// Add lines and columns in the node sides if it is in the grid border
    ///
    /// - Parameter node: the target node
    internal func addBordersToNode(_ node: HistoryNodeProtocol, grid: HistoryNodesGrid? = nil) {
        let grid = grid ?? self.grid

        if node.positionX == grid.graphWidth - 1 {
            grid.addColumToGrid()
        }

        if node.positionY == grid.graphHeight - 1 {
            grid.addLineToGrid()
        }

        if node.positionX == 0 {
            grid.addColumToGridBegin()
        }
    }

    /// remove a node from the graph and all it connections and shortcuts
    ///
    /// - Parameter node: the node the be removed
    public func removeNode(_ node: HistoryNodeProtocol) {
        //rever com os shortcuts

        if let parentNode = node.parent as? HistoryNode {
            parentNode.removeConnection(toNode: node)
        }

        if let historyNode = node as? HistoryNode {
            for connection in historyNode.connections {
                connection.destinyNode?.parent = nil
            }
        }

        self.nodes.removeAll { currentNode in
            currentNode === node
        }

        self.grid[node.positionY, node.positionX] = nil
    }

    /// remove a connection from the graph
    ///
    /// - Parameter connection: the connection to be removed
    public func removeConnection(_ connection: HistoryConnection, fromNode node: HistoryNode) {
        connection.destinyNode?.parent = nil

        node.connections.removeAll { (currentConnection) -> Bool in
            return currentConnection == connection
        }
    }

    /// remove a shortcut from the graph
    ///
    /// - Parameter shortcut: the shortcut to be removed
    public func removeShortcut( _ shortcut: HistoryShortcut) {

    }

    /// It checks the connection between two nodes
    ///
    /// - Parameters:
    ///   - node1: the first node
    ///   - node2: second node
    /// - Returns: true if they are connected, false if not
    internal func checkConnectionBetween(node1: HistoryNode, andNode2 node2: HistoryNode) -> Bool {
        return checkConnection(fromNode1: node1, toNode2: node2) || checkConnection(fromNode1: node2, toNode2: node1)
    }

    ///  Check if the node1 is connected to the node2
    ///
    /// - Parameters:
    ///   - node1: the first node
    ///   - node2: the second node
    /// - Returns: true if it is connected, false if not
    internal func checkConnection(fromNode1 node1: HistoryNode, toNode2 node2: HistoryNode) -> Bool {
        for connection in node1.connections {
            if let destinyNode = connection.destinyNode, destinyNode === node2 {
                return true
            }
        }

        return false
    }
}
