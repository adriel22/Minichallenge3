//
//  CardViewProtocol.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

protocol CardViewProtocol: GraphItemView {
    func setup(withViewModel viewModel: HistoryNodeViewModel)
}
