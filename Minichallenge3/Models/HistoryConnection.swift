//
//  HistoryConnection.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

struct HistoryConnection: Comparable {

    weak var destinyNode: HistoryNodeProtocol?
    var title: String

    static func < (lhs: HistoryConnection, rhs: HistoryConnection) -> Bool {
        return lhs.title < rhs.title
    }

    static func == (lhs: HistoryConnection, rhs: HistoryConnection) -> Bool {
        return lhs.destinyNode === rhs.destinyNode && lhs.title == rhs.title
    }
}
