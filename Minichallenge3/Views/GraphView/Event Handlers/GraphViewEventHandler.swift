//
//  GraphViewEventHandler.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 19/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class GraphViewEventHandler: NSObject {
    weak var graphView: GraphView?
    
    init(withGraphView graphView: GraphView) {
        super.init()
        self.graphView = graphView

        graphView.delegate = self
        graphView.maximumZoomScale = 2.0
        graphView.minimumZoomScale = 0.3
    }
}

extension GraphViewEventHandler: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return graphView?.containerView
    }
}
