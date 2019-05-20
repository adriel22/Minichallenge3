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
        guard let _ = view as? PresentationViewController else { return }
    }
    
    func setNavigationBarTitle(inNavigationItem item: UINavigationItem) {
        item.title = graph.historyName
    }
    
    func textForTableViewCell(atIndexPath indexPath: IndexPath, reuseIdentifier: String) -> String? {
        return (reuseIdentifier == "rootCell") ? graph.sinopse : nodes[indexPath.section].text
    }
    
    func titleForCollectionViewCell(atTableViewIndexPath tableViewIndexPath: IndexPath, atCollectionViewIndexPath collectionViewIndexPath: IndexPath) -> String? {
        let branches = nodes[tableViewIndexPath.section].connections
        if collectionViewIndexPath.item >= branches.count { return nil }
        return branches[collectionViewIndexPath.item].title
    }
    
    func goToBranch(tableViewIndexPath: IndexPath, collectionViewIndexPath: IndexPath, updateView view: UIViewController) {
        let fromNode = nodes[tableViewIndexPath.section]
        var replace = false
        
        fromNode.connections.forEach { connection in
            if connection.destinyNode === nodes.last {
                replace = true
            }
        }
        
        let toNode = fromNode.connections[collectionViewIndexPath.item].destinyNode
        guard let destination = toNode as? HistoryNode else { return }
        
        guard let view = view as? PresentationViewController else { return }
        changeBranchSelection(section: tableViewIndexPath.section,
                              item: collectionViewIndexPath.item,
                              inView: view)
        blockPreviousCollectionViews(currentTableViewIndexPath: tableViewIndexPath, inView: view)
        
        if !replace {
            nodes.append(destination)
            insertNode(belowIndexPath: tableViewIndexPath, inView: view)
        } else {
            nodes[nodes.count - 1] = destination
            let toReplaceIndexPath = IndexPath(row: 0, section: tableViewIndexPath.section + 1)
            replaceNode(atIndexPath: toReplaceIndexPath, inView: view)
        }
        
    }
    
    func undo(atSection section: Int, inView view: UIViewController) {
        guard let view = view as? PresentationViewController else { return }
        deleteNode(atSection: section, inView: view)
        changeBranchSelection(section: section - 1, item: -1, inView: view)
        unblockPreviousCollectionViews(currentSection: section - 1, inView: view)
        
        let tableDelegate = view.storyTableView.delegate
        let sectionHeaderView = tableDelegate?.tableView?(view.storyTableView, viewForHeaderInSection: section - 1) as? ExpandableTableViewHeaderView
        sectionHeaderView?.isTheLastSection = true
        
        let indexSet = IndexSet(integer: section - 1)
        view.storyTableView.reloadSections(indexSet, with: .fade)
        
    }
    
    private func blockPreviousCollectionViews(currentTableViewIndexPath indexPath: IndexPath, inView view: PresentationViewController) {
        var previousIndexPath: IndexPath
        
        if indexPath.section - 1 == 0 {
            previousIndexPath = IndexPath(row: 1, section: 0)
        } else {
            previousIndexPath = IndexPath(row: 0, section: indexPath.section - 1)
        }
        
        let cell = view.storyTableView.cellForRow(at: previousIndexPath) as? NodePresentationTableViewCell
        let nodeView = cell?.nodeView
        nodeView?.enableBranches(false)
    }
    
    private func unblockPreviousCollectionViews(currentSection section: Int, inView view: PresentationViewController) {
        var previousIndexPath: IndexPath
        
        if section - 1 == 0 {
            previousIndexPath = IndexPath(row: 1, section: 0)
        } else {
            previousIndexPath = IndexPath(row: 0, section: section)
        }
        
        let cell = view.storyTableView.cellForRow(at: previousIndexPath) as? NodePresentationTableViewCell
        let nodeView = cell?.nodeView
        nodeView?.enableBranches(true)
    }
    
    private func changeBranchSelection(section: Int, item: Int, inView view: PresentationViewController) {
        view.selectedBranchesIndexes[section] = item
    }
    
    private func insertNode(belowIndexPath indexPath: IndexPath, inView view: PresentationViewController) {
        let cell = view.storyTableView.cellForRow(at: indexPath) as? NodePresentationTableViewCell
        cell?.nodeView.reload(withText: cell?.nodeView.text)
        
        view.storyTableView.performBatchUpdates({
            let tableDelegate = view.storyTableView.delegate
            let sectionHeaderView = tableDelegate?.tableView?(view.storyTableView, viewForHeaderInSection: indexPath.section) as? ExpandableTableViewHeaderView
            sectionHeaderView?.isTheLastSection = false
            
            let indexSet = IndexSet(integer: indexPath.section + 1)
            view.storyTableView.insertSections(indexSet, with: .fade)
            
        }) { _ in
            view.storyTableView.reloadData()
            let newIndexPath = IndexPath(row: 0, section: indexPath.section + 1)
            view.storyTableView.scrollToRow(at: newIndexPath, at: .middle, animated: true)
        }
    }
    
    private func replaceNode(atIndexPath indexPath: IndexPath, inView view: PresentationViewController) {
        let indexSet = IndexSet(integer: indexPath.section)
        view.storyTableView.reloadSections(indexSet, with: .fade)
    }
    
    private func deleteNode(atSection section: Int, inView view: PresentationViewController) {
        nodes.remove(at: section)
        let indexSet = IndexSet(integer: section)
        view.storyTableView.deleteSections(indexSet, with: .fade)
    }
    
}
