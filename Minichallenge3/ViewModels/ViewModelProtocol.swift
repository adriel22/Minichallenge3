//
//  ViewModelProtocol.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 16/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
import HistoryGraph

@objc protocol ViewModelProtocol {
    func update(_ view: UIViewController)
    @objc optional func setNavigationBarTitle(inNavigationItem item: UINavigationItem)
}

protocol PresentationViewModelProtocol: ViewModelProtocol {
    var graph: HistoryGraph { get }
    var rootNode: HistoryNode { get }
    var nodes: [HistoryNode] { get }
    
    func textForTableViewCell(atIndexPath indexPath: IndexPath, reuseIdentifier: String) -> String?
    func titleForCollectionViewCell(atTableViewIndexPath tableViewIndexPath: IndexPath, atCollectionViewIndexPath collectionViewIndexPath: IndexPath) -> String?
    func goToBranch(tableViewIndexPath: IndexPath, collectionViewIndexPath: IndexPath, updateView view: UIViewController)
}
