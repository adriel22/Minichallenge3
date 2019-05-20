//
//  PresentationViewController.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 16/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class PresentationViewController: UIViewController {
    
    lazy var storyTableView: UITableView! = UITableView(frame: .zero)
    lazy var selectedBranchesIndexes: [Int: Int] = [:]
    lazy var rowHeight = UIScreen.main.bounds.height/3.5
    
    var viewModel: PresentationViewModelProtocol? {
        didSet {
            viewModel?.update(self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        setDelegatesAndDataSources()
        view.addSubview(storyTableView)
        
        configureNavigationBar()
        setConstraints()
    }
    
    func configureNavigationBar() {
        viewModel?.setNavigationBarTitle?(inNavigationItem: navigationItem)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                            target: self,
                                                            action: #selector(dismiss(_:)))
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTable() {
        storyTableView.backgroundColor = UIColor(color: .purpleWhite)
        storyTableView.register(NodePresentationTableViewCell.self, forCellReuseIdentifier: "cell")
        storyTableView.register(NodePresentationTableViewCell.self, forCellReuseIdentifier: "rootCell")
    }
    
    func setDelegatesAndDataSources() {
        storyTableView.delegate = self
        storyTableView.dataSource = self
    }
    
    func setConstraints() {
        storyTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storyTableView.topAnchor.constraint(equalTo: view.topAnchor),
            storyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    @objc func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

extension PresentationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 2 }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.nodes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let index = section - 1
        if section == 0 { return nil }
        let upperNode = viewModel?.nodes[index]
        if let selectedBranchIndex = selectedBranchesIndexes[index] {
            return upperNode?.connections[selectedBranchIndex].title
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = (indexPath.section == 0 && indexPath.row == 0) ? "rootCell" : "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NodePresentationTableViewCell
        let text = viewModel?.textForTableViewCell(atIndexPath: indexPath, reuseIdentifier: reuseIdentifier)
        cell?.nodeView.reload(withText: text)
        cell?.nodeView.dataSource = self
        cell?.nodeView.collectionDelegate = self
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func isRootNodeRow(atIndexPath indexPath: IndexPath) -> Bool {
        return indexPath.row == 0 && indexPath.section == 0
    }
    
}

extension PresentationViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tableViewIndexPath = getTableViewIndexPath(for: collectionView, insideCellOf: storyTableView) {
            return viewModel?.nodes[tableViewIndexPath.section].connections.count ?? 0
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? BranchCollectionViewCell
        guard let tableViewIndexPath = getTableViewIndexPath(for: collectionView, insideCellOf: storyTableView) else { return cell! }
        cell?.title = viewModel?.titleForCollectionViewCell(atTableViewIndexPath: tableViewIndexPath, atCollectionViewIndexPath: indexPath)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let displayedCell = cell as? BranchCollectionViewCell
        guard let tableViewIndexPath = getTableViewIndexPath(for: collectionView, insideCellOf: storyTableView) else { return }
        if !isRootNodeRow(atIndexPath: tableViewIndexPath) {
            if indexPath.item == selectedBranchesIndexes[tableViewIndexPath.section] {
                displayedCell?.select()
            } else {
                displayedCell?.deselect()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tableViewIndexPath = getTableViewIndexPath(for: collectionView, insideCellOf: storyTableView) {
            let oldSelectedBranch = selectedBranchesIndexes[tableViewIndexPath.section]
            viewModel?.goToBranch(tableViewIndexPath: tableViewIndexPath, collectionViewIndexPath: indexPath, updateView: self)
            if let oldSelectedBranch = oldSelectedBranch {
                let oldIndexPath = IndexPath(item: oldSelectedBranch, section: 0)
                let oldSelectedCell = collectionView.cellForItem(at: oldIndexPath) as? BranchCollectionViewCell
                let currentSelected = collectionView.cellForItem(at: indexPath) as? BranchCollectionViewCell
                oldSelectedCell?.deselect()
                currentSelected?.select()
            }
        }
        
        viewModel?.update(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let tableViewIndexPath = getTableViewIndexPath(for: collectionView, insideCellOf: storyTableView) {
            let font = UIFont.systemFont(ofSize: 13)
            let string = viewModel?.titleForCollectionViewCell(atTableViewIndexPath: tableViewIndexPath, atCollectionViewIndexPath: indexPath) ?? ""
            let width = string.width(usingFont: font) + 32
            return CGSize(width: width, height: 48)
        }
        
        return .zero
        
    }
    
    func getTableViewIndexPath(for collectionView: UICollectionView, insideCellOf tableView: UITableView) -> IndexPath? {
        let origin = collectionView.frame.origin
        var pointInsideTableViewCell = collectionView.convert(origin, to: tableView)
        pointInsideTableViewCell.y -= rowHeight
        return tableView.indexPathForRow(at: pointInsideTableViewCell)
    }
    
}
