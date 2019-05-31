//
//  DIKSHistoryGraph.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 25/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import HistoryGraph

struct DISKHistoryGraph: Codable {
    var nodes: [DISKHistoryNode]
    var historyName: String
    var sinopse: String
    var identifier: String
    var gridWidth: Int
    var gridHeight: Int
    
    init(historyName: String, sinopse: String, gridWidth: Int, gridHeight: Int, identifier: String? = nil) {
        self.nodes = []
        self.historyName = historyName
        self.sinopse = sinopse
        self.identifier = identifier ?? UUID().uuidString
        self.gridWidth = gridWidth
        self.gridHeight = gridHeight
    }
    
    init?(fromURL url: URL) {
        guard let historyData = try? Data(contentsOf: url),
              let historyGraph = try? historyData.decoded() as DISKHistoryGraph else {
            return nil
        }

        self = historyGraph
    }
}
