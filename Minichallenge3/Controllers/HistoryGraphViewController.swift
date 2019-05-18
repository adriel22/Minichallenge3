//
//  HistoryGraphViewController.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
import HistoryGraph

class HistoryGraphViewController: UIViewController {
    lazy var sinopseView: SinopseView = {
        let sinopseView = SinopseView()
        sinopseView.text = self.viewModel.sinopse
       
        return sinopseView
    }()
    
    lazy var graphView: GraphView = {
        let graphView = GraphView()

        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.datasource = self

        return graphView
    }()
    
    lazy var viewModel: HistoryGraphViewModel = {
        let viewModel = HistoryGraphViewModel(withHistoryGraph: getFirstHistory())
        
        viewModel.delegate = self
        
        return viewModel
    }()
    
    override func viewDidLoad() {
        setupView()
        setConstraints()
        
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
//            self.viewModel.optionWasSelected(atPositon: 1)
//            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (_) in
//                self.viewModel.optionWasFinished()
//            })
//        }
    }
    
    func setupView() {
        view.addSubview(sinopseView)
        view.addSubview(graphView)
        
        view.backgroundColor = UIColor.white
    }
    
    func setConstraints() {
        let constraints = [
            graphView.topAnchor.constraint(equalTo: sinopseView.bottomAnchor, constant: 10),
            graphView.leftAnchor.constraint(equalTo: view.leftAnchor),
            graphView.rightAnchor.constraint(equalTo: view.rightAnchor),
            graphView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func getFirstHistory() -> HistoryGraph {
        let history = RAMHistoryDAO()
        return history.get(elementWithID: 0)
    }
}

extension HistoryGraphViewController: GraphViewDatasource {
    func connections(forGraphView graphView: GraphView, fromItemAtPosition itemPosition: GridPosition) -> [GridPosition] {
        return viewModel.gridConnections(fromPositionGridPosition: itemPosition)
    }
    
    func gridSize(forGraphView graphView: GraphView) -> GridSize {
        return viewModel.gridSize()
    }
    
    func gridNodeView(forGraphView graphView: GraphView, inPosition position: GridPosition) -> GraphItemView? {
        guard let cellViewModel = viewModel.viewModelForNode(atPosition: position) else {
       
            return nil
        }

        let view = CardView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setup(withViewModel: cellViewModel)

        return view
    }
    
    func columnWidth(forGraphView graphView: GraphView, inXPosition xPosition: Int) -> CGFloat {
        return 200
    }
    
    func lineSpacing(forGraphView graphView: GraphView) -> CGFloat {
        return 50.0
    }
    
    func columnSpacing(forGraphView graphView: GraphView) -> CGFloat {
        return 10.0
    }
    
    func leftSpacing(forGraphView graphView: GraphView) -> CGFloat {
        return 100
    }
}

extension HistoryGraphViewController: HistoryGraphViewModelDelegate {
    func needReloadGraph() {
        self.graphView.reloadData()
    }
}
