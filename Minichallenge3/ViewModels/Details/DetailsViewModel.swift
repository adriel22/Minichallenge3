//
//  DetailsViewModel.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
import HistoryGraph

<<<<<<< HEAD:Minichallenge3/ViewModels/DetailsViewModel.swift
class DetailsViewModel: NSObject, DetailsViewModelProtocol {
=======
class DetailsViewModel: NSObject {
    public weak var delegate: DetailsViewModelDelegate?
>>>>>>> f9f7d0631cf2d8a0b6f399d989b322249d4ebcaa:Minichallenge3/ViewModels/Details/DetailsViewModel.swift
    
    var story: HistoryNode
    var graph: HistoryGraph
    var storyDAO = RAMHistoryDAO()
    
    weak var transitionDelegate: DetailsViewModelTransitioningDelegate?

    init(story: HistoryNode, graph: HistoryGraph) {
        self.story = story
        self.graph = graph
    }
<<<<<<< HEAD:Minichallenge3/ViewModels/DetailsViewModel.swift
    
    func titleForCollectionViewCell(atIndexPath indexPath: IndexPath) -> String? {
        return story.connections[indexPath.item].title
=======

    func addBranch() {
        let addView = AddRamificationViewController(inGraph: self.graph, withParentNode: self.story)
        delegate?.showAddView(addView)
>>>>>>> f9f7d0631cf2d8a0b6f399d989b322249d4ebcaa:Minichallenge3/ViewModels/Details/DetailsViewModel.swift
    }

    func textUpdated(with text: String, inNode node: HistoryNode) {
        node.text = text
    }
    
<<<<<<< HEAD:Minichallenge3/ViewModels/DetailsViewModel.swift
    func addBranch() {
    }
    
    func goOn(branchIndex: Int) {
        let branches = story.connections
        if branches.isEmpty { return }
        guard let destiny = branches[branchIndex].destinyNode as? HistoryNode else { return }
        story = destiny
    }
    
    func update(_ view: UIViewController) {
        guard let view = view as? DetailsViewController else { return }
=======
    func willCloseController() {
        storyDAO.save(element: graph)
        transitionDelegate?.willCloseController()
    }

    func update(_ view: DetailsViewController) {
>>>>>>> f9f7d0631cf2d8a0b6f399d989b322249d4ebcaa:Minichallenge3/ViewModels/Details/DetailsViewModel.swift
        var branches = story.connections
        let destinyNode = !branches.isEmpty ? branches[view.selected].destinyNode : nil
        let downnodeText = destinyNode?.text
        view.downnodeView.reload(withText: downnodeText)
        view.upnodeView.reload(withText: story.text)
    }
    
    func setNavigationBarTitle(inNavigationItem item: UINavigationItem) {
        item.title = story.resume
    }
    
}
extension DetailsViewModel: AddRamificationTrasitioningDelegate {
    func finishedAddingRamification() {
        delegate?.updateView()
    }
    
}
