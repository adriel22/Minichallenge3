//
//  HistoryGraphViewModelDelegate.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

protocol HistoryGraphViewModelDelegate: AnyObject {
    func needReloadGraph()
    func needShowViewController(_ viewController: UIViewController)
    func needFocusNode(atPosition position: GridPosition)
}
