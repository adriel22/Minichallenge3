//
//  ViewController.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 06/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var allHistoriesTableView: UITableView!
    
    /// Holds the value of which section is showing it's content in the table view
    var selected = -1
    
    typealias Story = (node: HistoryNode, isVisible: Bool)
    var stories: [Story] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(color: .purpleWhite)
        
        let node  = HistoryNode(withResume: "Teste", andText: "Tetse")
        (0..<5).forEach { _ in stories.append((node, false)) }
        
        allHistoriesTableView = UITableView(frame: .zero)
        allHistoriesTableView.backgroundColor = view.backgroundColor
        allHistoriesTableView.separatorStyle = .none
        allHistoriesTableView.dataSource = self
        allHistoriesTableView.delegate = self
        view.addSubview(allHistoriesTableView)
        
        allHistoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        allHistoriesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        allHistoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        allHistoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        allHistoriesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let nib = UINib(nibName: "ExpandableTableViewCell", bundle: .main)
        allHistoriesTableView.register(nib, forCellReuseIdentifier: "cell")
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Jurema, a aventureira da vida real"
    }
    
    func expandRow(from indexPath: IndexPath) {
        self.selected = indexPath.section
        stories[indexPath.section].isVisible = true
        allHistoriesTableView.insertRows(at: [indexPath], with: .automatic)
        allHistoriesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func collapseRow(from indexPath: IndexPath) {
        stories[indexPath.section].isVisible = false
        allHistoriesTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ExpandableTableViewHeaderView()
        headerView.label.text = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)?.uppercased()
        headerView.isCollapsed = !(section == selected)
        headerView.didTap = { sender in
            let toCollapseIndexPath = IndexPath(row: 0, section: self.selected)
            let toExpandIndexPath = IndexPath(row: 0, section: section)
            if self.selected == -1 { // Only expand (all sections collapsed)
                self.expandRow(from: toExpandIndexPath)
            } else if self.selected == section { // Only collapse (the section touched is the same as the showed on the table view)
                self.collapseRow(from: toCollapseIndexPath)
                self.selected = -1
            } else { // Collapse the showed row, and expand the touched one
                self.collapseRow(from: toCollapseIndexPath)
                self.expandRow(from: toExpandIndexPath)
            }
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories[section].isVisible ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ExpandableTableViewCell
        cell?.selectionStyle = .none
        cell?.label.text = stories[indexPath.section].node.resume
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
