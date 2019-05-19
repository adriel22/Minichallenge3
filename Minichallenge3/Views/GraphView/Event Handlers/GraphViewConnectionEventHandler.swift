//
//  GraphViewConnectionEventHandler.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 19/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class GraphViewConnectionEventHandler {
    weak var graphView: GraphView?
    weak var connectionView: UIView?
    weak var delegate: GraphViewDelegate?
    var connectionPosition: Connection
    
    init(
        withConnectionView connectionView: UIView,
        andDelegate delegate: GraphViewDelegate,
        inConnectionPostion connectionPosition: Connection,
        andGraphView graphView: GraphView) {

        self.connectionView = connectionView
        self.delegate = delegate
        self.connectionPosition = connectionPosition
        self.graphView = graphView
        
        setupGestures(toView: connectionView)
    }
    
    func setupGestures(toView view: UIView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(itemWasTapped(recognizer:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func itemWasTapped(recognizer: UITapGestureRecognizer) {
        guard let graphView = self.graphView else {
            return
        }
        
        delegate?.connectionButtonWasSelected(forGraphView: graphView, connection: connectionPosition)
    }
}
