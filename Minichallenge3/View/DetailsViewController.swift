//
//  DetailsViewController.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var upnodeView: NodeDetailsView!
    var downnodeView: NodeDetailsView!
    var viewModel: DetailsViewModel!
    
    var selected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Jurema, a aventureira da vida real"
        
        let screenBounds = UIScreen.main.bounds
        let navigationBarStatusBarHeight = UIApplication.shared.statusBarFrame.height
                                        + navigationController!.navigationBar.frame.height
        let size = CGSize(width: screenBounds.width, height: (screenBounds.height - navigationBarStatusBarHeight)/2)
        
        
        upnodeView = NodeDetailsView(position: .up)
        upnodeView.addBranchButton.addTarget(self, action: #selector(addBranch(_:)), for: .touchUpInside)
        upnodeView.frame.size = size
        view.addSubview(upnodeView)
        
        downnodeView = NodeDetailsView(position: .down)
        downnodeView.goOnButton.addTarget(self, action: #selector(goOn(_:)), for: .touchUpInside)
        downnodeView.frame.size = size
        downnodeView.frame.origin.y = size.height
        view.addSubview(downnodeView)
        
        let str1 = "Jurema é uma jovem moça a qual, talvez, quem sabe, maybe, entende muito do que acontece "
        let str2 = "na corriqueira vida dos outros, talento esse que também é conhecido como o tal do fofoqueirismo"
        let str = "\(str1)\(str2)"
        
        let str3 = "Certo dia, Jurema descobriu uma fofoca super intrigante. Porém, contudo, todavia, entretanto, "
        let str4 = "ela está receosa em contá-la para sua mais que amiga, sua friend, Marivalda. E aí você contaria?"
        let branchResume = "\(str3)\(str4)"
        
        let story = HistoryNode(withResume: str, andText: "Teste")
        let secNode = HistoryNode(withResume: branchResume, andText: "Teste")
        let connection = HistoryConnection(destinyNode: secNode, title: "O grande babado")
        story.connections.append(connection)
        story.connections.append(connection)
        story.connections.append(connection)
        story.connections.append(connection)
        story.connections.append(connection)
        
        upnodeView.text.text = str
        downnodeView.text.text = branchResume

        viewModel = DetailsViewModel(story: story)
        
        upnodeView.text.delegate = self
        upnodeView.branches.delegate = self
        upnodeView.branches.dataSource = self
        
        downnodeView.branches.delegate = self
        downnodeView.branches.dataSource = self
        
    }
    
    func updateDownNodeView() {
        
    }
    
    
    @objc func addBranch(_ sender: UIButton) {
        
    }

    @objc func goOn(_ sender: UIButton) {
        
    }
    
}

extension DetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.textUpdated(with: textView.text)
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        collectionView.reloadData()
        updateDownNodeView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont.systemFont(ofSize: 13)
        let string = viewModel.story.connections[indexPath.item].title
        let width = string.width(usingFont: font) + 32
        return CGSize(width: width, height: 48)
    }
}
