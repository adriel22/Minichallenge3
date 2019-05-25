//
//  PresentationViewController.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 16/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class PresentationViewController: UIViewController {
    
    var currentSection = 0
    
    var viewModel: PresentationViewModelProtocol? {
        didSet {
            viewModel?.update(self)
        }
    }
    
    lazy var contentView: NodePresentationView! = RootNodePresentationView()
    var contentCenterYLayoutConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(color: .purpleWhite)
        view.addSubview(contentView)
        
        configureNavigationBar()
        configureNodePresentationView()
        configureHeaderView()
        
        setConstraints()
    }
    
    func configureNavigationBar() {
        viewModel?.setNavigationBarTitle?(in: navigationItem)
        let button = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismiss(_:)))
        navigationItem.setRightBarButton(button, animated: false)
    }
    
    @objc func dismiss(_ sender: UIBarButtonItem) {
        if let navigation = navigationController {
            navigation.dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func configureNodePresentationView() {
        let content = contentView as? RootNodePresentationView
        
        content?.headerView.text = viewModel?.titleForHeader(at: -2)
        content?.nodeView.text = viewModel?.graph.sinopse
        content?.nodeView.collectionDelegate = self
        content?.nodeView.dataSource = self
        
        content?.root.headerView.text = viewModel?.titleForHeader(at: -1)
        content?.root.nodeView.text = viewModel?.textForHistoryNode(at: 0)
        content?.root.nodeView.collectionDelegate = self
        content?.root.nodeView.dataSource = self
    }
    
    func configureHeaderView() {
        contentView.headerView.isTheLastSection = false
        contentView.headerView.didTap = { _ in
            self.animate(isGoingForward: false, {
                self.viewModel?.undo(in: self)
                self.currentSection -= 1
                self.viewModel?.update(self)
            })
        }
    }
    
    func setConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentCenterYLayoutConstraint = contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        NSLayoutConstraint.activate([
            contentCenterYLayoutConstraint,
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    func forwardBranch(indexPath: IndexPath) {
        animate(isGoingForward: true, {
            self.viewModel?.forwardBranch(section: self.currentSection, indexPath: indexPath, in: self)
            self.currentSection += 1
            self.viewModel?.update(self)
        })
    }
    
    func animate(isGoingForward: Bool, _ completion: (() -> Void)?) {
        let isGoingToRoot = (!isGoingForward && currentSection == 1)
        let content = isGoingToRoot ? RootNodePresentationView() : NodePresentationView(type: .cell)
        content.headerView.didTap = { _ in
            self.animate(isGoingForward: false, {
                self.viewModel?.undo(in: self)
                self.currentSection -= 1
                if self.currentSection == 0 { self.configureNodePresentationView() }
                self.viewModel?.update(self)
            })
        }
        
        content.nodeView.collectionDelegate = self
        content.nodeView.dataSource = self
        
        let offset = isGoingForward ? 1 : -1
        content.nodeView.text = viewModel?.textForHistoryNode(at: currentSection + offset)
        
        view.addSubview(content)
        
        if isGoingForward {
            content.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                content.topAnchor.constraint(equalTo: contentView.bottomAnchor),
                content.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                content.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                content.heightAnchor.constraint(equalTo: contentView.heightAnchor)
            ])
        } else {
            content.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                content.bottomAnchor.constraint(equalTo: contentView.topAnchor),
                content.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                content.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                content.heightAnchor.constraint(equalTo: contentView.heightAnchor)
            ])
        }
        
        view.layoutIfNeeded()
        let height = view.frame.height
        let oldContent = contentView
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseIn, .allowUserInteraction], animations: {
            self.contentCenterYLayoutConstraint.constant += isGoingForward ? -height : height
            self.view.layoutIfNeeded()
            
            self.contentView = content
            completion?()
            
        }, completion: { _ in
            oldContent?.removeFromSuperview()
            self.setConstraints()
        })
    }

}

extension PresentationViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        if currentSection < 0 && currentSection < viewModel.nodes.count { return 0 }
        return viewModel.nodes[currentSection].connections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "branchCell", for: indexPath) as? BranchCollectionViewCell
        cell?.title = viewModel?.titleForCollectionViewCell(at: currentSection, at: indexPath)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        forwardBranch(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont.systemFont(ofSize: 13)
        let string = viewModel?.titleForCollectionViewCell(at: currentSection, at: indexPath) ?? ""
        let width = string.width(usingFont: font) + 32
        return CGSize(width: width, height: 48)
    }
    
}
