//
//  RAMHistoryDAO.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import HistoryGraph

class RAMHistoryDAO: DAO {
    typealias Element = HistoryGraph
    
    func getAll() -> [HistoryGraph] {
        return RAMDatabase.shared.histories
    }
    
    func save(element: HistoryGraph) -> HistoryGraph? {
        RAMDatabase.shared.histories.append(element)
        return element
    }
    
    func delete(element: HistoryGraph) {
        RAMDatabase.shared.histories.removeAll { (currentHistory) -> Bool in
            return currentHistory === element
        }
    }
    
    func get(elementWithID daoID: String) -> HistoryGraph? {
        guard let intDAOID = Int(daoID),
              intDAOID < RAMDatabase.shared.histories.count &&
              intDAOID >= 0 else {
            return nil
        }
        return RAMDatabase.shared.histories[intDAOID]
    }
    
    func update(element: HistoryGraph) -> Bool {
        let wrapper = RAMIdentifierWrapper(history: element)
        guard wrapper.identifier < RAMDatabase.shared.histories.count && wrapper.identifier >= 0 else {
            return false
        }
        
        RAMDatabase.shared.histories.remove(at: wrapper.identifier)
        RAMDatabase.shared.histories.insert(element, at: wrapper.identifier)
        
        return true
    }
}
