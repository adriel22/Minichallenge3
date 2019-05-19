//
//  NodePresentationTableViewCell.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 16/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class NodePresentationTableViewCell: UITableViewCell {

    var nodeView: NodeDetailsView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if reuseIdentifier == "rootCell" {
            nodeView = NodeDetailsView(type: .rootCell)
        } else {
            nodeView = NodeDetailsView(type: .cell)
        }
        contentView.addSubview(nodeView)
        setConstraints()
    }
    
    func setConstraints() {
        nodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nodeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nodeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nodeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nodeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
