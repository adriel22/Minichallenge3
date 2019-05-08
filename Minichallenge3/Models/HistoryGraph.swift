//
//  HistoryGraph.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

struct HistoryGraph {
    weak var root: HistoryNodeProtocol?
    var nodes: [HistoryNodeProtocol]
    var historyName: String
    var sinopse: String
    var graphWidth: Int
    var graphHeight: Int

    /// Adds a connection between two nodes
    ///
    /// - Parameters:
    ///   - originNode: the origin node
    ///   - destinyNode: the destiny node
    func addConnection(fromNode originNode: HistoryNodeProtocol, toNode destinyNode: HistoryNodeProtocol) {
        
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
