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

        addRamificationView.createButton.addTarget(self, action: #selector(buttonsAction(sender:)), for: .touchUpInside)
        addRamificationView.cancelButton.addTarget(self, action: #selector(buttonsAction(sender:)), for: .touchUpInside)

        addRamificationView.cardName.delegate = self

    }

    @objc func buttonsAction(sender: UIButton!) {
        if sender == self.addRamificationView.createButton {
            if let cardName = addRamificationView.cardName.text {
                viewModel.addNode(cardName)
            } else {
                return
            }

        }
        self.dismiss(animated: true, completion: nil)
    }

}
extension AddRamificationViewController: UITextFieldDelegate {

}
