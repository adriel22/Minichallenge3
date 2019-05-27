//
//  DetailsViewController.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
import HistoryGraph

class DetailsViewController: UIViewController {

    lazy var scrollView: UIScrollView! = UIScrollView(frame: .zero)
    lazy var upnodeView: NodeDetailsView! = NodeDetailsView(type: .up)
    lazy var downnodeView: NodeDetailsView! = NodeDetailsView(type: .down)
    
    var viewModel: DetailsViewModelProtocol? {
        didSet {
            viewModel?.animationDelegate = self
            viewModel?.update(self)
        }
    }

    lazy var selected = 0
    lazy var shouldAnimateUpView = false
    lazy var shouldAnimateDownView = false

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.delegate = self
        
        configureScrollView()
        view.addSubview(scrollView)

        configureUpnodeView()
        scrollView.addSubview(upnodeView)

        configureDownnodeVode()
        scrollView.addSubview(downnodeView)

        configureNavigationBar()
        setDelegatesAndDataSources()
        setConstraints()

    }

    func configureScrollView() {
        scrollView.backgroundColor = UIColor(color: .yellowWhite)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.5)
    }

    func configureUpnodeView() {
        upnodeView.addTargetForAddBranchButton(target: self,
                                               selector: #selector(addBranch(_:)),
                                               forEvent: .touchUpInside)
    }

    func configureDownnodeVode() {
        downnodeView.addTargetForGoOnButton(target: self,
                                            selector: #selector(goOn(_:)),
                                            forEvent: .touchUpInside)
        downnodeView.addTargetForGoBackButton(target: self,
                                              selector: #selector(goBack(_:)),
                                              forEvent: .touchUpInside)
    }

    func configureNavigationBar() {
        viewModel?.setNavigationBarTitle?(in: navigationItem)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismiss(_:)))
    }

    func setDelegatesAndDataSources() {
        upnodeView.collectionDelegate = self
        upnodeView.textViewDelegate = self
        downnodeView.collectionDelegate = self
        downnodeView.textViewDelegate = self
        upnodeView.dataSource = self
        downnodeView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.willCloseController()
    }

    func setConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    
        upnodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            upnodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            upnodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            upnodeView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            upnodeView.bottomAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])

        downnodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            downnodeView.topAnchor.constraint(equalTo: upnodeView.bottomAnchor),
            downnodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            downnodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            downnodeView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }

    @objc func addBranch(_ sender: UIButton) {
        viewModel?.addBranch()

    }

    @objc func goOn(_ sender: UIButton) {
        downnodeView.textView.resignFirstResponder()
        viewModel?.goOn(branchIndex: selected)
        selected = 0
        shouldAnimateUpView = true
        shouldAnimateDownView = true
        viewModel?.update(self)
    }
    
    @objc func goBack(_ sender: UIButton) {
        downnodeView.textView.resignFirstResponder()
        viewModel?.goBack()
        selected = 0
        shouldAnimateUpView = true
        shouldAnimateDownView = true
        viewModel?.update(self)
    }
    
    func collapseLastNode() {
        
    }
    
    func expandNotLastNode() {
        
    }

    @objc func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

extension DetailsViewController: UITextViewDelegate {
    func moveView(up: Bool) {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = self.navigationController!.navigationBar.frame.height
        let halfScreenHeight = (UIScreen.main.bounds.height - statusBarHeight - navigationBarHeight)/2
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.7,
                       options: [.curveEaseInOut, .allowUserInteraction, .transitionCurlUp],
                       animations: {

            self.scrollView.contentOffset.y = up ? halfScreenHeight : 0
            self.downnodeView.adjustTextViewAndGoOnButton(offset: up ? -50 : 50)

        })
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView === downnodeView.textView {
            if let branches = viewModel?.story.connections {
                return !branches.isEmpty
            }
        }
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView === downnodeView.textView {
            moveView(up: true)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView === downnodeView.textView {
           moveView(up: false)
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView === upnodeView.textView {
            if let viewModel = viewModel {
                viewModel.textUpdated(with: textView.text, in: viewModel.story)
            }
        }

        if textView === downnodeView.textView {
            if let branches = viewModel?.story.connections {
                if branches.isEmpty { return }
                guard let node =  branches[selected].destinyNode as? HistoryNode else { return }
                viewModel?.textUpdated(with: textView.text, in: node)
            }
        }
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.story.connections.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "branchCell", for: indexPath) as? BranchCollectionViewCell
        cell?.title = viewModel?.titleForCollectionViewCell(at: indexPath)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let displayedCell = cell as? BranchCollectionViewCell
        if indexPath.item == selected {
            displayedCell?.select()
        } else {
            displayedCell?.deselect()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = indexPath.item
        shouldAnimateUpView = false
        shouldAnimateDownView = true
        viewModel?.update(self)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont.systemFont(ofSize: 13)
        let string = viewModel?.titleForCollectionViewCell(at: indexPath) ?? ""
        let width = string.width(usingFont: font) + 32
        return CGSize(width: width, height: 48)
    }

}
extension DetailsViewController: DetailsViewModelDelegate, DetailsViewModelAnimationDelegate {
    func showAddView(_ controller: AddRamificationViewController) {
        controller.viewModel.trasitioningDelegate = self.viewModel as? AddRamificationTrasitioningDelegate
        self.present(controller, animated: true, completion: nil)
    }
    
    func updateView() {
        self.viewModel?.update(self)
    }
    
    func shouldAnimateUpnodeView() -> Bool {
        return shouldAnimateUpView
    }
    
    func shouldAnimateDownnodeView() -> Bool {
        return shouldAnimateDownView
    }
    
}
