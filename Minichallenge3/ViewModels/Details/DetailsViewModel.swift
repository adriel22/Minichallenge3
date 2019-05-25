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
    
    init(story: HistoryNode, graph: HistoryGraph) {
        self.story = story
        self.graph = graph
    }
    
    func titleForCollectionViewCell(at indexPath: IndexPath) -> String? {
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
        if branches.isEmpty { return }
        guard let destiny = branches[branchIndex].destinyNode as? HistoryNode else { return }
        story = destiny
    }
    func willCloseController() {
        storyDAO.save(element: graph)
        transitionDelegate?.willCloseController()
    }
    
    func update(_ view: UIViewController) {
        guard let view = view as? DetailsViewController else { return }
        var branches = story.connections
        let destinyNode = !branches.isEmpty ? branches[view.selected].destinyNode : nil
        let downnodeText = destinyNode?.text
        view.downnodeView.reload(withText: downnodeText)
        view.upnodeView.reload(withText: story.text)
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
