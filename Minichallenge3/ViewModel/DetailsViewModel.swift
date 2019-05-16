//
//  DetailsViewModel.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class DetailsViewModel: NSObject {
    var story: HistoryNode
    
    init(story: HistoryNode) {
        self.story = story
    }
    
    func addBranch() {
        
    }
    
    func textUpdated(with text: String, inNode node: HistoryNode) {
        node.text = text
    }
    
    func update(_ view: DetailsViewController) {
        var branches = story.connections
        let destinyNode = !branches.isEmpty ? branches[view.selected].destinyNode : nil
        let downnodeText = destinyNode?.text
        view.downnodeView.reload(withText: downnodeText)
        view.upnodeView.reload(withText: story.text)
    }
    
}
