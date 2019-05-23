//
//  AddRamificationViewModel.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 16/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import HistoryGraph

class AddRamificationViewModel {
    public weak var trasitioningDelegate: AddRamificationTrasitioningDelegate?
    public weak var delegate: AddRamificationViewModelDelegate?
    
    let graph: HistoryGraph
    let parentNode: HistoryNode

    init(inGraph graph: HistoryGraph, withParent parentNode: HistoryNode) {
        self.graph = graph
        self.parentNode = parentNode
    }

    func addNode(_ nodeTitle: String) {
        let nodePositionY = parentNode.positionY + 1

        let nodePositionX = graph.grid.findPositionInLine(atIndex: nodePositionY, nearIndex: parentNode.positionX) ?? 0

        let newNode = HistoryNode(withResume: "", text: "", positionX: nodePositionX, andPositionY: parentNode.positionY + 1)

        try? graph.addNode(newNode)

        try? graph.addPath(fromNode: parentNode, toNode: newNode, withTitle: nodeTitle)
//        try? graph.addConnection(fromNode: parentNode, toNode: newNode, withTitle: "")
        trasitioningDelegate?.finishedAddingRamification()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        delegate?.showKeyboard(notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        delegate?.hideKeyboard(notification)
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
    }
    
    @objc func changedStateof(_ sender: UISegmentedControl) {

        if sender.selectedSegmentIndex == 0 {
            delegate?.updateViewTostate(.create)
        }
        if sender.selectedSegmentIndex == 1 {
            delegate?.updateViewTostate(.reuse)
        }
    }

}
