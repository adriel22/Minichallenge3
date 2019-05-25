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
    lazy var upnodeView: NodeDetailsView! = NodeDetailsView(position: .up)
    lazy var downnodeView: NodeDetailsView! = NodeDetailsView(position: .down)

    var viewModel: DetailsViewModel? {
        didSet {
            viewModel?.update(self)
        }
    }

    lazy var selected = 0

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
//        upnodeView.frame.origin = scrollView.frame.origin
//        upnodeView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height-UIApplication.shared.statusBarFrame.height-navigationController!.navigationBar.frame.height)/2)
        upnodeView.addTargetForAddBranchButton(target: self,
                                               selector: #selector(addBranch(_:)),
                                               forEvent: .touchUpInside)
    }

    func configureDownnodeVode() {
//        downnodeView.frame.origin = CGPoint(x: 0, y: upnodeView.frame.origin.y + (UIScreen.main.bounds.height-UIApplication.shared.statusBarFrame.height-navigationController!.navigationBar.frame.height)/2)
//        downnodeView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height-UIApplication.shared.statusBarFrame.height-navigationController!.navigationBar.frame.height)/2)
        downnodeView.addTargetForGoOnButton(target: self,
                                            selector: #selector(goOn(_:)),
                                            forEvent: .touchUpInside)
    }

    func configureNavigationBar() {
        let image = UIImage(named: "Dismiss")
        navigationItem.title = "Jurema, a aventureira da vida real"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(dismiss(_:)))
    }

    func setDelegatesAndDataSources() {
        upnodeView.delegate = self
        downnodeView.delegate = self
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
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = self.navigationController!.navigationBar.frame.height
        let halfScreenHeight = (UIScreen.main.bounds.height - statusBarHeight - navigationBarHeight)/2
    
        upnodeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            upnodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            upnodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            upnodeView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            upnodeView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -halfScreenHeight/2)
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
        if let branches = viewModel?.story.connections {
            if branches.isEmpty { return }
            guard let destiny = branches[selected].destinyNode as? HistoryNode else { return }
            downnodeView.textView.resignFirstResponder()
            viewModel?.story = destiny
            viewModel?.update(self)
        }
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

            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            let navigationBarHeight = self.navigationController!.navigationBar.frame.height
            let halfScreenHeight = (UIScreen.main.bounds.height - statusBarHeight - navigationBarHeight)/2

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
                viewModel.textUpdated(with: textView.text, inNode: viewModel.story)
            }
        }

        if textView === downnodeView.textView {
            if let branches = viewModel?.story.connections {
                if branches.isEmpty { return }
                guard let node =  branches[selected].destinyNode as? HistoryNode else { return }
                viewModel?.textUpdated(with: textView.text, inNode: node)
            }
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
        cell?.title = viewModel?.story.connections[indexPath.item].title
        if indexPath.item == selected {
            cell?.select()
        } else {
            cell?.deselect()
        }
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = indexPath.item
        viewModel?.update(self)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont.systemFont(ofSize: 13)
        let string = viewModel?.story.connections[indexPath.item].title ?? ""
        let width = string.width(usingFont: font) + 32
        return CGSize(width: width, height: 48)
    }

}
extension DetailsViewController: DetailsViewModelDelegate {
    func showAddView(_ controller: AddRamificationViewController) {
        controller.viewModel.trasitioningDelegate = self.viewModel
        self.present(controller, animated: true, completion: nil)
    }
    func updateView() {
        self.viewModel?.update(self)
    }
    
}
