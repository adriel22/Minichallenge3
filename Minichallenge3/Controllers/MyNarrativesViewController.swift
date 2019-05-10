//
//  MyNarrativesViewController.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 09/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class MyNarrativesViewController: UIViewController, HasCustomView {
    typealias CustomView = MyNarratives

    override func loadView() {
        let customView = CustomView()
        self.view = customView

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = customView.tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        

    }

}
extension MyNarrativesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.backgroundColor = UIColor.green
        cell.textLabel?.text = " aaa "
//        cell.
        return cell
    }

}
