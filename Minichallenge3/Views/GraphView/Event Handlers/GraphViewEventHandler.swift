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
    var currentZoomScale: CGFloat = 1
    
    init(withGraphView graphView: GraphView) {
        super.init()
        self.graphView = graphView

        graphView.delegate = self
        graphView.maximumZoomScale = 2.0
        graphView.minimumZoomScale = 0.3
    }
    
    func changeZoomScale(to scale: CGFloat?) {
        guard let scale = scale else {
            return
        }
        
        graphView?.zoomScale = scale
    }
}

extension GraphViewEventHandler: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return graphView?.containerView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.currentZoomScale = scale
    }
}
