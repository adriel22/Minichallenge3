//
//  DetailsViewModel.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
import HistoryGraph

class DetailsViewModel: DetailsViewModelProtocol {
    
    var story: HistoryNode
    var graph: HistoryGraph
    var storyDAO = RAMHistoryDAO()
    
    public weak var delegate: DetailsViewModelDelegate?
    weak var transitionDelegate: DetailsViewModelTransitioningDelegate?
    weak var animationDelegate: DetailsViewModelAnimationDelegate?
    
    init(story: HistoryNode, graph: HistoryGraph) {
        self.story = story
        self.graph = graph
    }
    
    func titleForCollectionViewCell(at indexPath: IndexPath) -> String? {
        if indexPath.item >= story.connections.count { return nil }
        return story.connections[indexPath.item].title
    }
    
    func addBranch() {
        let addView = AddRamificationViewController(inGraph: self.graph, withParentNode: self.story)
        delegate?.showAddView(addView)
    }
    
    func textUpdated(with text: String, in node: HistoryNode) {
        node.text = text
    }
    
    func goOn(branchIndex: Int) {
        let branches = story.connections
        if branchIndex >= branches.count { return }
        
        if let destiny = branches[branchIndex].destinyNode as? HistoryNode {
            story = destiny
        } else if let target = branches[branchIndex].destinyNode as? HistoryShortcut,
                  let destiny = target.node {
            story = destiny
        } else {
            return
        }
        
    }
    
    func goBack() {
        if let parent = story.parent as? HistoryNode {
            story = parent
        } else if let parent = story.parent as? HistoryShortcut {
            if let node = parent.node {
                story = node
            }
        }
    }
    
    func willCloseController() {
        storyDAO.save(element: graph)
        transitionDelegate?.willCloseController()
    }
    
    func update(_ view: UIViewController) {
        guard let view = view as? DetailsViewController else { return }
        
        var branches = story.connections
//        if view.selected >= branches.count { return }
        let destinyNode = !branches.isEmpty ? branches[view.selected].destinyNode : nil
        
        if destinyNode == nil {
            view.downnodeView.collapseWhenIsTheLastNode()
            view.downnodeView.hideGoOnButton()
        } else if story === graph.nodes.first {
            view.downnodeView.expandWhenIsNotTheLastNode()
            view.downnodeView.hideGoBackButton()
        } else {
            view.downnodeView.expandWhenIsNotTheLastNode()
            view.downnodeView.showAllButtons()
        }
        
        let downnodeText = destinyNode?.text
        view.downnodeView.reload(withText: downnodeText, animateWithFade: animationDelegate?.shouldAnimateDownnodeView() ?? false)
        view.upnodeView.reload(withText: story.text, animateWithFade: animationDelegate?.shouldAnimateUpnodeView() ?? false)
    }
    
    func setNavigationBarTitle(in item: UINavigationItem) {
        item.title = story.resume
    }
    
}
extension DetailsViewModel: AddRamificationTrasitioningDelegate {
    func finishedAddingRamification() {
        delegate?.updateView()
    }
}
