//
//  HistoryNode.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

class HistoryNode: HistoryNodeProtocol {
    var resume: String
    var text: String

    weak var parent: HistoryNodeProtocol?
    var shortcuts: [HistoryShortcut] = []
    var connections: [HistoryConnection] = []

    /// Initialize the node
    ///
    /// - Parameters:
    ///   - resume: the resume is a little text about the node history, used to the nodes previews
    ///   - text: the real history text for the node
    init(withResume resume: String, andText text: String) {
        self.resume = resume
        self.text = text
    }
}
