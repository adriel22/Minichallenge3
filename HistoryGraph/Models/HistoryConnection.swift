//
//  HistoryConnection.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

public struct HistoryConnection: Comparable {

    public weak var destinyNode: HistoryNodeProtocol?
    public var title: String
    

    public static func < (lhs: HistoryConnection, rhs: HistoryConnection) -> Bool {
        return lhs.title < rhs.title
    }

    public static func == (lhs: HistoryConnection, rhs: HistoryConnection) -> Bool {
        return lhs.destinyNode === rhs.destinyNode && lhs.title == rhs.title
    }
}
