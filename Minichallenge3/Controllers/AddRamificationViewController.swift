//
//  AddRamificationViewController.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 16/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
import HistoryGraph

class AddRamificationViewController: UIViewController {
    let viewModel: AddRamificationViewModel
    let addRamificationView = AddRamificationView()
    let searchController = UISearchController(searchResultsController: nil)

    init(inGraph graph: HistoryGraph, withParentNode parent: HistoryNode) {
        viewModel = AddRamificationViewModel(inGraph: graph, withParent: parent)
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false

        self.view.addSubview(addRamificationView)
        
        viewModel.delegate = self

        addRamificationView.createButton.addTarget(self, action: #selector(buttonsAction(sender:)), for: .touchUpInside)
        addRamificationView.cancelButton.addTarget(self, action: #selector(buttonsAction(sender:)), for: .touchUpInside)

        addRamificationView.cardName.delegate = self
        
        NotificationCenter.default.addObserver(self.viewModel, selector: #selector(viewModel.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self.viewModel, selector: #selector(viewModel.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        addRamificationView.segmentedControl.addTarget(self.viewModel, action: #selector(viewModel.changedStateof(_:)), for: .allEvents)

        
        //Teste
        //
        //
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }

    @objc func buttonsAction(sender: UIButton!) {
        if sender == self.addRamificationView.createButton {
            
            switch addRamificationView.state {
            case .create:
                if let cardName = addRamificationView.cardName.text {
                    viewModel.addNode(cardName)
                }
            case .reuse:
                if let cardName = addRamificationView.searchBar.text {
                    viewModel.reuseNode(cardName)
//                    self.graph
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
extension AddRamificationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addRamificationView.cardName.resignFirstResponder()
        return true
    }

//    endEd
}
extension AddRamificationViewController: AddRamificationViewModelDelegate {
    func updateViewTostate(_ state: RamificationViewStates) {
        self.addRamificationView.changeState(toState: state)
    }
    
    func hideKeyboard(_ notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func showKeyboard(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = -keyboardSize.height
        } 
    }

}

extension AddRamificationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        searchController.
    }
    
}
