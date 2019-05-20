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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        
        let tableView = customView.tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false

        tableView.register(ExpandableTableViewCell.self, forCellReuseIdentifier: "cell")
        
        let navigation = customView.navigationBar as CustomNavigation
        navigation.addButton.action = #selector(addNarrative(_:))
        navigation.addButton.target = self
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scroll = scrollView.contentOffset.y
        customView.navigationBar.updateHeight(customView.navigationBar.maximunHeight - scroll)
        customView.updateTableConstraint(scroll)
    }

}
extension MyNarrativesViewController: MyNarrativesViewModelDelegate {
    func presentGraphView() {
        let graphView = HistoryGraphViewController()
        self.present(graphView, animated: true, completion: nil)
    }

}
