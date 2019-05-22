//
//  DetailsViewModel.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
import HistoryGraph

class DetailsViewModel: NSObject {
    public weak var delegate: DetailsViewModelDelegate?
    
    var story: HistoryNode
    var graph: HistoryGraph
    var storyDAO = RAMHistoryDAO()
    
    weak var transitionDelegate: DetailsViewModelTransitioningDelegate?

    init(story: HistoryNode, graph: HistoryGraph) {
        self.story = story
        self.graph = graph
    }

    func addBranch() {
        let addView = AddRamificationViewController(inGraph: self.graph, withParentNode: self.story)
        delegate?.showAddView(addView)
    }

    func textUpdated(with text: String, inNode node: HistoryNode) {
        node.text = text
    }
    
    func willCloseController() {
        storyDAO.save(element: graph)
        transitionDelegate?.willCloseController()
    }

    func update(_ view: DetailsViewController) {
        var branches = story.connections
        let destinyNode = !branches.isEmpty ? branches[view.selected].destinyNode : nil
        let downnodeText = destinyNode?.text
        view.downnodeView.reload(withText: downnodeText)
        view.upnodeView.reload(withText: story.text)
    }
    
}
extension DetailsViewModel: AddRamificationTrasitioningDelegate {
    func finishedAddingRamification() {
        delegate?.updateView()
    }
    
}
