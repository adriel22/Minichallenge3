//
//  HistoryGridDelegate.swift
//  HistoryGraph
//
//  Created by Alan Victor Paulino de Oliveira on 15/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

public typealias Position = (x: Int, y: Int)
public protocol HistoryGridDelegate: class {

    func addedColumToGrid(inPosition: Int)
    func addedLineToGrid(inPosition: Int)
    func movedNodeToPosition(fromPosition position: Position, toPosition position: Position)
    func addNode(inPosition position: Position)
    func addShortcut(inPosition position: Position)
}
