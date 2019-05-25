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
    
    var title: String? {
        return historyGraph.historyName
    }
    
    var sinopse: String? {
        return historyGraph.sinopse
    }
    
    private var lastTappedNodePosition: GridPosition?
    
    var connectionButtonImage: UIImage? {
        if currentState == .removing {
            return UIImage(named: "garbage")
        }
        return nil
    }
    
    lazy var centerItemPosition: GridPosition? = {
        if let firstNode = historyGraph.nodes.first {
            return (yPosition: firstNode.positionY, xPosition: firstNode.positionX)
        }
        return nil
    }()
    
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
        
        historyGraph.grid.delegate = self
    }
    
    func gridSize() -> GridSize {
        return (width: historyGraph.grid.graphWidth, height: historyGraph.grid.graphHeight)
    }

    func viewModelForNode(atPosition position: GridPosition) -> HistoryNodeViewModel? {
        guard let nodeAtPosition = historyGraph.grid[position.yPosition, position.xPosition] else {
            if currentState == .adding {
                return HistoryNodeViewModel(withHistoryGraph: historyGraph, withState: .empty)
            }
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
            emptyNodeWasSelected(atPossition: position)
            return
        }
        
        switch currentState {
        case .normal:
            nodeWasSelectedInNormalState(atPossition: position, inNode: node)
        case .removing:
            nodeWasSelectedInRemovingState(atPossition: position, inNode: node)
        case .adding:
            nodeWasSelectedInAddingState(atPossition: position, inNode: node)
        case .connecting:
            nodeWasSelectedInConnectingState(atPossition: position, inNode: node)
        case .empty:
            break
        }
    }
    
    func viewWillDisappear() {
        historyDAO.update(element: historyGraph)
    }
    
    func connectionButtonWasSelected(connection: Connection) {
        let originPosition = connection.originPosition
        let destinyPosition = connection.destinyPosition

        guard currentState == .removing,
            historyGraph.grid.hasPosition(yIndex: originPosition.yPosition, xIndex: originPosition.xPosition),
            let originNode = historyGraph.grid[originPosition.yPosition, originPosition.xPosition] as? HistoryNode,
            let connectionToRemove = originNode.connection(
                toPositionX: destinyPosition.xPosition,
                positionY: destinyPosition.yPosition
            ) else {
            return
        }

        do {
            try historyGraph.removeConnection(connectionToRemove, fromNode: originNode)
            delegate?.needReloadConnection()
        } catch let error as HistoryError {
            delegate?.needShowError(message: error.rawValue)
        } catch {
            delegate?.needShowError(message: "A Error Happend")
        }
    }
    
    private func emptyNodeWasSelected(atPossition position: GridPosition) {
        do {
            let emptyNode = HistoryNode(
                withResume: "Tap to edit",
                text: "Tap to edit",
                positionX: position.xPosition,
                andPositionY: position.yPosition
            )
            emptyNode.resume = nil
            try self.historyGraph.addNode(emptyNode)
            self.delegate?.needReloadNode(
                atPosition: (yPosition: emptyNode.positionY, xPosition: emptyNode.positionX)
            )
        } catch let error as HistoryError {
            self.delegate?.needShowError(message: error.rawValue)
        } catch {
            self.delegate?.needShowError(message: "A Error Happend")
        }
    }
    
    func nodeWasSelectedInConnectingState(atPossition position: GridPosition, inNode node: HistoryNodeProtocol) {
        guard let lastTappedNodePosition = self.lastTappedNodePosition,
              let originNode = self.historyGraph.grid[
                    lastTappedNodePosition.yPosition,
                    lastTappedNodePosition.xPosition
                  ] as? HistoryNode,
              let destinyNode = self.historyGraph.grid[
                    position.yPosition,
                    position.xPosition
                  ] as? HistoryNode else {
            
            self.lastTappedNodePosition = position
            return
        }
        
        delegate?.needShowInputAlert(
            title: "Add Path",
            message: "Tap the path name",
            action: "OK", cancelAction: "Cancel",
            completion: { [weak self] (pathName) in
            do {
                try self?.historyGraph.addPath(fromNode: originNode, toNode: destinyNode, withTitle: pathName)
                self?.delegate?.needReloadConnection()
                self?.delegate?.needReloadNode(atPosition: (yPosition: destinyNode.positionY, xPosition: destinyNode.positionX))
            } catch let error as HistoryError {
                self?.delegate?.needShowError(message: error.rawValue)
            } catch {
                self?.delegate?.needShowError(message: "A Error Happend")
            }
        })
        
        self.lastTappedNodePosition = nil
    }
    
    private func nodeWasSelectedInAddingState(atPossition position: GridPosition, inNode node: HistoryNodeProtocol) {
        guard let originNode = node as? HistoryNode else {
            return
        }
        
        delegate?.needShowInputAlert(title: "Node Creation", message: "Dê um nome a ramificação", action: "OK", cancelAction: "Cancel", completion: { [weak self] (inputText) in
            do {
                let newNodeLine = originNode.positionY + 1
                guard let newNodeColumn = self?.historyGraph.grid.findPositionInLine(atIndex: newNodeLine, nearIndex: originNode.positionX) else {
                    return
                }
                
                let newNode = HistoryNode(
                    withResume: "Tap to edit",
                    text: "Tap to edit",
                    positionX: newNodeColumn,
                    andPositionY: newNodeLine
                )
                
                newNode.resume = nil
                
                try self?.historyGraph.addNode(newNode)
                try self?.historyGraph.addPath(fromNode: originNode, toNode: newNode, withTitle: inputText)
                self?.delegate?.needReloadNode(atPosition: (yPosition: newNode.positionY, xPosition: newNode.positionX))
            } catch let error as HistoryError {
                self?.delegate?.needShowError(message: error.rawValue)
            } catch {
                self?.delegate?.needShowError(message: "A Error Happend")
            }
        })
    }
    
    private func nodeWasSelectedInRemovingState(atPossition position: GridPosition, inNode node: HistoryNodeProtocol) {
        do {
            try historyGraph.removeNode(node)
            delegate?.needDeleteNode(atPositon: position)
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
            delegate?.needShowAlert(
                title: "Shortcut",
                message: shortcutNode.resume ?? shortcutNode.text ?? "Empty.",
                action: "Ir para card",
                cancelAction: "Fechar",
                completion: {
                    self.delegate?.needFocusNode(atPosition: ownerNodePosition)
                }
            )
            
            return
        }

        let controller = DetailsViewController()
        let navigation = UINavigationController(rootViewController: controller)
        controller.viewModel = DetailsViewModel(story: historyNode, graph: historyGraph)
        controller.viewModel?.transitionDelegate = self
        
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

extension HistoryGraphViewModel: HistoryGridDelegate {
    func removedShortcut(atPosition position: Position) {
        delegate?.needDeleteNode(atPositon: (yPosition: position.y, xPosition: position.x))
    }
    
    func addedColumToGrid(inPosition position: Int) {
        if position == self.historyGraph.grid.graphWidth - 1 {
            delegate?.needAppendColumn()
        } else {
            delegate?.needInsertColumn(atPosition: position)
        }
    }
    
    func addedLineToGrid(inPosition position: Int) {
        if position == self.historyGraph.grid.graphHeight - 1 {
            delegate?.needAppendLine()
        } else {
            delegate?.needInsertLine(atPosition: position)
        }
    }
    
    func movedNodeToPosition(fromPosition originPosition: Position, toPosition destinyPosition: Position) {
        delegate?.needMoveNode(
            fromPosition: (yPosition: originPosition.y, xPosition: originPosition.x),
            toPosition: (yPosition: destinyPosition.y, xPosition: destinyPosition.x)
        )
    }
    
    func addNode(inPosition position: Position) {
        let gridPosition = (xPosition: position.x, yPosition: position.y)
        delegate?.needDeleteNode(atPositon: gridPosition)
        delegate?.needAddNode(atPosition: gridPosition)
        delegate?.needFocusNode(atPosition: gridPosition)
    }
    
    func addShortcut(inPosition position: Position) {
        let gridPosition = (xPosition: position.x, yPosition: position.y)
        delegate?.needDeleteNode(atPositon: gridPosition)
        delegate?.needAddNode(atPosition: gridPosition)
        delegate?.needFocusNode(atPosition: gridPosition)
    }
    
    func sinpseWasEdited(to text: String) {
        historyGraph.sinopse = text
    }
}

extension HistoryGraphViewModel: DetailsViewModelTransitioningDelegate {
    func willCloseController() {
        delegate?.needReloadGraph()
    }
}
