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
    
    lazy var historyURL: URL? = {
        guard let historyURL =
            FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first?.appendingPathComponent("histories") else {
            return nil
        }
        
        try? FileManager.default.createDirectory(
            at: historyURL,
            withIntermediateDirectories: false,
            attributes: nil
        )
        
        return historyURL
    }()
    
    func getAll() -> [HistoryGraph] {
        guard let historyURL = self.historyURL,
              let historiesUrls =
                try? FileManager.default.contentsOfDirectory(
                    at: historyURL,
                    includingPropertiesForKeys: nil,
                    options: .skipsHiddenFiles
                ) else {
            return []
        }
        
        return historiesUrls.compactMap({ (historyURL) -> HistoryGraph? in
            guard let diskHistory = DISKHistoryGraph(fromURL: historyURL) else {
                return nil
            }
            let graphHistory = DISKHistoryFormatter.DISKHistoryToHistoryGraph(diskHistory: diskHistory)
            
            return graphHistory
        })
    }
    
    func save(element: HistoryGraph) -> HistoryGraph? {
        guard element.idKey == nil else {
            return nil
        }
        let diskHistory = DISKHistoryFormatter.historyGraphToDISKModel(historyGraph: element)
        
        guard let historyData = try? diskHistory.encoded(),
              let historyURL = historyURL?.appendingPathComponent(diskHistory.identifier) else {
            return nil
        }
        
        do {
            try historyData.write(to: historyURL)
            element.idKey = diskHistory.identifier
            return element
        } catch {
            return nil
        }
    }
    
    func delete(element: HistoryGraph) {
        
    }
    
    func get(elementWithID daoID: String) -> HistoryGraph? {
        return HistoryGraph(withName: "", sinopse: "", width: 0, andHeight: 0)
    }
    
    func update(element: HistoryGraph) -> Bool {
        guard element.idKey != nil else {
            return false
        }
        let diskHistory = DISKHistoryFormatter.historyGraphToDISKModel(historyGraph: element)
        
        guard let historyData = try? diskHistory.encoded(),
              let historyURL = historyURL?.appendingPathComponent(diskHistory.identifier) else {
            return false
        }
        
        do {
            try historyData.write(to: historyURL)
            return true
        } catch {
            return false
        }
    }
}
