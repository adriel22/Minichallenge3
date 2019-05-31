//
//  GraphViewItemEventHandler.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class GraphViewItemEventHandler {
    weak var graphView: GraphView?
    weak var itemView: GraphItemView?
    weak var delegate: GraphViewDelegate?
    
    var draggingInfo: (itemView: GraphItemView?, originPosition: GridPosition?)

    init(
        withItemView itemView: GraphItemView,
        andGraphDelegate delegate: GraphViewDelegate?,
        atGraphView graphView: GraphView) {

        self.delegate = delegate
        self.itemView = itemView
        self.graphView = graphView
        
        setupGestures(toItem: itemView)
    }
    
    func setupGestures(toItem itemView: GraphItemView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(itemWasTapped(recognizer:)))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(itemWasLongPressed(recognizer:)))
        itemView.addGestureRecognizer(tapGestureRecognizer)
        itemView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func itemWasLongPressed(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            guard let graphView = self.graphView,
                  let graphViewDatasource = graphView.datasource,
                  let itemView = self.itemView,
                  let positionForItem = graphView.position(forItemView: itemView),
                  graphViewDatasource.connections(forGraphView: graphView, fromItemAtPosition: positionForItem).count == 0,
                  graphViewDatasource.parents(forGraphView: graphView, fromItemAtPosition: positionForItem).count == 0 else {
                return
            }
            
            let placeHolder = GraphItemEmptyView()
            let pressPosition = recognizer.location(in: graphView.containerView)
            
            graphView.graphOperator.replace(
                items: (
                    currentItem: itemView,
                    newItem: placeHolder
                ),
                atPosition: positionForItem,
                withContext: (
                    graphView: graphView,
                    containerView: graphView.containerView,
                    datasource: graphViewDatasource
                ),
                completion: { [weak self] in
                    self?.draggingInfo = (itemView, positionForItem)
                    itemView.removeMiddleConstraints()
                    itemView.translatesAutoresizingMaskIntoConstraints = true
                    itemView.center = pressPosition
                    graphView.containerView.addSubview(itemView)
                    graphView.isScrollEnabled = false
                    graphView.containerView.touchesMovedCompletion = { (_) in
                        
                    }
                   
                    let dragGestureRecognizer = UIPanGestureRecognizer(
                        target: self,
                        action: #selector(self?.itemWasDragged(recognizer:))
                    )
                    itemView.addGestureRecognizer(dragGestureRecognizer)
                }
            )
        default:
            break
        }
    }
    
    @objc func itemWasDragged(recognizer: UIPanGestureRecognizer) {
        guard let draggingItemView = self.draggingInfo.itemView else {
            return
        }
        
        let dragPosition = recognizer.location(in: graphView?.containerView)
        
        switch recognizer.state {
        case .changed:
            guard let itemView = graphView?.itemView(atPosition: dragPosition) as? GraphItemEmptyView else {
                
                draggingItemView.center = dragPosition
                return
            }
            let itemViewFrameInContainer = itemView.convert(itemView.bounds, to: self.graphView?.containerView)
            
            UIView.animate(withDuration: 0.1) {
                draggingItemView.frame = itemViewFrameInContainer
            }
        case .failed, .cancelled, .ended:
            
            guard let graphView = self.graphView,
                  let graphViewDatasource = graphView.datasource else {
                return
            }
            
            guard let itemView = graphView.itemView(atPosition: dragPosition) as? GraphItemEmptyView,
                  let positionForItem = graphView.position(forItemView: itemView) else {
                    
                guard let dragOriginPosition = self.draggingInfo.originPosition,
                      let originItemView = self.graphView?.itemView(forPosition: dragOriginPosition) as? GraphItemEmptyView else {
                        return
                    }
                
                    let itemViewFrameInContainer = originItemView.convert(originItemView.bounds, to: self.graphView?.containerView)
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        draggingItemView.frame = itemViewFrameInContainer
                    }, completion: { (_) in
                        self.draggingInfo.itemView = nil
                        self.graphView?.graphOperator.replace(
                            items: (
                                currentItem: originItemView,
                                newItem: draggingItemView
                            ),
                            atPosition: dragOriginPosition,
                            withContext: (
                                graphView: graphView,
                                containerView: graphView.containerView,
                                datasource: graphViewDatasource
                            ),
                            completion: {}
                        )
                    })
                    
                return
            }
            
            let itemViewFrameInContainer = itemView.convert(itemView.bounds, to: graphView.containerView)
            
            UIView.animate(withDuration: 0.2, animations: {
                draggingItemView.frame = itemViewFrameInContainer
            }, completion: { (_) in
                self.draggingInfo.itemView = nil
                graphView.graphOperator.replace(
                    items: (
                        currentItem: itemView,
                        newItem: draggingItemView
                    ),
                    atPosition: positionForItem,
                    withContext: (
                        graphView: graphView,
                        containerView: graphView.containerView,
                        datasource: graphViewDatasource
                    ),
                    completion: { [weak self] in
                        guard let draggedItemOrigin = self?.draggingInfo.originPosition else {
                            return
                        }
                        self?.delegate?.itemWasDragged(fromPosition: draggedItemOrigin, toPosition: positionForItem)
                    }
                )
            })
        default:
            break
        }
        
    }
    
    @objc func itemWasTapped(recognizer: UITapGestureRecognizer) {
        guard let graphView = self.graphView,
              let itemView = self.itemView,
              let positionForItem = graphView.position(forItemView: itemView) else {
            return
        }

        delegate?.itemWasSelectedAt(forGraphView: graphView, postion: positionForItem)
    }
}
