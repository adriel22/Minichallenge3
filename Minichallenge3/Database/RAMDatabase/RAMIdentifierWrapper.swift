//
//  RAMIdentifierWrapper.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 25/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import HistoryGraph

struct RAMIdentifierWrapper {
    var history: HistoryGraph
    
    var identifier: Int {
        get {
            return Int(self.history.idKey ?? "-1") ?? -1
        }
        set {
            let idKey = "\(newValue)"
            self.history.idKey = idKey
        }
    }
}
