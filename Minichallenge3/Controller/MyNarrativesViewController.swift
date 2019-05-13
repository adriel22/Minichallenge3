//
//  MyNarrativesViewController.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 10/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class MyNarrativesViewController: UIViewController {
    let customView = MyNarrativeViews()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = customView.tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExpandableTableViewCell.self, forCellReuseIdentifier: "cell")

    }
    override func loadView() {
        self.view = customView
    }

}
extension MyNarrativesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ExpandableTableViewCell
        return cell!
    }

}
