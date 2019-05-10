//
//  ViewController.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 06/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var allHistoriesTableView: UITableView!
    var selected = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        allHistoriesTableView = UITableView(frame: .zero)
        allHistoriesTableView.dataSource = self
        allHistoriesTableView.delegate = self
        view.addSubview(allHistoriesTableView)
        
        allHistoriesTableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
            make.leading.equalTo(view)
        }
        
        let nib = UINib(nibName: "ExpandableTableViewCell", bundle: .main)
        allHistoriesTableView.register(nib, forCellReuseIdentifier: "cell")
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Jurema, a aventureira da vida real"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ExpandableTableViewHeaderView()
        headerView.label.text = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
        headerView.isCollapsed = !(section == selected)
        headerView.didTap = { sender in
            let oldSelected = 
            self.selected = headerView.isCollapsed ? section : -1
            
//            UIView.animate(withDuration: 0.7,
//                           delay: 0,
//                           usingSpringWithDamping: 0.7,
//                           initialSpringVelocity: 0.7,
//                           options: [.allowUserInteraction, .layoutSubviews, .curveEaseInOut],
//                           animations: {
//                tableView.reloadData()
//            })
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selected > -1 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ExpandableTableViewCell
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == selected {
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            let tableHeight = tableView.bounds.height
            let sectionHeight = CGFloat(48)
            let numberOfSections = CGFloat(tableView.numberOfSections)
            let preferredRowHeight = tableHeight - (sectionHeight * numberOfSections) - statusBarHeight
            if preferredRowHeight < tableHeight/2 {
                return tableHeight/2
            } else {
                return preferredRowHeight
            }
        }
        return 0
    }
}
