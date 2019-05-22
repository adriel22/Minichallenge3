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
        
        let node2 = HistoryNode(withResume: "Ela escolheu o caminho curto e um lobo apareceu", text: "Um Lobo apareceu no caminho, o que você faz? ", positionX: 2, andPositionY: 1)
        
        let node3 = HistoryNode(withResume: "Ela escolheu o caminho longo e se divertiu bastante com seus amigos comendo frutos do mar. Fim da história. (Precisa continuar depois aqui)", text: "Você chegou a praia em segurança na praia, encontrou sua vovó e se divertiu bastante enquanto comia uns frutos do mar.", positionX: 1, andPositionY: 1)
        
        let node4 = HistoryNode(withResume: "Nunca é demais lembrar o peso e o significado destes problemas, uma vez que o surgimento do comércio virtual cumpre", text: "um papel essencial na formulação das condições inegavelmente apropriadas?", positionX: 1, andPositionY: 0)
        
        try? history.addNode(rootNode)
        try? history.addNode(node2)
        try? history.addNode(node3)
        try? history.addNode(node4)
        
        try? history.addPath(fromNode: rootNode, toNode: node2, withTitle: "caminho curto")
        try? history.addPath(fromNode: rootNode, toNode: node3, withTitle: "caminho longo")
        try? history.addPath(fromNode: rootNode, toNode: node4, withTitle: "opt 2")
        try? history.addPath(fromNode: node3, toNode: node4, withTitle: "opt 1")
        
        print(history.grid)
        
        return history
    }()
    
    lazy var histories: [HistoryGraph] = [
        chapeuzinhoHistory
    ]
}
