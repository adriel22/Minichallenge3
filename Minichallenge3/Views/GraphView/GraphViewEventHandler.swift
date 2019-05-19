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
    var itemPosition: GridPosition

    init(
        withItemView itemView: GraphItemView,
        inPosition position: GridPosition,
        andGraphDelegate delegate: GraphViewDelegate?,
        atGraphView graphView: GraphView) {

        self.delegate = delegate
        self.itemView = itemView
        self.itemPosition = position
        self.graphView = graphView
        
        setupGestures(toItem: itemView)
    }
    
    func setupGestures(toItem itemView: GraphItemView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(itemWasTapped(recognizer:)))
        itemView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func itemWasTapped(recognizer: UITapGestureRecognizer) {
        guard let graphView = self.graphView else {
            return
        }

        delegate?.itemWasSelectedAt(forGraphView: graphView, postion: itemPosition)
    }
}
