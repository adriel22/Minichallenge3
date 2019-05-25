//
//  DISKHistoryDAO.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 25/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import HistoryGraph

class DISKHistoryDAO: DAO {
    typealias Element = HistoryGraph
    
    func getAll() -> [HistoryGraph] {
        return []
    }
    
    func save(element: HistoryGraph) {
        
    }
    
    func delete(element: HistoryGraph) {
        
    }
    
    func get(elementWithID daoID: Int) -> HistoryGraph {
        return HistoryGraph(withName: "", sinopse: "", width: 0, andHeight: 0)
    }
    
    func update(element: HistoryGraph) {
    
    }
}
