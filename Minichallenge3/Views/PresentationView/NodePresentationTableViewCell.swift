//
//  NodePresentationTableViewCell.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 16/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class NodePresentationView: UIView {

    lazy var headerView: ExpandableTableViewHeaderView! = ExpandableTableViewHeaderView()
    var nodeView: NodeDetailsView!
    
    init(frame: CGRect = .zero, type: NodeDetailsView.NodeType) {
        super.init(frame: frame)
        addSubview(headerView)
        nodeView = NodeDetailsView(type: type)
        addSubview(nodeView)
        setConstraints()
    }
    
    func setConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: nodeView.collectionHeight)
        ])
        
        nodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nodeView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            nodeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nodeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            nodeView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }    
}

class RootNodePresentationView: NodePresentationView {
    
    lazy var root: NodePresentationView! = NodePresentationView(type: .cell)
    
    init(frame: CGRect = .zero) {
        super.init(frame: frame, type: .rootCell)
    }
    
    override func setConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: nodeView.collectionHeight)
        ])
        
        nodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nodeView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            nodeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nodeView.bottomAnchor.constraint(equalTo: centerYAnchor),
            nodeView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        root.translatesAutoresizingMaskIntoConstraints = false
        if root.superview == nil { addSubview(root) }
        NSLayoutConstraint.activate([
            root.topAnchor.constraint(equalTo: centerYAnchor),
            root.leadingAnchor.constraint(equalTo: leadingAnchor),
            root.trailingAnchor.constraint(equalTo: trailingAnchor),
            root.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
