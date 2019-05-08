//
//  HistoryGraph.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

class HistoryGraph: CustomStringConvertible {

    var nodes: [HistoryNodeProtocol] = []
    var historyName: String
    var sinopse: String

    var grid: HistoryNodesGrid

    var description: String {
        var description = ""

        for node in nodes {
            description += node.description + "\n"
        }

        return description
    }

    init(withName name: String, sinopse: String, width: Int, andHeight height: Int) {
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
    func addConnection(fromNode originNode: HistoryNode,
                       toNode destinyNode: HistoryNode,
                       withTitle title: String) {
        
        /*
         if there is a connection origin-destiny, it stops
         
         if the destiny has a parent, it create a shortcut

         if there is a connection "backing", it create a shortcut
         
         if the destiny has no parent neither connections, move the destiny node to origins bellow and connect them.
         
         if the destiny has no parents, but has connections, create a shortcut
         
         if there is no parent and connections but the destiny is bellow the origin, connect them.
         */

        guard !checkConnection(fromNode1: originNode, toNode2: destinyNode) else {
            return
        }

        if destinyNode.parent == nil {
            let connection = HistoryConnection(destinyNode: destinyNode, title: title)

            if destinyNode.connections.count == 0 {
                
                //move the destiny to bellow the origin
                let destinyNodeNewLinePosition = originNode.positionY + 1
                var destinyNodeNewColPosition: Int

                if let newColPosition = grid.findPositionInLine(atIndex: destinyNodeNewLinePosition) {
                    destinyNodeNewColPosition = newColPosition
                    grid.moveNodeToPosition(
                        node: destinyNode,
                        toPositionX: destinyNodeNewColPosition,
                        andPositionY: destinyNodeNewLinePosition
                    )
                    
                    //connect them
                    originNode.connections.append(connection)
                    destinyNode.parent = originNode
                }
            } else if destinyNode.positionY == originNode.positionY + 1 {
                //connect them
                originNode.connections.append(connection)
                destinyNode.parent = originNode
            } else {
                //create the shortcut
                addShortcut(fromNode: originNode, toNode: destinyNode)
            }
        } else {

            //se já tem pai, ou ja existe saindo do destino para origem
            addShortcut(fromNode: originNode, toNode: destinyNode)
        }
    }

    /// add a shortcut to a node
    ///
    /// - Parameters:
    ///   - originNode: the shortcut`s parent node
    ///   - destinyNode: the node represented by the shortcut
    func addShortcut(fromNode originNode: HistoryNodeProtocol, toNode destinyNode: HistoryNodeProtocol) {

    }

    /// add a node to the graph
    ///
    /// - Parameter node: the node
    func addNode(_ node: HistoryNodeProtocol) {
        guard node.positionX < grid.graphWidth,
              node.positionY < grid.graphHeight,
              grid[node.positionX, node.positionY] == nil else {

            return
        }

        guard !nodes.contains(where: { currentNode in
            currentNode === node
        }) else {
            return
        }

        grid[node.positionY, node.positionX] = node

        nodes.append(node)

        addBordersToNode(node)
    }

    /// Add lines and columns in the node sides if it is in the grid border
    ///
    /// - Parameter node: the target node
    private func addBordersToNode(_ node: HistoryNodeProtocol) {
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
    func removeNode(_ node: HistoryNodeProtocol) {

    }

    /// remove a connection from the graph
    ///
    /// - Parameter connection: the connection to be removed
    func removeConnection(_ connection: HistoryConnection) {

    }

    /// remove a shortcut from the graph
    ///
    /// - Parameter shortcut: the shortcut to be removed
    func removeShortcut( _ shortcut: HistoryShortcut) {

    }

    /// It checks the connection between two nodes
    ///
    /// - Parameters:
    ///   - node1: the first node
    ///   - node2: second node
    /// - Returns: true if they are connected, false if not
    private func checkConnectionBetween(node1: HistoryNode, andNode2 node2: HistoryNode) -> Bool {
        return checkConnection(fromNode1: node1, toNode2: node2) || checkConnection(fromNode1: node2, toNode2: node1)
    }
    
    ///  Check if the node1 is connected to the node2
    ///
    /// - Parameters:
    ///   - node1: the first node
    ///   - node2: the second node
    /// - Returns: true if it is connected, false if not
    private func checkConnection(fromNode1 node1: HistoryNode, toNode2 node2: HistoryNode) -> Bool {
        for connection in node1.connections {
            if let destinyNode = connection.destinyNode, destinyNode === node2 {
                return true
            }
        }

        return false
    }
}
