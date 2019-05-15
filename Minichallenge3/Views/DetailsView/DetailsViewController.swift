//
//  DetailsViewController.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var scrollView: UIScrollView!
    var upnodeView: NodeDetailsView!
    var downnodeView: NodeDetailsView!
    var viewModel: DetailsViewModel! {
        didSet {
            if let scrollView = scrollView,
                let upnodeView = upnodeView,
                let downnodeView = downnodeView {
                viewModel.update(self)
            }
        }
    }
    
    var selected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenBounds = UIScreen.main.bounds
        let navigationBarStatusBarHeight = UIApplication.shared.statusBarFrame.height
                                        + navigationController!.navigationBar.frame.height
        let screenSize = CGSize(width: screenBounds.width, height: screenBounds.height - navigationBarStatusBarHeight)
        let halfScreenSize = CGSize(width: screenBounds.width, height: (screenBounds.height - navigationBarStatusBarHeight)/2)
        
        scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = UIColor(color: .yellowWhite)
        scrollView.frame = CGRect(origin: .zero, size: screenSize)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        scrollView.contentSize = screenSize
        scrollView.contentSize.height += halfScreenSize.height
        view.addSubview(scrollView)
        
        upnodeView = NodeDetailsView(position: .up)
        upnodeView.addBranchButton.addTarget(self, action: #selector(addBranch(_:)), for: .touchUpInside)
        upnodeView.frame.size = halfScreenSize
        scrollView.addSubview(upnodeView)
        
        downnodeView = NodeDetailsView(position: .down)
        downnodeView.goOnButton.addTarget(self, action: #selector(goOn(_:)), for: .touchUpInside)
        downnodeView.frame.size = halfScreenSize
        downnodeView.frame.origin.y = halfScreenSize.height
        scrollView.addSubview(downnodeView)
        
        configureNavigationBar()
        setDelegatesAndDataSources()
        
    }
    
    func configureNavigationBar() {
        let image = UIImage(named: "Dismiss")
        navigationItem.title = "Jurema, a aventureira da vida real"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(dismiss(_:)))
    }
    
    func setDelegatesAndDataSources() {
        upnodeView.text.delegate = self
        upnodeView.branches.delegate = self
        downnodeView.text.delegate = self
        downnodeView.branches.delegate = self
        upnodeView.branches.dataSource = self
        downnodeView.branches.dataSource = self
    }
    
    
    @objc func addBranch(_ sender: UIButton) {
        viewModel.addBranch()
        upnodeView.branches.reloadData()
        
        let indexPath = IndexPath(item: self.viewModel.story.connections.count - 1, section: 0)
        upnodeView.branches.scrollToItem(at: indexPath, at: .right, animated: true)
        
        self.selected = indexPath.item
        self.downnodeView.text.text = ""
    }

    @objc func goOn(_ sender: UIButton) {
        var branches = viewModel.story.connections
        if branches.isEmpty { return }
        guard let destiny = branches[selected].destinyNode as? HistoryNode else { return }
        downnodeView.text.resignFirstResponder()
        viewModel.story = destiny
        viewModel.update(self)
    }
    
    @objc func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension DetailsViewController: UITextViewDelegate {
    func moveView(up: Bool) {
        let screenBounds = UIScreen.main.bounds
        let navigationBarStatusBarHeight = UIApplication.shared.statusBarFrame.height
            + navigationController!.navigationBar.frame.height
        let halfScreenSize = CGSize(width: screenBounds.width, height: (screenBounds.height - navigationBarStatusBarHeight)/2)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut, .allowUserInteraction, .transitionCurlUp], animations: {
            self.scrollView.contentOffset.y = up ? halfScreenSize.height : 0
            self.downnodeView.text.frame.size.height += up ? -50 : 50
            self.downnodeView.goOnButton.frame.origin.y += up ? -50 : 50
        })
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView === downnodeView.text {
            let branches = viewModel.story.connections
            return !branches.isEmpty
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView === downnodeView.text {
            moveView(up: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView === downnodeView.text {
           moveView(up: false)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView === upnodeView.text {
            viewModel.textUpdated(with: textView.text, inNode: viewModel.story)
        }
        
        if textView === downnodeView.text {
            var branches = viewModel.story.connections
            if branches.isEmpty { return }
            guard let node =  branches[selected].destinyNode as? HistoryNode else { return }
            viewModel.textUpdated(with: textView.text, inNode: node)
        }
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else { return 0 }
        return viewModel.story.connections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? BranchCollectionViewCell
        cell?.label.text = viewModel.story.connections[indexPath.item].title
        if indexPath.item == selected {
            cell?.select()
        } else {
            cell?.deselect()
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = indexPath.item
        viewModel.update(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont.systemFont(ofSize: 13)
        let string = viewModel.story.connections[indexPath.item].title
        let width = string.width(usingFont: font) + 32
        return CGSize(width: width, height: 48)
    }
}
