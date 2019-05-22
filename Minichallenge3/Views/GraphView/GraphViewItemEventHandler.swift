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
      
        itemView.addGestureRecognizer(tapGestureRecognizer)
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
