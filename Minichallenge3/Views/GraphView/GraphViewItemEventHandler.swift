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
    
    var draggingInfo: (itemView: UIView?, originPosition: GridPosition?, dragType: GraphViewDragType?)
    var lastNearItems: [GraphItemView] = []
    var currentAutoScrollDirection: GraphViewBorderHover = .none

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
              let positionForItem = context.graphView.position(forItemView: itemView) else {
            return
        }
        
        let snapShortView = itemView.snapshot
        itemView.isHidden = true
        
        context.graphView.containerView.addSubview(snapShortView)
        self.draggingInfo = (snapShortView, positionForItem, nil)
        
        guard context.datasource.connections(forGraphView: context.graphView, fromItemAtPosition: positionForItem).count == 0,
              context.datasource.parents(forGraphView: context.graphView, fromItemAtPosition: positionForItem).count == 0 else {
                
            guard let itemCenterInContainer = itemView.parentLine?.convert(itemView.center, to: context.containerView) else {
                fatalError("The Item SuperView is mising")
            }
        
            snapShortView.center.x = location.x
            snapShortView.center.y = itemCenterInContainer.y
                
            self.draggingInfo.dragType = .inline
            
            return
        }
        
        snapShortView.center = location
        self.draggingInfo.dragType = .free
    }
    
    func longPressDidChange(
        recognizer: UILongPressGestureRecognizer,
        withContext context: Context,
        andLocationInContainer location: CGPoint) {
        
        guard let draggingView = draggingInfo.itemView,
              let dragType = self.draggingInfo.dragType else {
            return
        }
        
        guard let itemAtCurrentLocation = context.graphView.itemView(atPosition: location) else {
            switch dragType {
            case .free:
                draggingView.center = location
            case .inline:
                draggingView.center.x = location.x
            }
            return
        }
        
        //set the near items to be visible
        let nearItems = context.graphView.nearVisibleItems(atPosition: location, onlyEmptyItems: true)
        
        lastNearItems.set(atributte: \.backgroundColor, value: .clear)
        lastNearItems.set(atributte: \.alpha, value: 1)
        
        let numberOfNearItems = min(4, nearItems.count)
        
        lastNearItems = Array(nearItems[0..<numberOfNearItems])

        lastNearItems.set(atributte: \.backgroundColor, value: .green)
        lastNearItems.set(atributte: \.alpha, value: 0.3)
        
        let itemBoundsInContainer = itemAtCurrentLocation.convert(itemAtCurrentLocation.bounds, to: context.containerView)
        
        switch dragType {
        case .free:
            UIView.animate(withDuration: 0.2) {
                draggingView.frame = itemBoundsInContainer
            }
        case .inline:
            UIView.animate(withDuration: 0.2) {
                draggingView.frame.origin.x = itemBoundsInContainer.origin.x
            }
        }
//        autoScroll(recognizer: recognizer, withContext: context)
    }
    
    func autoScroll(recognizer: UILongPressGestureRecognizer,
                    withContext context: Context) {
      
        let fingerPosition = recognizer.location(in: context.graphView)
        
        var scrollOffset: CGPoint
        
        let autoScrollDirection = itemIsOnContainerBorders(atPoint: fingerPosition, borderMargin: 50)
        
        guard autoScrollDirection != self.currentAutoScrollDirection else {
            return
        }
        
        switch autoScrollDirection {
        case .left:
            scrollOffset = CGPoint(x: -50, y: 0)
        case .right:
            scrollOffset = CGPoint(x: 50, y: 0)
        case .bottom:
            scrollOffset = CGPoint(x: 0, y: 50)
        case .top:
            scrollOffset = CGPoint(x: 0, y: -50)
        default:
            scrollOffset = CGPoint.zero
        }
        
//        context.graphView.setContentOffset(context.graphView.contentOffset + scrollOffset, animated: true)
        
        context.graphView.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .repeat, animations: {
            let currentOffset = context.graphView.contentOffset
            print(currentOffset)
            context.graphView.contentOffset = currentOffset + scrollOffset
        }) { (_) in

        }
        
        self.currentAutoScrollDirection = autoScrollDirection

//        guard newScrollOffset.x < context.graphView.contentSize.width &&
//              newScrollOffset.y < context.graphView.contentSize.height else {
//            return
//        }
        
//        context.graphView.layer.removeAllAnimations()
//        UIView.animate(withDuration: 0.2) {
//            context.graphView.contentOffset = newScrollOffset
//        }
//        print(context.graphView.layer.animationKeys())
//        UIView.animate(withDuration: 0.2, delay: 0, options: .repeat, animations: {
//            context.graphView.contentOffset = newScrollOffset
//        }) { (_) in
//
//        }
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
    
    func itemIsOnContainerBorders(atPoint point: CGPoint, borderMargin: CGFloat) -> GraphViewBorderHover {
        guard let graphView = self.graphView else {
            return .none
        }
        
        if point.x > (graphView.bounds.maxX - borderMargin) {
            return .right
        }
        
        if point.x < (graphView.bounds.minX + borderMargin) {
            return .left
        }
        
        if point.y > (graphView.bounds.maxY - borderMargin) {
            return .bottom
        }
        
        if point.y < (graphView.bounds.minY + borderMargin) {
            return .top
        }
        return .none
    }
}

enum GraphViewBorderHover {
    case left, right, top, bottom, none
}

enum GraphViewDragType {
    case free, inline
}
