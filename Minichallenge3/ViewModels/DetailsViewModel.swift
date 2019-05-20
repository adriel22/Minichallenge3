//
//  DetailsViewModel.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
import HistoryGraph

class DetailsViewModel: NSObject, DetailsViewModelProtocol {
    
    var story: HistoryNode
    var graph: HistoryGraph

    init(story: HistoryNode, graph: HistoryGraph) {
        self.story = story
        self.graph = graph
    }
    
    func titleForCollectionViewCell(atIndexPath indexPath: IndexPath) -> String? {
        return story.connections[indexPath.item].title
    }

    func textUpdated(with text: String, inNode node: HistoryNode) {
        node.text = text
    }
    
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
