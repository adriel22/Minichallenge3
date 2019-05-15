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
//        let newNode = HistoryNode(withResume: "", text: "", positionX: <#Int#>, andPositionY: <#Int#>)
//        let connection = HistoryConnection(destinyNode: newNode, title: "")
//        story.connections.append(connection)
    }
    
    func textUpdated(with text: String, inNode node: HistoryNode) {
        node.text = text
    }
    
    func update(_ view: DetailsViewController) {
        view.upnodeView.text.text = story.text
        view.upnodeView.branches.reloadData()
        var branches = story.connections
        let downnodeText = !branches.isEmpty ? branches[view.selected].destinyNode?.text : ""
        view.downnodeView.text.text = downnodeText
    }
    
}
