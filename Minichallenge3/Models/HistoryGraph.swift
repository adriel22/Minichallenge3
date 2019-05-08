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

    func addConnection(fromNode originNode: HistoryNodeProtocol, toNode destinyNode: HistoryNodeProtocol) {
        
    }

    func addShortcut(fromNode originNode: HistoryNodeProtocol, toNode destinyNode: HistoryNodeProtocol) {
        
    }
    
    func addNode(_ node: HistoryNodeProtocol) {
        
    }
    
    func removeNode(_ node: HistoryNodeProtocol) {
        
    }
    
    func removeConnection(_ connection: HistoryConnection) {
        
    }
    
    func removeShortcut( _ shortcut: HistoryShortcut) {
        
    }
}
