//
//  RAMDatabase.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import HistoryGraph

class RAMDatabase {
    
    static var shared = RAMDatabase()
    
    var chapeuzinhoHistory: HistoryGraph = {
        let history = HistoryGraph(withName: "Chapeuzinho Vermelho", sinopse: "Chapeuzinho Vermelho vai a paraia e encontrar o lobo mal", width: 3, andHeight: 3)
        
        let rootNode = HistoryNode(withResume: "Chapeuzinho escolhe o caminho", text: "Você se depara com dois caminhos. Você escolhe o caminho curto ou o longo?", positionX: 2, andPositionY: 0)
        
        try? history.addNode(rootNode)
        
        return history
    }()
    
    lazy var histories: [HistoryGraph] = [
        chapeuzinhoHistory
    ]
}
