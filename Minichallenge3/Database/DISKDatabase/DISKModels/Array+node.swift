//
//  Array+node.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 25/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import HistoryGraph

extension Array where Element == HistoryNodeProtocol {
    func indexForNode(_ node: HistoryNodeProtocol) -> Int? {
        return firstIndex { (currentNode) -> Bool in
            return currentNode === node
        }
    }
}
