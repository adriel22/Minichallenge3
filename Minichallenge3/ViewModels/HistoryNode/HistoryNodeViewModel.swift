//
//  HistoryNodeViewModel.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import HistoryGraph

class HistoryNodeViewModel {
    private var historyGraph: HistoryGraph
    private var historyNode: HistoryNodeProtocol
    let currentState: HistoryGraphState
    lazy var optionName: String? = {
        guard let parentNode = historyNode.parent as? HistoryNode,
              let connectionToSelf = parentNode.connection(
                    toPositionX: historyNode.positionX,
                    positionY: historyNode.positionY
              ) else {

            return nil
        }
        
        return connectionToSelf.title
    }()

    var nodeResume: String? {
        return historyNode.resume ?? historyNode.text
    }

    var nodeType: HistoryGraphViewModelNodeType? {
        switch historyNode {
        case is HistoryNode:
            return .normal
        case is HistoryShortcut:
            return .shortcut
        default:
            return nil
        }
    }

    init(withHistoryGraph historyGraph: HistoryGraph, andHistoryNode historyNode: HistoryNodeProtocol, withState state: HistoryGraphState) {
        self.historyGraph = historyGraph
        self.historyNode = historyNode
        self.currentState = state
    }
}
