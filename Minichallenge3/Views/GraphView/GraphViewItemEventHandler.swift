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
    
    var draggingInfo: (itemView: UIView?, originPosition: GridPosition?)
    var lastNearItems: [GraphItemView] = []

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
        guard let graphView = self.graphView,
              let graphViewDatasource = graphView.datasource else {
            return
        }
        
        let context: Context = (
            graphView: graphView,
            containerView: graphView.containerView,
            datasource: graphViewDatasource
        )
        
        let pressPosition = recognizer.location(in: graphView.containerView)
        
        switch recognizer.state {
        case .began:
            longPressDidBegin(recognizer: recognizer, withContext: context, andLocationInContainer: pressPosition)
        case .changed:
            longPressDidChange(recognizer: recognizer, withContext: context, andLocationInContainer: pressPosition)
        case .ended, .cancelled, .failed:
            longPressDidEnd(recognizer: recognizer, withContext: context, andLocationInContainer: pressPosition)
        default:
            break
        }
    }
    
    func longPressDidBegin(
        recognizer: UILongPressGestureRecognizer,
        withContext context: Context,
        andLocationInContainer location: CGPoint) {
        
        guard let itemView = self.itemView,
              let positionForItem = context.graphView.position(forItemView: itemView),
              context.datasource.connections(forGraphView: context.graphView, fromItemAtPosition: positionForItem).count == 0,
              context.datasource.parents(forGraphView: context.graphView, fromItemAtPosition: positionForItem).count == 0 else {
            return
        }
        
        let snapShortView = itemView.snapshot
        
        itemView.isHidden = true
        snapShortView.center = location
        
        context.graphView.containerView.addSubview(snapShortView)
        self.draggingInfo = (snapShortView, positionForItem)
    }
    
    func longPressDidChange(
        recognizer: UILongPressGestureRecognizer,
        withContext context: Context,
        andLocationInContainer location: CGPoint) {
        
        guard let draggingView = draggingInfo.itemView else {
            return
        }
        
        guard let itemAtCurrentLocation = context.graphView.itemView(atPosition: location) else {
            draggingView.center = location
            return
        }
        
        let nearItems = context.graphView.nearVisibleItems(atPosition: location, onlyEmptyItems: true)
        
        lastNearItems.set(atributte: \.backgroundColor, value: .clear)
        lastNearItems.set(atributte: \.alpha, value: 1)
        
        let numberOfNearItems = min(4, nearItems.count)
        
        lastNearItems = Array(nearItems[0..<numberOfNearItems])
        let itemBoundsInContainer = itemAtCurrentLocation.convert(itemAtCurrentLocation.bounds, to: context.containerView)

        lastNearItems.set(atributte: \.backgroundColor, value: .green)
        lastNearItems.set(atributte: \.alpha, value: 0.3)
        
        UIView.animate(withDuration: 0.2) {
            draggingView.frame = itemBoundsInContainer
        }
    }
    
    func longPressDidEnd(
        recognizer: UILongPressGestureRecognizer,
        withContext context: Context,
        andLocationInContainer location: CGPoint) {
        
        lastNearItems.set(atributte: \.backgroundColor, value: .clear)
        lastNearItems.set(atributte: \.alpha, value: 1)
        draggingInfo.itemView?.removeFromSuperview()
        self.itemView?.isHidden = false
        
        guard let itemView = self.itemView,
              let positionForItem = context.graphView.position(forItemView: itemView),
              let dragOriginPosition = self.draggingInfo.originPosition,
              let originItemView = context.graphView.itemView(forPosition: dragOriginPosition) else {
            return
        }
        
        guard let destinyItemView = context.graphView.itemView(atPosition: location) as? GraphItemEmptyView,
              let gridPositionForDestityItem = context.graphView.position(forItemView: destinyItemView) else {
            return
        }
        
        let replacingDispatchGroup = DispatchGroup()
        
        replacingDispatchGroup.enter()
        context.graphView.graphOperator.replace(
            items: (
                currentItem: originItemView,
                newItem: GraphItemEmptyView()
            ),
            atPosition: positionForItem,
            withContext: context,
            completion: {
                replacingDispatchGroup.leave()
            }
        )
        
        replacingDispatchGroup.enter()
        context.graphView.graphOperator.replace(
            items: (
                currentItem: destinyItemView,
                newItem: originItemView
            ),
            atPosition: gridPositionForDestityItem,
            withContext: context,
            completion: {
                replacingDispatchGroup.leave()
            }
        )
        
        replacingDispatchGroup.notify(queue: .main) {
            self.delegate?.itemWasDragged(
                fromPosition: dragOriginPosition,
                toPosition: gridPositionForDestityItem
            )
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
