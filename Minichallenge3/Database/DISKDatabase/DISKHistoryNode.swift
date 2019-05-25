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
    
    var parent: Int?
    var shortcutIDs: [Int] = []
    var connections: [DISKConnection] = []
    var shortcutTarget: Int?
    
    init(text: String?, resume: String?, positionX: Int, positionY: Int) {
        self.text = text
        self.resume = resume
        self.positionX = positionX
        self.positionY = positionY
    }
}
