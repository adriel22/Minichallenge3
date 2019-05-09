//
//  NodeProtocol.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

public protocol HistoryNodeProtocol: AnyObject, CustomStringConvertible {
    var parent: HistoryNodeProtocol? { get set }
    var resume: String? { get set }
    var text: String? { get set }
    var positionX: Int { get set }
    var positionY: Int { get set }
}
