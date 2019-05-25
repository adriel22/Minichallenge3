//
//  DISKHistoryFromatter.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 25/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import HistoryGraph

struct DISKHistoryFormatter {
    static func setDISKNodeAtributtes(
        forDISKNode diskNode: inout DISKHistoryNode,
        withHistoryNode normalNode: HistoryNode,
        in historyGraph: HistoryGraph) {
        
        diskNode.connections = normalNode.connections.compactMap({ (connection) -> DISKConnection? in
            guard let destinyNode = connection.destinyNode,
                let destinyNodeIndex = historyGraph.nodes.indexForNode(destinyNode) else {
                    return nil
            }
            
            return DISKConnection(title: connection.title, nodeID: destinyNodeIndex)
        })
        diskNode.shortcutIDs = normalNode.shortcuts.compactMap({ (shortcut) -> Int? in
            return historyGraph.nodes.indexForNode(shortcut)
        })
        
        if let nodeParent = normalNode.parent {
            diskNode.parent = historyGraph.nodes.indexForNode(nodeParent)
        }
    }
    
    static func setDISKShortcutNodeAtributtes(
        forDISKNode diskNode: inout DISKHistoryNode,
        withHistoryNode shortcut: HistoryShortcut,
        in historyGraph: HistoryGraph) {
        
        if let targetShortcutNode = shortcut.node {
            diskNode.shortcutTarget = historyGraph.nodes.indexForNode(targetShortcutNode)
        }
        if let nodeParent = shortcut.parent {
            diskNode.parent = historyGraph.nodes.indexForNode(nodeParent)
        }
    }
    
    static func setAtributtes(
        forHistoryNode node: HistoryShortcut,
        withDISKNode diskNode: DISKHistoryNode,
        in historyGraph: HistoryGraph) {
        
        guard let shortcutTargetIndex = diskNode.shortcutTarget,
              let shortcutParentIndex = diskNode.parent,
              let shortcutTargetNode = historyGraph.nodes[shortcutTargetIndex] as? HistoryNode else {
            return
        }
        
        let shortcutParentNode = historyGraph.nodes[shortcutParentIndex]
        
        node.node = shortcutTargetNode
        node.parent = shortcutParentNode
    }
    
    static func setAtributtes(
        forHistoryNode node: HistoryNode,
        withDISKNode diskNode: DISKHistoryNode,
        in historyGraph: HistoryGraph) {
        
        node.connections = diskNode.connections.map({ (diskConnection) -> HistoryConnection in
            return HistoryConnection(
                destinyNode: historyGraph.nodes[diskConnection.nodeID],
                title: diskConnection.title
            )
        })
        
        node.shortcuts = diskNode.shortcutIDs.compactMap({ (shortcutIndex) -> HistoryShortcut? in
            return historyGraph.nodes[shortcutIndex] as? HistoryShortcut
        })
    
        guard let parentIndex = diskNode.parent else {
            return
        }
        
        node.parent = historyGraph.nodes[parentIndex]
    }
    
    static func setAtributtes(
        forHistoryNode node: HistoryNodeProtocol,
        withDISKNode diskNode: DISKHistoryNode,
        in historyGraph: HistoryGraph) {
        
        if let shortcut = node as? HistoryShortcut {
            setAtributtes(forHistoryNode: shortcut, withDISKNode: diskNode, in: historyGraph)
        } else if let normalNode = node as? HistoryNode {
            setAtributtes(forHistoryNode: normalNode, withDISKNode: diskNode, in: historyGraph)
        }
    }
    
    static func historyGraphToDISKModel(historyGraph: HistoryGraph) -> DISKHistoryGraph {
        var diskGraph = DISKHistoryGraph(
            historyName: historyGraph.historyName,
            sinopse: historyGraph.sinopse,
            gridWidth: historyGraph.grid.graphWidth,
            gridHeight: historyGraph.grid.graphHeight,
            identifier: historyGraph.idKey
        )
        diskGraph.nodes = historyGraph.nodes.map { node -> DISKHistoryNode in
            var diskNode = DISKHistoryNode(
                text: node.text,
                resume: node.resume,
                positionX: node.positionX,
                positionY: node.positionY
            )
            
            if let normalNode = node as? HistoryNode {
                setDISKNodeAtributtes(forDISKNode: &diskNode, withHistoryNode: normalNode, in: historyGraph)
            } else if let shortcutNode = node as? HistoryShortcut {
                setDISKShortcutNodeAtributtes(
                    forDISKNode: &diskNode,
                    withHistoryNode: shortcutNode,
                    in: historyGraph
                )
            }
            
            return diskNode
        }
        
        return diskGraph
    }
    
    static func DISKHistoryToHistoryGraph(diskHistory: DISKHistoryGraph) -> HistoryGraph {
        let historyGraph = HistoryGraph(
            withName: diskHistory.historyName,
            sinopse: diskHistory.sinopse,
            width: diskHistory.gridWidth,
            andHeight: diskHistory.gridHeight
        )
        
        historyGraph.idKey = diskHistory.identifier
        
        historyGraph.nodes = diskHistory.nodes.map({ (currentDISKNode) -> HistoryNodeProtocol in
            guard currentDISKNode.shortcutTarget != nil else {
                return HistoryNode(
                    withResume: currentDISKNode.resume,
                    text: currentDISKNode.text,
                    positionX: currentDISKNode.positionX,
                    andPositionY: currentDISKNode.positionY
                )
            }
            return HistoryShortcut(
                forNode: nil,
                positionX: currentDISKNode.positionX,
                andPositionY: currentDISKNode.positionY
            )
        })
    
        zip(diskHistory.nodes, historyGraph.nodes).forEach { nodes in
            let (diskNode, historyNode) = nodes
            setAtributtes(forHistoryNode: historyNode, withDISKNode: diskNode, in: historyGraph)
        }
        
        historyGraph.grid = createGridForHistory(
            historyGraph,
            withSize: (
                width: diskHistory.gridWidth,
                height: diskHistory.gridHeight
            )
        )
        
        return historyGraph
    }
    
    static func createGridForHistory(
        _ historyGraph: HistoryGraph,
        withSize size: (width: Int, height: Int)) -> HistoryNodesGrid {
        let grid = HistoryNodesGrid(width: size.width, andHeight: size.height)
        
        historyGraph.nodes.forEach { (currentNode) in
            grid[currentNode.positionY, currentNode.positionX] = currentNode
        }
        
        grid.graph = historyGraph
        
        return grid
    }
}
