//
//  HistoryGraph.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

struct HistoryGraph: CustomStringConvertible {

    var nodes: [HistoryNodeProtocol] = []
    var historyName: String
    var sinopse: String
    var graphWidth: Int
    var graphHeight: Int

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
        self.graphWidth = width
        self.graphHeight = height
    }

    /// Adds a connection between two nodes
    ///
    /// - Parameters:
    ///   - originNode: the origin node
    ///   - destinyNode: the destiny node
    func addConnection(fromNode originNode: HistoryNodeProtocol, toNode destinyNode: HistoryNodeProtocol, withTitle title: String) {

        guard let originNode = originNode as? HistoryNode else {
            return
        }

        let connection = HistoryConnection(destinyNode: destinyNode, title: title)

        originNode.connections.append(connection)
        destinyNode.parent = originNode
    }

    /// add a shortcut to a node
    ///
    /// - Parameters:
    ///   - originNode: the shortcut`s parent node
    ///   - destinyNode: the node represented by the shortcut
    mutating func addShortcut(fromNode originNode: HistoryNodeProtocol, toNode destinyNode: HistoryNodeProtocol, andPositionX positionX: Int, andPositionY positionY:Int) {

        guard let originNode = originNode as? HistoryNode else {
            return
        }
        guard let destinyNode = destinyNode as? HistoryNode else{
            return
        }
        let shortcut = HistoryShortcut(forNode: destinyNode, andParentNode: originNode, positionX: positionX, andPositionY: positionY)
        
        self.addNode(shortcut)
        
    }

    /// add a node to the graph
    ///
    /// - Parameter node: the node
    mutating func addNode(_ node: HistoryNodeProtocol) {
        guard !nodes.contains(where: { currentNode in
            currentNode === node
        }) else {
            return
        }

        nodes.append(node)
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
}
