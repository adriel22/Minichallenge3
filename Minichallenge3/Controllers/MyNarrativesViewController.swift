//
//  MyNarrativesViewController.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 10/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class MyNarrativesViewController: UIViewController {
    let viewModel = MyNarrativesViewModel()
    let customView = MyNarrativeViews()
    
    lazy var addButtonItem: UIBarButtonItem = {
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNarrative(_:)))
        
        return addButtonItem
    }()
    
    lazy var narrativesTableView: UITableView = {
        let tableView = customView.tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        
//        tableView.bounces = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "My Narratives"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = addButtonItem

        narrativesTableView.register(ExpandableTableViewCell.self, forCellReuseIdentifier: "cell")
        
//        let navigation = customView.navigationBar as CustomNavigation
//        navigation.addButton.action = #selector(addNarrative(_:))
//        navigation.addButton.target = self
    }
    
    override func loadView() {
        self.view = customView
    }
    
    @objc func addNarrative(_ sender: UIBarButtonItem) {
        //Alerta temporário
        let alert = UIAlertController(title: "Nova Narrativa", message: "Digite o nome da narrativa", preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Título da história"
        }
        let createAction = UIAlertAction(title: "Criar", style: .default) { _ in
            self.viewModel.addNarrative(withName: alert.textFields![0].text!, toTable: self.customView.tableView)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive) { _ in
        }
        
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        self.present(alert, animated: true, completion: nil)
        
    }

}
extension MyNarrativesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.loadCell(forTable: tableView, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellHeight(forTable: tableView, atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            viewModel.expandCell(forTable: tableView, atIndexPath: indexPath)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scroll = scrollView.contentOffset.y
////        customView.navigationBar.updateHeight(customView.navigationBar.maximunHeight - scroll)
//        customView.updateTableConstraint(scroll)
//    }

}
extension MyNarrativesViewController: MyNarrativesViewModelDelegate {
    func presentGraphView() {
        
    }

    func presentGraphView(withViewMode viewModel: HistoryGraphViewModel) {
        let graphView = HistoryGraphViewController()
        graphView.viewModel = viewModel
        navigationController?.pushViewController(graphView, animated: true)
    }
    
    func tableView() -> UITableView {
        return self.narrativesTableView
    }

}
