//
//  MyNarrativesViewModelDelegate.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 20/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
protocol MyNarrativesViewModelDelegate: AnyObject {
    func presentGraphView(withViewMode: HistoryGraphViewModel)
    func tableView() -> UITableView
}
