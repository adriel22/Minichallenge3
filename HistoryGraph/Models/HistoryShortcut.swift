//
//  HistoryShortcut.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

public class HistoryShortcut: HistoryNodeProtocol {
    weak var node: HistoryNode?
    public weak var parent: HistoryNodeProtocol?

    public var resume: String? {
        get {
            return self.node?.resume
        }
        set {
            self.node?.resume = newValue
        }
    }

    public var text: String? {
        get {
            return self.node?.text
        }
        set {
            self.node?.text = newValue
        }
    }

    public var positionX: Int

    public var positionY: Int

    public var description: String {
        return "Shortcut for Node: \(self.node?.description ?? "None")"
    }


    /// Initialize a shortcut for a node
    ///
    /// - Parameters:
    ///   - node: the target shortcut node
    ///   - parent: the parent of the shortcut
    init(forNode node: HistoryNode, andParentNode parent: HistoryNode?, positionX: Int, andPositionY positionY: Int) {
        self.node = node
        self.parent = parent
        self.positionX = positionX
        self.positionY = positionY
    }
}
