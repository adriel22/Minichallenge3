//
//  HistoryError.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 09/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

enum HistoryError: String, Error, Equatable {
    case wrongNodePosition = "the node`s position is invalid"
    case duplicatedNode = "the node is already in the graph"
    case impossibleMoving = "the node cant be moved due it connections"
}
