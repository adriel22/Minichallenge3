//
//  HistoryNode.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

public class HistoryNode: HistoryNodeProtocol {
    public var positionX: Int
    public var positionY: Int
    public var resume: String?
    public var text: String?

    public weak var parent: HistoryNodeProtocol?
    public var shortcuts: [HistoryShortcut] = []
    public var connections: [HistoryConnection] = []

    public var description: String {
        return "Resume: \(self.resume ?? "None"), Position: (y: \(positionY), x: \(positionX))"
    }

    /// Initialize the node
    ///
    /// - Parameters:
    ///   - resume: the resume is a little text about the node history, used to the nodes previews
    ///   - text: the real history text for the node
    public init(withResume resume: String?, text: String?, positionX: Int, andPositionY positionY: Int) {
        self.text = text
        self.positionX = positionX
        self.positionY = positionY
    }

    public func removeConnection(toNode node: HistoryNodeProtocol) {
        guard let connectionIndex = connectionIndex(toNode: node) else {
            return
        }
        
        connections[connectionIndex].destinyNode?.parent = nil
        connections.remove(at: connectionIndex)
    }
    
    public func connection(toNode node: HistoryNodeProtocol) -> HistoryConnection? {
        guard let connectionIndex = connectionIndex(toNode: node) else {
            return nil
        }
        
        return connections[connectionIndex]
    }
    
    public func connectionIndex(toNode node: HistoryNodeProtocol) -> Int? {
        let nodeIndex = connections.firstIndex {currentConnection in
            currentConnection.destinyNode === node
        }
        
        guard let safeNodeIndex = nodeIndex else {
            return nil
        }
        
        return safeNodeIndex
    }

    public func connection(toPositionX positionX: Int, positionY: Int) -> HistoryConnection? {
        return connections.first { (currentConnection) -> Bool in
            guard let destinyNode = currentConnection.destinyNode else {
                return false
            }
            return destinyNode.positionX == positionX && destinyNode.positionY == positionY
        }
    }
}
