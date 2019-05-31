//
//  PresentationCollectionViewDelegateDataSource.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 23/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class PresentationDelegateDataSource: NSObject {
    
    weak var viewModel: PresentationViewModelProtocol?
    weak var view: UIViewController?
    
    var selectedBranchesIndexes = [Int?]()
    
    init(viewModel: PresentationViewModelProtocol, view: PresentationViewController) {
        super.init()
        self.viewModel = viewModel
        self.view = view
        self.populateSelectedBranchesArray()
    }
    
    private func populateSelectedBranchesArray() {
        viewModel?.nodes.forEach { _ in
            self.selectedBranchesIndexes.append(nil)
        }
    }
    
}
