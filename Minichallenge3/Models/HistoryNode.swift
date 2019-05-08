//
//  HistoryNode.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

class HistoryNode: HistoryNodeProtocol {
    var positionX: Int
    var positionY: Int
    var resume: String?
    var text: String?

    weak var parent: HistoryNodeProtocol?
    var shortcuts: [HistoryShortcut] = []
    var connections: [HistoryConnection] = []

    var description: String {
        return "Resume: \(self.resume ?? "None"), Position: (x: \(positionX), y: \(positionY)"
    }

    /// Initialize the node
    ///
    /// - Parameters:
    ///   - resume: the resume is a little text about the node history, used to the nodes previews
    ///   - text: the real history text for the node
    init(withResume resume: String, text: String, positionX: Int, andPositionY positionY: Int) {
        self.resume = resume
        self.text = text
        self.positionX = positionX
        self.positionY = positionY
    }
}
