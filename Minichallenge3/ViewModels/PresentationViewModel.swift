//
//  PresentationViewModel.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 16/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import HistoryGraph

class PresentationViewModel: NSObject, PresentationViewModelProtocol {
    
    var graph: HistoryGraph
    var rootNode: HistoryNode
    var nodes: [HistoryNode]
    
    init(graph: HistoryGraph, rootNode: HistoryNode) {
        self.graph = graph
        self.rootNode = rootNode
        self.nodes = [rootNode]
    }
    
    func update(_ view: UIViewController) {
        guard let view = view as? PresentationViewController else { return }
        
        let text = textForHistoryNode(at: view.currentSection)
        if view.currentSection != 0 {
            view.contentView.nodeView.reload(withText: text)
        }
        
        if view.currentSection > 0 {
            view.contentView.headerView.isTheLastSection = true
        } else {
            view.contentView.headerView.isTheLastSection = false
        }
    }
    
    func setNavigationBarTitle(in item: UINavigationItem) {
        item.title = graph.historyName
    }
    
    func titleForHeader(at section: Int) -> String? {
        let index = section
        var title: String?
        
        if index == -2 {
            return "SINOPSE"
        } else if index == -1 {
            return "COMEÇO"
        } else if index >= 0 && index < nodes.count {
            let branches = nodes[index].connections
            branches.forEach { connection in
                if connection.destinyNode === nodes.last {
                    title = connection.title
                    return
                }
            }
        }
        
        return title?.uppercased()
    }
    
    func updateHeaderTitle(with title: String?, in view: UIViewController) {
        guard let view = view as? PresentationViewController else { return }
        view.contentView.headerView.text = title?.uppercased()
    }
    
    func textForHistoryNode(at section: Int) -> String? {
        if section >= nodes.count || section < 0 { return nil }
        return nodes[section].text
    }
    
    func titleForCollectionViewCell(at section: Int, at collectionViewIndexPath: IndexPath) -> String? {
        let branches = nodes[section].connections
        return branches[collectionViewIndexPath.item].title
    }
    
    func forwardBranch(section: Int, indexPath: IndexPath, in view: UIViewController) {
        let branches = nodes[section].connections
        let destiny = branches[indexPath.item].destinyNode
        
        if let target = destiny as? HistoryNode {
            nodes.append(target)
        } else if let target = destiny as? HistoryShortcut {
            guard let destination = target.node else { return }
            nodes.append(destination)
        } else {
            return
        }
        
        let title = titleForHeader(at: section)
        updateHeaderTitle(with: title, in: view)
    }
    
    func undo(in view: UIViewController) {
        if nodes.count > 1 { nodes.removeLast() }
        let title = titleForHeader(at: nodes.count-2)
        updateHeaderTitle(with: title, in: view)
    }
    
}
