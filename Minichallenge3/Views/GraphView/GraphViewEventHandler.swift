//
//  GraphViewItemEventHandler.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class GraphViewItemEventHandler {
    weak var itemView: GraphItemView?
    weak var delegate: GraphViewDelegate?
    var itemPosition: GridPosition
    
    init(withItemView itemView: GraphItemView, inPosition position: GridPosition, andGraphDelegate delegate: GraphViewDelegate?) {
        self.delegate = delegate
        self.itemView = itemView
        self.itemPosition = position
        
        setupGestures(toItem: itemView)
    }
    
    func setupGestures(toItem itemView: GraphItemView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(itemWasTapped(recognizer:)))
        itemView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func itemWasTapped(recognizer: UITapGestureRecognizer) {
        delegate?.itemWasSelectedAt(postion: itemPosition)
    }
}
