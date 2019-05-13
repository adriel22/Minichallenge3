//
//  MyNarrativesView.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 10/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import  UIKit

class MyNarrativeViews: UIView, SetNavigation {
    let tableView: UITableView
    let navigationBar = UINavigationBar()

    override init(frame: CGRect) {
        tableView = UITableView()

        super.init(frame: frame)

        self.addSubview(tableView)
        setTable()

        setNavigation(in: tableView, withTitle: "Minhas Narrativas")

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableWidthConstraint = NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        let tableHeightConstraint = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        let tableCenterXConstraint = NSLayoutConstraint(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let tableCenterYConstraint = NSLayoutConstraint(item: tableView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraints([tableWidthConstraint, tableHeightConstraint, tableCenterXConstraint, tableCenterYConstraint])

    }

}
