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
    var historiesDAO = DISKHistoryDAO()
    
    private lazy var narratives: [HistoryGraph] = historiesDAO.getAll()
    
    func addNarrative(withName name: String, toTable tableView: UITableView) {
        let graph = HistoryGraph(withName: name, sinopse: "", width: 3, andHeight: 3)
        if let savedHistory = historiesDAO.save(element: graph) {
            narratives.append(savedHistory)
            tableView.reloadData()
        }
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
            cell?.buttonAction = presentNextView(cell:)
            return cell!
        }
        
        let cell = UITableViewCell()
        cell.textLabel?.text = narratives[indexPath.row].historyName
        return cell
    }
    
    func presentNextView(cell: ExpandableTableViewCell) {
        guard let tableView = delegate?.tableView(),
              let tapPositon = tableView.indexPath(for: cell)?.row else {
            return
        }
        
        let history = narratives[tapPositon]
        let graphHistoryViewModel = HistoryGraphViewModel(withHistoryGraph: history, withIdentifier: tapPositon)
    
        self.delegate?.presentGraphView(withViewMode: graphHistoryViewModel)
        
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
