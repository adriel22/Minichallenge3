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
         se existe conexao origen-desitino nao pode
         
         se o destino tem pai, cria shortcut
         
         se existe uma conexao "voltando", cria shortcut
         
         se o destino nao tem pai nem filhos, move o destino para baixo dele, liga
         
         se o destino nao tem pai, mas tem filhos, cria shortcut
         
         se nao tem pai, tem filhos e esta na linha de baixo, liga
         */
        

        guard !checkConnection(fromNode1: originNode, toNode2: destinyNode) else {
            return
        }

        if destinyNode.parent == nil {
            let connection = HistoryConnection(destinyNode: destinyNode, title: title)

            if destinyNode.connections.count == 0 {
                //move destino para em baixo da origem e liga a linha

                let destinyNodeNewLinePosition = originNode.positionY + 1
                var destinyNodeNewColPosition: Int

                if let newColPosition = grid.findPositionInLine(atIndex: destinyNodeNewLinePosition) {
                    destinyNodeNewColPosition = newColPosition
                    grid.moveNodeToPosition(
                        node: destinyNode,
                        toPositionX: destinyNodeNewColPosition,
                        andPositionY: destinyNodeNewLinePosition
                    )

                    originNode.connections.append(connection)
                    destinyNode.parent = originNode
                }
            } else if destinyNode.positionY == originNode.positionY + 1 {
                //liga linha
                originNode.connections.append(connection)
                destinyNode.parent = originNode
            } else {
                //cria shortcut
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

    private func checkConnectionBetween(node1: HistoryNode, andNode2 node2: HistoryNode) -> Bool {
        return checkConnection(fromNode1: node1, toNode2: node2) || checkConnection(fromNode1: node2, toNode2: node1)
    }

    private func checkConnection(fromNode1 node1: HistoryNode, toNode2 node2: HistoryNode) -> Bool {
        for connection in node1.connections {
            if let destinyNode = connection.destinyNode, destinyNode === node2 {
                return true
            }
        }

        return false
    }
}
