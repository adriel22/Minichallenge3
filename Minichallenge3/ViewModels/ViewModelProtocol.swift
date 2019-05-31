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
    @objc optional func setNavigationBarTitle(in item: UINavigationItem)
}

protocol DetailsViewModelProtocol: ViewModelProtocol {
    var delegate: DetailsViewModelDelegate? { get set }
    var animationDelegate: DetailsViewModelAnimationDelegate? { get set }
    var transitionDelegate: DetailsViewModelTransitioningDelegate? { get set }
    
    var graph: HistoryGraph { get }
    var story: HistoryNode { get }
    
    func titleForCollectionViewCell(at indexPath: IndexPath) -> String?
    func textUpdated(with text: String, in node: HistoryNode)
    
    func addBranch()
    func goOn(branchIndex: Int)
    func goBack()
    func willCloseController()
}

protocol PresentationViewModelProtocol: ViewModelProtocol {
    var graph: HistoryGraph { get }
    var rootNode: HistoryNode { get }
    var nodes: [HistoryNode] { get }
    
    func updateHeaderTitle(with title: String?, in view: UIViewController)
    func titleForHeader(at section: Int) -> String?
    func textForHistoryNode(at section: Int) -> String?
    func titleForCollectionViewCell(at section: Int, at collectionViewIndexPath: IndexPath) -> String?
    
    func forwardBranch(section: Int, indexPath: IndexPath, in view: UIViewController)
    func undo(in view: UIViewController)
    
}
