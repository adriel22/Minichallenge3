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
    private var historyGraphID: Int
    private var historyDAO = RAMHistoryDAO()
    
    var currentState: HistoryGraphState = .normal {
        didSet {
            delegate?.needReloadGraph()
        }
    }
    
    init(withHistoryGraph historyGraph: HistoryGraph, withIdentifier identifier: Int) {
        self.historyGraph = historyGraph
        self.historyGraphID = identifier
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
    
    func playWasTapped() {
        //show play screen
    }
    
    func nodeWasSelected(atPossition position: GridPosition) {
        guard let node = historyGraph.grid[position.yPosition, position.xPosition] else {
            return
        }
        
        switch currentState {
        case .normal:
            nodeWasSelectedInNormalState(atPossition: position, inNode: node)
        case .removing:
            nodeWasSelectedInRemovingState(atPossition: position, inNode: node)
        case .adding:
            break
        case .connecting:
            break
        }
    }
    
    func viewWillDisappear() {
        historyDAO.update(element: historyGraph, withID: historyGraphID)
    }
    
    private func nodeWasSelectedInRemovingState(atPossition position: GridPosition, inNode node: HistoryNodeProtocol) {
        do {
            try historyGraph.removeNode(node)
            delegate?.nodeDeletionFinished(atPositon: position)
        } catch let error as HistoryError {
            delegate?.needShowError(message: error.rawValue)
        } catch {
            delegate?.needShowError(message: "A Error Happend")
        }
    }
    
    private func nodeWasSelectedInNormalState(atPossition position: GridPosition, inNode node: HistoryNodeProtocol) {
        guard let historyNode = node as? HistoryNode else {
            guard let shortcutNode = node as? HistoryShortcut,
                  let shortcutOwner = shortcutNode.node else {
                return
            }

            let ownerNodePosition = (yPosition: shortcutOwner.positionY, xPosition: shortcutOwner.positionX)
            delegate?.needFocusNode(atPosition: ownerNodePosition)
            
            return
        }
        let controller = DetailsViewController()
        let navigation = UINavigationController(rootViewController: controller)
        controller.viewModel = DetailsViewModel(story: historyNode, graph: historyGraph)
        
        delegate?.needShowViewController(navigation)
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
