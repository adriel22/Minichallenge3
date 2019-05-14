//
//  MyNarrativesViewController.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 10/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

//class MyNarrativesViewController: UIViewController {
//    let customView = MyNarrativeViews()
//    var clickedRow: IndexPath?
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let tableView = customView.tableView
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        let nib = UINib(nibName: "ExpandableTableViewCell", bundle: .main)
//        tableView.register(nib, forCellReuseIdentifier: "cell")
//        tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
//
//    }
//    override func loadView() {
//        self.view = customView
//    }
//
//}
//extension MyNarrativesViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 30
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if  indexPath == clickedRow {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ExpandableTableViewCell
//
//            return cell!
//        }
//
//        let cell = UITableViewCell()
//        cell.textLabel?.text = "Jurema aventureira"
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath == clickedRow {
//            return 200
//        }
//        return UITableView.automaticDimension
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let indexClicked = clickedRow {
//            clickedRow = nil
//            tableView.reloadRows(at: [indexClicked], with: .automatic)
//        }
//            clickedRow = indexPath
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scroll = scrollView.contentOffset.y
//        customView.navigationBar.updateHeight(customView.navigationBar.maximunHeight - scroll)
//        customView.updateTableConstraint(scroll)
//    }
//
//}
