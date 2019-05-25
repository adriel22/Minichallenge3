//
//  DISKNode.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 25/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

struct DISKHistoryNode: Codable {    
    var positionX: Int
    var positionY: Int
    var resume: String?
    var text: String?
    
    var parent: String?
    var shortcutIDs: [String] = []
    var connections: [DISKConnection] = []
}
