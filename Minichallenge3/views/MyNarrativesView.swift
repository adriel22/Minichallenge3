//
//  MyNarrativesView.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 10/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import  UIKit

class MyNarrativeViews: UIView {
    let tableView: UITableView
    var navigationBar: CustomNavigation
    private var tableTopConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        tableView = UITableView()
        navigationBar = CustomNavigation("Minhas Narrativas")

        super.init(frame: frame)

        self.addSubview(tableView)
        self.addSubview(navigationBar)
        setTable()
        self.backgroundColor = UIColor.red
//        navigationBar.addb
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableWidthConstraint = NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        let tableCenterXConstraint = NSLayoutConstraint(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        tableTopConstraint = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: navigationBar.height + 10)
        let tableBottomConstraint = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraints([tableWidthConstraint, tableBottomConstraint, tableCenterXConstraint, tableTopConstraint])
    }

    func updateTableConstraint(_ height: CGFloat) {
        if navigationBar.height > navigationBar.minimunHeight && navigationBar.height < navigationBar.maximunHeight {
            self.removeConstraint(tableTopConstraint)
            tableTopConstraint = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: navigationBar.maximunHeight - height)
            self.addConstraint(tableTopConstraint)
            self.updateConstraints()
        }
    }

}
