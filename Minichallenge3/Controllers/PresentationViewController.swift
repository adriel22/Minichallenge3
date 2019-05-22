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
    lazy var rowHeight: CGFloat = UIScreen.main.bounds.height/3.5
    lazy var sectionHeight: CGFloat = 48
    
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = indexPath.section == 0 ? "rootCell" : "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NodePresentationTableViewCell
        cell?.section = indexPath.section
        cell?.nodeView.text = viewModel?.textForTableViewCell(atIndexPath: indexPath, reuseIdentifier: reuseIdentifier)
        cell?.nodeView.collectionDelegate = self
        cell?.nodeView.dataSource = self
        cell?.selectionStyle = .none
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = viewModel?.nodes.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lastSectionIndex = (viewModel?.nodes.count ?? 0) - 1
        let headerView = ExpandableTableViewHeaderView()
        let sectionText = tableView.dataSource?.tableView?(storyTableView, titleForHeaderInSection: section)
        headerView.text = sectionText?.uppercased()
        headerView.isTheLastSection = (lastSectionIndex > 1 && section == lastSectionIndex)
        headerView.didTap = { _ in
            self.viewModel?.undo(atSection: section, inView: self)
            self.storyTableView.reloadData()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.titleForHeader(atSection: section, selectedBranch: selectedBranchesIndexes[section-1])
    }
    
}

extension PresentationViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = tableViewSection(collectionView) else { return 0 }
        guard let viewModel = viewModel else { return 0 }
        return viewModel.nodes[section].connections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "branchCell", for: indexPath) as? BranchCollectionViewCell
        guard let section = tableViewSection(collectionView) else { return cell! }
        cell?.title = viewModel?.titleForCollectionViewCell(atTableViewIndexPath: [section, 0], atCollectionViewIndexPath: indexPath)
        cell?.select()
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = tableViewSection(collectionView) else { return }
        if indexPath.item == selectedBranchesIndexes[section] { return }
        if selectedBranchesIndexes[section] != nil {
            viewModel?.switchBranch(tableViewIndexPath: [section, 0], collectionViewIndexPath: indexPath, updateView: self)
        } else {
            viewModel?.forwardBranch(tableViewIndexPath: [section, 0], collectionViewIndexPath: indexPath, updateView: self)
        }
        storyTableView.reloadData()
    }
    
    func tableViewSection(_ collectionView: UICollectionView) -> Int? {
        let tableCell = collectionView.superview?.superview?.superview as? NodePresentationTableViewCell
        return tableCell?.section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = tableViewSection(collectionView) else { return .zero }
        let font = UIFont.systemFont(ofSize: 13)
        let string = viewModel?.titleForCollectionViewCell(atTableViewIndexPath: [section, 0], atCollectionViewIndexPath: indexPath) ?? ""
        let width = string.width(usingFont: font) + 32
        return CGSize(width: width, height: 48)
    }
    
}
