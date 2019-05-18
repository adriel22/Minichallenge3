//
//  HistoryGraphViewModel.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import HistoryGraph

class HistoryGraphViewModel {
    public weak var delegate: HistoryGraphViewModelDelegate?
    
    var sinopse: String? {
        return historyGraph.sinopse
    }
    
    private var historyGraph: HistoryGraph
    var currentState: HistoryGraphState = .normal {
        didSet {
            delegate?.needReloadGraph()
        }
    }
    
    init(withHistoryGraph historyGraph: HistoryGraph) {
        self.historyGraph = historyGraph
    }
    
    func gridSize() -> GridSize {
        return (width: historyGraph.grid.graphWidth, height: historyGraph.grid.graphHeight)
    }
    
    func viewModelForNode(atPosition position: GridPosition) -> HistoryNodeViewModel? {
        guard let nodeAtPosition = historyGraph.grid[position.yPosition, position.xPosition] else {
            return nil
        }
        return HistoryNodeViewModel(withHistoryGraph: historyGraph, andHistoryNode: nodeAtPosition, withState: currentState)
    }
    
    func gridConnections(fromPositionGridPosition gridPosition: GridPosition) -> [GridPosition] {
        guard let node = historyGraph.grid[gridPosition.yPosition, gridPosition.xPosition] as? HistoryNode else {
            return []
        }
        
        return node.connections.compactMap({ (historyConnection) -> GridPosition? in
            guard let destinyNode = historyConnection.destinyNode else {
                return nil
            }
            
            return (xPosition: destinyNode.positionX, yPosition: destinyNode.positionY)
        })
    }
    
    func nodeWasSelected() {
        
    }
    
    func optionWasSelected(atPositon positon: Int) {
        switch positon {
        case 0:
            self.currentState = .adding
        case 1:
            self.currentState = .removing
        case 2:
            self.currentState = .connecting
        default:
            self.currentState = .normal
        }
    }
    
    func optionWasFinished() {
        self.currentState = .normal
    }
}
