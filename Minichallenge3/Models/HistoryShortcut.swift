//
//  HistoryShortcut.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

class HistoryShortcut {
    weak var node: HistoryNode?
    weak var parent: HistoryNode?

    /// Initialize a shortcut for a node
    ///
    /// - Parameters:
    ///   - node: the target shortcut node
    ///   - parent: the parent of the shortcut
    init(forNode node: HistoryNode, andParentNode parent: HistoryNode) {
        self.node = node
        self.parent = parent
    }
}
