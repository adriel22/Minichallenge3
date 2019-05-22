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
        sinopseView.text = self.viewModel?.sinopse
        sinopseView.sinopseTextView.sinopseDelegate = self
       
        return sinopseView
    }()
    
    lazy var graphView: GraphView = {
        let graphView = GraphView()

        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.graphDelegate = self
        graphView.datasource = self

        return graphView
    }()
    
    lazy var toolBox: ToolboxView = {
        let toolBox = ToolboxView(frame: .zero)
        toolBox.delegate = self
        toolBox.translatesAutoresizingMaskIntoConstraints = false
        return toolBox
    }()
    
    var viewModel: HistoryGraphViewModel? {
        didSet {
            self.viewModel?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        setupView()
        setConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.viewWillDisappear()
    }
    
    func setupView() {
        view.addSubview(graphView)
        view.addSubview(sinopseView)
        view.addSubview(toolBox)
        
        view.backgroundColor = UIColor.white
        configureNavigationBar()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func configureNavigationBar() {
        let image = UIImage(named: "Play")
        title = viewModel?.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .done,
            target: self,
            action: #selector(playWasTapped(recognizer:))
        )
    }
    
    @objc func playWasTapped(recognizer: UITapGestureRecognizer) {
        viewModel?.playWasTapped()
    }
    
    func setConstraints() {
        let constraints = [
            graphView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            graphView.leftAnchor.constraint(equalTo: view.leftAnchor),
            graphView.rightAnchor.constraint(equalTo: view.rightAnchor),
            graphView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolBox.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            toolBox.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            toolBox.widthAnchor.constraint(equalToConstant: 34)
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
            let shortcut = ShortcutView()
            shortcut.datasource = self
            shortcut.delegate = self
            return shortcut
        }
    }
}

extension HistoryGraphViewController: GraphViewDatasource, GraphViewDelegate {
    func didLayoutNodes(forGraphView graphView: GraphView, withLoadType loadType: GraphViewDidLayoutType) {
        if let centerItemPosition = viewModel?.centerItemPosition {
            DispatchQueue.main.async {
                self.graphView.scrollToItem(atPosition: centerItemPosition, shakeItem: false)
            }
        }
    }
    
    func connectionButtonWasSelected(forGraphView graphView: GraphView, connection: Connection) {
        viewModel?.connectionButtonWasSelected(connection: connection)
    }
    
    func connectionButtonColor(forGraphView graphView: GraphView) -> UIColor? {
        return UIColor(color: .yellowWhite)
    }
    
    func itemWasSelectedAt(forGraphView graphView: GraphView, postion: GridPosition) {
        viewModel?.nodeWasSelected(atPossition: postion)
    }
    
    func connections(forGraphView graphView: GraphView, fromItemAtPosition itemPosition: GridPosition) -> [GridPosition] {
        
        return viewModel?.gridConnections(fromPositionGridPosition: itemPosition) ?? []
    }
    
    func gridSize(forGraphView graphView: GraphView) -> GridSize {
        return viewModel?.gridSize() ?? (width: 0, height: 0)
    }
    
    func gridNodeView(forGraphView graphView: GraphView, inPosition position: GridPosition) -> GraphItemView? {
        guard let cellViewModel = viewModel?.viewModelForNode(atPosition: position),
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
        return 100.0
    }
    
    func columnSpacing(forGraphView graphView: GraphView) -> CGFloat {
        return 10.0
    }
    
    func leftSpacing(forGraphView graphView: GraphView) -> CGFloat {
        return 100
    }
    
    func connectionsImage(forGraphView graphView: GraphView) -> UIImage? {
        return viewModel?.connectionButtonImage
    }
    
    func connectionWidth(forGraphView graphView: GraphView) -> CGFloat {
        return 3
    }
}

extension HistoryGraphViewController: HistoryGraphViewModelDelegate {
    func needReloadNode(atPosition position: GridPosition) {
        if let cardView = self.graphView.itemView(forPosition: position) as? CardViewProtocol,
           let viewModelForCard = viewModel?.viewModelForNode(atPosition: position) {
            
            cardView.setup(withViewModel: viewModelForCard)
        }
    }
    
    func needShowInputAlert(title: String, message: String, action: String, cancelAction: String, completion: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Tap the Ramification Name..."
        }
        alertController.addAction(UIAlertAction(title: action, style: .default, handler: { (_) in
            guard let inputText = alertController.textFields?.first?.text else {
                return
            }
            completion(inputText)
        }))
        alertController.addAction(UIAlertAction(title: cancelAction, style: .destructive, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func needShowAlert(title: String, message: String, action: String, cancelAction: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: action, style: .default, handler: { (_) in
            completion()
        }))
        alertController.addAction(UIAlertAction(title: cancelAction, style: .destructive, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func needAppendColumn() {
        self.graphView.appendColumn()
    }
    
    func needAppendLine() {
        self.graphView.appendLine()
    }
    
    func needInsertLine(atPosition position: Int) {
        self.graphView.addLine(inPosition: position)
    }
    
    func needInsertColumn(atPosition position: Int) {
        self.graphView.addColumn(inPosition: position)
    }
    
    func needAddNode(atPosition position: GridPosition) {
        self.graphView.addItem(atPositon: position)
    }
    
    func needMoveNode(fromPosition originPosition: GridPosition, toPosition destinyPosition: GridPosition) {
        self.graphView.removeItem(atPositon: originPosition)
        self.graphView.addItem(atPositon: destinyPosition)
    }
    
    func needReloadConnection() {
        self.graphView.reloadConnections()
    }
    
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
    
    func needDeleteNode(atPositon position: GridPosition) {
        self.graphView.removeItem(atPositon: position)
    }
}

extension HistoryGraphViewController: ShortcutViewDelegate, ShortcutViewDataSource {
    func tapInShortcut(_ shortcut: ShortcutView) {
        guard let position = self.graphView.position(forItemView: shortcut) else {
            return
        }
        viewModel?.nodeWasSelected(atPossition: position)
    }
    
    func widthLine(forShortcutView: ShortcutView) -> CGFloat {
        return 3
    }
    
    func hasParent(forShortcutView: ShortcutView) -> Bool {
        return true
    }
    
    func lineColor(forShortcutView: ShortcutView) -> UIColor {
        return UIColor(color: .gray)
    }
}

extension HistoryGraphViewController: SinopseDelegate {
    func textWasEdited(text: String) {
        
    }
}

extension HistoryGraphViewController: ToolboxViewDelegate {
    func tappedButtonAddNode() {
        viewModel?.optionWasSelected(atPositon: 0)
    }
    
    func tappedButtonTrash() {
        viewModel?.optionWasSelected(atPositon: 1)
    }
    
    func tappedButtonConnection() {
        viewModel?.optionWasSelected(atPositon: 2)
    }
    
    func tappedButtonCheck() {
        viewModel?.optionWasFinished()
    }
}
