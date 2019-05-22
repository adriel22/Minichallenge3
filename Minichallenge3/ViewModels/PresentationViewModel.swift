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
        self.nodes = [rootNode, rootNode]
    }
    
    func update(_ view: UIViewController) {
    }
    
    func setNavigationBarTitle(inNavigationItem item: UINavigationItem) {
        item.title = graph.historyName
    }
    
    func textForTableViewCell(atIndexPath indexPath: IndexPath, reuseIdentifier: String) -> String? {
        return (reuseIdentifier == "rootCell") ? graph.sinopse : nodes[indexPath.section].text
    }
    
    func titleForCollectionViewCell(atTableViewIndexPath tableViewIndexPath: IndexPath, atCollectionViewIndexPath collectionViewIndexPath: IndexPath) -> String? {
        let branches = nodes[tableViewIndexPath.section].connections
        let text = branches[collectionViewIndexPath.item].title
        return text
    }
    
    func titleForHeader(atSection section: Int, selectedBranch: Int?) -> String? {
        switch section {
        case 0:
            return "Sinopse"
        case 1:
            return "Start point"
        default:
            if let selectedBranchIndex = selectedBranch {
                return nodes[section-1].connections[selectedBranchIndex].title
            } else {
                return nil
            }
        }
    }
    
    func forwardBranch(tableViewIndexPath: IndexPath, collectionViewIndexPath: IndexPath, updateView view: UIViewController) {
        guard let view = view as? PresentationViewController else { return }
        
        let branches = nodes[tableViewIndexPath.section].connections
        guard let destination = branches[collectionViewIndexPath.item].destinyNode as? HistoryNode else { return }
        
        nodes.append(destination)
        insertNode(belowIndexPath: tableViewIndexPath, inView: view)
        changeBranchSelection(section: tableViewIndexPath.section, item: collectionViewIndexPath.item, inView: view)
        blockPreviousCollectionViews(currentTableViewIndexPath: tableViewIndexPath, inView: view)
    }
    
    func switchBranch(tableViewIndexPath: IndexPath, collectionViewIndexPath: IndexPath, updateView view: UIViewController) {
        guard let view = view as? PresentationViewController else { return }
        
        let branches = nodes[tableViewIndexPath.section].connections
        guard let destination = branches[collectionViewIndexPath.item].destinyNode as? HistoryNode else { return }
        
        nodes[nodes.count-1] = destination
        reloadNode(atIndexPath: tableViewIndexPath, inView: view)
        changeBranchSelection(section: tableViewIndexPath.section, item: collectionViewIndexPath.item, inView: view)
    }
    
    func undo(atSection section: Int, inView view: UIViewController) {
        guard let view = view as? PresentationViewController else { return }
        
        nodes.removeLast()
        deleteNode(atSection: section, inView: view)
        changeBranchSelection(section: section - 1, item: nil, inView: view)
        unblockPreviousCollectionViews(currentSection: section - 1, inView: view)
    }
    
    private func blockPreviousCollectionViews(currentTableViewIndexPath indexPath: IndexPath, inView view: PresentationViewController) {
        let cell = view.storyTableView.cellForRow(at: [indexPath.section - 1, 0]) as? NodePresentationTableViewCell
        let nodeView = cell?.nodeView
        nodeView?.enableBranches(false)
    }
    
    private func unblockPreviousCollectionViews(currentSection section: Int, inView view: PresentationViewController) {
        let cell = view.storyTableView.cellForRow(at: [section, 0]) as? NodePresentationTableViewCell
        let nodeView = cell?.nodeView
        nodeView?.enableBranches(true)
    }
    
    private func changeBranchSelection(section: Int, item: Int?, inView view: PresentationViewController) {
        view.selectedBranchesIndexes[section] = item
    }
    
    private func insertNode(belowIndexPath indexPath: IndexPath, inView view: PresentationViewController) {
        view.storyTableView.performBatchUpdates({
            view.storyTableView.insertSections([indexPath.section + 1], with: .fade)
        }, completion: { _ in
            view.storyTableView.scrollToRow(at: [indexPath.section + 1, 0], at: .bottom, animated: true)
        })
    }
    
    private func reloadNode(atIndexPath indexPath: IndexPath, inView view: PresentationViewController) {
        view.storyTableView.reloadSections([indexPath.section + 1], with: .fade)
    }
    
    private func deleteNode(atSection section: Int, inView view: PresentationViewController) {
        view.storyTableView.deleteSections([section], with: .fade)
    }
    
}
