//
//  ViewController.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 06/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
import HistoryGraph

class ViewController: UIViewController {

    @IBOutlet weak var graphView: GraphView!

    override func viewDidLoad() {
        super.viewDidLoad()

        graphView.datasource = self
    }
}

extension ViewController: GraphViewDatasource {
    func gridSize(forGraphView graphView: GraphView) -> GridSize {
        return (width: 10, height: 10)
    }

    func gridNodeView(forGraphView graphView: GraphView, inPosition position: GridPosition) -> UIView? {

        if position.xPosition == position.yPosition || position.xPosition == 0 || position.xPosition == 9 || position.yPosition == 9 {
            return nil
        }

        let view = UIView.init()
        view.backgroundColor = UIColor.red
        view.translatesAutoresizingMaskIntoConstraints = false

        view.heightAnchor.constraint(equalToConstant: CGFloat.random(in: 100..<200)).isActive = true

        return view
    }

    func columnWidth(forGraphView graphView: GraphView, inXPosition xPosition: Int) -> CGFloat {
        return 200
    }

    func lineSpacing(forGraphView graphView: GraphView) -> CGFloat {
        return 10.0
    }

    func columnSpacing(forGraphView graphView: GraphView) -> CGFloat {
        return 10.0
    }
}
