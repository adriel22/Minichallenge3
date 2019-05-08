//
//  NodeProtocol.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 08/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

protocol HistoryNodeProtocol: AnyObject {
    var resume: String { get set }
    var text: String { get set }
}
