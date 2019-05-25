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
    
    var joseph: HistoryGraph = {
        let history = HistoryGraph(withName: "Joseph`s Life", sinopse: "A history about the choices of Joseph in his life", width: 11, andHeight: 7)
        
        let node17 = HistoryNode(withResume: "", text: "Joseph was a student of a public university, he loved to write stories because he believed that through them people could see the different world. One day he discovered the branching narratives, stories that enable the reader to choose his course. Excitement soon came when he realized that there was much of this kind of narrative to be explored. he researched and discovered that there were some ways to write these stories: ", positionX: 5, andPositionY: 0)

        let rootNode = HistoryNode(withResume: "", text: "Choose one:", positionX: 5, andPositionY: 1)

        let node2 = HistoryNode(withResume: "", text: "Congratulations you just picked, an inexpensive, easy-to-use app on which you can write from wherever you are: bus, subway, car. There is a very fluid interface that allows you to create the story intuitively without any prior knowledge, so much space is left to put the creativity to work. Do you still want to choose another tool?", positionX: 6, andPositionY: 2)
        let node3 = HistoryNode(withResume: "", text: "He loved writing with twine for very simple narratives, but when ideas came at once, he faced a major problem, he needed to learn how to program JavaScript and CSS to do them. Does he want to learn programming?", positionX: 5, andPositionY: 2)
        let node4 = HistoryNode(withResume: "", text: "He loved writing on paper, but realized that to write a branching narrative would begin a great mess. Do you choose to keep paper and clutter, or choose software that will help you? ", positionX: 7, andPositionY: 2)
        let node5 = HistoryNode(withResume: "He used Nevigo for 14 days and he liked it a lot,however he had to pay 250 reais to continue using, Does he choose to pay the price?", text: "", positionX: 4, andPositionY: 2)

        let node6 = HistoryNode(withResume: "", text: "You got frustrated in the middle of disorganization and never wrote .Now let's look at the story that Joseph would have created using Teleasy.", positionX: 6, andPositionY: 3)
        let node7 = HistoryNode(withResume: "", text: "You sold a kidney to pay the value of Nevigo. Now let's look at the story that Joseph would have created using Teleasy.", positionX: 7, andPositionY: 3)
        let node8 = HistoryNode(withResume: "", text: "Joseph had to learn javascript to make his stories and became a frustrated programmer. Now let's look at the story that Joseph would have created using Teleasy.", positionX: 5, andPositionY: 3)
        let node9 = HistoryNode(withResume: "", text: "Joseph, in the middle of disorganization, got frustrated with writing. If you had chosen Teleasy, it would have been written in a much more organized and cheap way.", positionX: 8, andPositionY: 3)
        let node10 = HistoryNode(withResume: "", text: "Now that you have chosen to stop this unnecessary tree deforestation, let's choose good software for you to use", positionX: 9, andPositionY: 3)
        let node11 = HistoryNode(withResume: "", text: "Congratulations!!! you passed the first test to be a real writer, did you know that 90% of branching story writers become programmers thanks to Twine? just kidding, it's only 50%.", positionX: 4, andPositionY: 3)
        let node12 = HistoryNode(withResume: "", text: "Joseph becomes a first-rate programmer, but now he only writes in programming languages. If you had chosen Teleasy, Joseph could make stories without any prior knowledge and would not be a frustrated programmer", positionX: 3, andPositionY: 3)
        let node13 = HistoryNode(withResume: "", text: "Joseph sold a kidney and got the money to pay the Nevigo. He could avoid future hemodialysis if he had chosen Taleasy.", positionX: 2, andPositionY: 3)
        let node14 = HistoryNode(withResume: "", text: "You just saved one of Joseph's kidneys, let's choose a more affordable option now", positionX: 1, andPositionY: 3)
        
        let node18 = HistoryNode(withResume: "", text: """
            Taleasy is an inexpensive, easy-to-use app on which you can write from wherever you are: bus, subway, car. There is a very fluid interface that allows you to create the story intuitively without any prior knowledge, so much space is left to put the creativity to work.
        """, positionX: 4, andPositionY: 4)

        let node19 = HistoryNode(withResume: "", text: """
            Look how easy it was for Joseph to write this story:
            
            He can add "bits of history" and connect them as he thinks of the streams of history.
            And after all, he can "read" his story and share it with his friends.
        """, positionX: 4, andPositionY: 5)

         try? history.addNode(rootNode)
         try? history.addNode(node2)
         try? history.addNode(node3)
         try? history.addNode(node4)
         try? history.addNode(node5)
         try? history.addNode(node6)
         try? history.addNode(node7)
         try? history.addNode(node8)
         try? history.addNode(node9)
         try? history.addNode(node10)
         try? history.addNode(node11)
         try? history.addNode(node12)
         try? history.addNode(node13)
         try? history.addNode(node14)
         try? history.addNode(node17)
         try? history.addNode(node18)
         try? history.addNode(node19)
        
        try? history.addPath(fromNode: node17, toNode: rootNode, withTitle: "choose tool")
        
        try? history.addPath(fromNode: node5, toNode: node14, withTitle: "choose other software")
        try? history.addPath(fromNode: node5, toNode: node13, withTitle: "pay the price")
        
        try? history.addPath(fromNode: node3, toNode: node12, withTitle: "be a programmer")
        try? history.addPath(fromNode: node3, toNode: node11, withTitle: "choose other software")
        
        try? history.addPath(fromNode: node2, toNode: node6, withTitle: "paper")
        try? history.addPath(fromNode: node2, toNode: node7, withTitle: "nevigo")
        try? history.addPath(fromNode: node2, toNode: node8, withTitle: "twine")
        
        try? history.addPath(fromNode: node4, toNode: node9, withTitle: "keep paper")
        try? history.addPath(fromNode: node4, toNode: node10, withTitle: "choose other software")
        
        try? history.addPath(fromNode: rootNode, toNode: node5, withTitle: "nevigo")
        try? history.addPath(fromNode: rootNode, toNode: node3, withTitle: "twine")
        try? history.addPath(fromNode: rootNode, toNode: node2, withTitle: "taleasy")
        try? history.addPath(fromNode: rootNode, toNode: node4, withTitle: "paper")
        
        try? history.addPath(fromNode: node11, toNode: node18, withTitle: "taleasy introduction")
        try? history.addPath(fromNode: node12, toNode: rootNode, withTitle: "choose other software")
        try? history.addPath(fromNode: node13, toNode: node18, withTitle: "pay the price")
        try? history.addPath(fromNode: node14, toNode: rootNode, withTitle: "choose other software")
        
        try? history.addPath(fromNode: node8, toNode: node18, withTitle: "taleasy introductio")
        try? history.addPath(fromNode: node6, toNode: node18, withTitle: "taleasy introductio")
        try? history.addPath(fromNode: node7, toNode: node18, withTitle: "taleasy introductio")
        
        try? history.addPath(fromNode: node9, toNode: node18, withTitle: "keep paper")
        try? history.addPath(fromNode: node10, toNode: rootNode, withTitle: "choose other software")
        
        try? history.addPath(fromNode: node18, toNode: node19, withTitle: "show the app")
        
        return history
    }()
    
    lazy var histories: [HistoryGraph] = [
        chapeuzinhoHistory,
        joseph
    ]
}
