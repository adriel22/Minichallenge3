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
    var currentState: HistoryGraphState
    var nodeResume: String? {
        return historyNode.resume ?? historyNode.text
    }
    
    init(withHistoryGraph historyGraph: HistoryGraph, andHistoryNode historyNode: HistoryNodeProtocol, withState state: HistoryGraphState) {
        self.historyGraph = historyGraph
        self.historyNode = historyNode
        self.currentState = state
    }
}
