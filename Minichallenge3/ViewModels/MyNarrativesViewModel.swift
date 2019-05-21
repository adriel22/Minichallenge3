//
//  MyNarrativesViewModel.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 20/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import HistoryGraph
class MyNarrativesViewModel {
    public weak var delegate: MyNarrativesViewModelDelegate?
    var clickedCellIndex: IndexPath?
    
    private var narratives: [HistoryGraph] = []
    
    func addNarrative(withName name: String, toTable tableView: UITableView) {
        let graph = HistoryGraph(withName: name, sinopse: "", width: 0, andHeight: 0)
        narratives.append(graph)
        tableView.reloadData()
        
    }
    
    func numberOfRows() -> Int {
        return narratives.count
    }

    func editSinopse(toGraph graph: HistoryGraph) {
        
    }
    
    func clickedRow(cell: UITableViewCell) {
        
    }
    
    func loadCell(forTable tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        if indexPath == clickedCellIndex {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ExpandableTableViewCell
            cell?.label.text = narratives[indexPath.row].sinopse
            cell?.buttonAction = presentNextView(_:)
            return cell!
        }
        
        let cell = UITableViewCell()
        cell.textLabel?.text = narratives[indexPath.row].historyName
        return cell
    }
    
    func presentNextView(_ : UIButton) {
        self.delegate?.presentGraphView()
        
    }
    
    func expandCell(forTable tableView: UITableView, atIndexPath indexPath: IndexPath) {
        if let lastCliked = clickedCellIndex {
            clickedCellIndex = nil
            tableView.reloadRows(at: [lastCliked], with: .automatic)
            
        }
        clickedCellIndex = indexPath
        let cell = tableView.cellForRow(at: indexPath)
        cell?.translatesAutoresizingMaskIntoConstraints = false
        tableView.reloadRows(at: [clickedCellIndex!], with: .automatic)
    }
    
    func cellHeight(forTable tableView: UITableView, atIndexPath indexPath: IndexPath) -> CGFloat {
        if indexPath == clickedCellIndex {
            return 200
        } else {
            return UITableView.automaticDimension
        }
    }
    
}
