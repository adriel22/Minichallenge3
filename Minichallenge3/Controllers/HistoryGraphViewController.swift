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
        graphView.graphDelegate = self

        return graphView
    }()
    
    lazy var viewModel: HistoryGraphViewModel = {
        let viewModel = HistoryGraphViewModel(withHistoryGraph: getFirstHistory(), withIdentifier: 0)
        
        viewModel.delegate = self
        
        return viewModel
    }()
    
    override func viewDidLoad() {
        setupView()
        setConstraints()
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
            self.viewModel.optionWasSelected(atPositon: 1)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.viewWillDisappear()
    }
    
    func setupView() {
        view.addSubview(graphView)
        view.addSubview(sinopseView)
        
        view.backgroundColor = UIColor.white
    }
    
    func configureNavigationBar() {
        let image = UIImage(named: "Play")
        title = viewModel.sinopse
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .done,
            target: self,
            action: #selector(playWasTapped(recognizer:))
        )
    }
    
    @objc func playWasTapped(recognizer: UITapGestureRecognizer) {
        viewModel.playWasTapped()
    }
    
    func setConstraints() {
        let constraints = [
            graphView.topAnchor.constraint(equalTo: view.topAnchor),
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
    
    func cardForNodeType(_ nodeType: HistoryGraphViewModelNodeType) -> CardViewProtocol {
        switch nodeType {
        case .normal:
            return CardView()
        case .shortcut:
            return CardView()
        }
    }
}

extension HistoryGraphViewController: GraphViewDatasource, GraphViewDelegate {
    func itemWasSelectedAt(postion: GridPosition) {
        viewModel.nodeWasSelected(atPossition: postion)
    }
    
    func connections(forGraphView graphView: GraphView, fromItemAtPosition itemPosition: GridPosition) -> [GridPosition] {
        return viewModel.gridConnections(fromPositionGridPosition: itemPosition)
    }
    
    func gridSize(forGraphView graphView: GraphView) -> GridSize {
        return viewModel.gridSize()
    }
    
    func gridNodeView(forGraphView graphView: GraphView, inPosition position: GridPosition) -> GraphItemView? {
        guard let cellViewModel = viewModel.viewModelForNode(atPosition: position),
              let nodeType = cellViewModel.nodeType else {
       
            return nil
        }

        let card = cardForNodeType(nodeType)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.setup(withViewModel: cellViewModel)

        return card
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
    func needShowViewController(_ viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func needReloadGraph() {
        self.graphView.reloadData()
    }
    
    func needFocusNode(atPosition position: GridPosition) {
        self.graphView.scrollToItem(atPosition: position)
    }
    
    func needShowError(message: String) {
        print(message)
    }
    
    func nodeDeletionFinished(atPositon position: GridPosition) {
        self.graphView.removeItem(atPositon: position)
    }
}
