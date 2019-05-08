//
//  HistoryShortcut.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

class HistoryShortcut: HistoryNodeProtocol {
    var parent: HistoryNodeProtocol?

    var resume: String? {
        get {
            return self.node?.resume
        }
        set {
            self.node?.resume = newValue
        }
    }

    var text: String? {
        get {
            return self.node?.text
        }
        set {
            self.node?.text = newValue
        }
    }

    var positionX: Int

    var positionY: Int

    var description: String {
        return "Shortcut for Node: \(self.node?.description ?? "None")"
    }

    weak var node: HistoryNode?

    /// Initialize a shortcut for a node
    ///
    /// - Parameters:
    ///   - node: the target shortcut node
    ///   - parent: the parent of the shortcut
    init(forNode node: HistoryNode, andParentNode parent: HistoryNode, positionX: Int, andPositionY positionY: Int) {
        self.node = node
        self.parent = parent
        self.positionX = positionX
        self.positionY = positionY
    }
}
