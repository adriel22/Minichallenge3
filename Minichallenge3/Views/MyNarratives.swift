//
//  MyNarratives.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 09/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import UIKit

class MyNarratives: UIView {
    let tableView: UITableView
    let navBar: UINavigationBar
    private let height: CGFloat = 75

    override init(frame: CGRect) {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.rowHeight = 50
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))

        super.init(frame: frame)

        self.backgroundColor = UIColor.white

        setUpConstraint()

        navBar.backgroundColor = UIColor.blue
        navBar.prefersLargeTitles = true
        
        let navItem = UINavigationItem()
        navItem.title = "Title"
        navBar.items = [navItem]
//        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
//        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
//        navItem.largeTitleDisplayMode = .automatic
        self.addSubview(navBar)
        self.tableView.contentInsetAdjustmentBehavior = .never
        
        self.addSubview(tableView)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpConstraint() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableWidth = NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        let tableHeight = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        let tableCenterX = NSLayoutConstraint(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let tableCenterY = NSLayoutConstraint(item: tableView, attribute: .topMargin, relatedBy: .equal, toItem: navBar, attribute: .topMargin, multiplier: 1, constant: 0)
        self.addConstraints([tableWidth, tableHeight, tableCenterX, tableCenterY])
    }
}
