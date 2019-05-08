//
//  ViewController.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 06/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        var graph = HistoryGraph.init(withName: "bla", sinopse: "b", width: 2, andHeight: 2)
        
        let rootNode = HistoryNode.init(withResume: "bla", text: "bla bla", positionX: 1, andPositionY: 0)
        
        let node2 = HistoryNode.init(withResume: "bla2", text: "bla bla 2", positionX: 0, andPositionY: 0)
        
        print(graph.grid)
        graph.addNode(rootNode)
        print(graph.grid)
        
        graph.addNode(node2)
        print(graph.grid)
        
        
        
        graph.addConnection(fromNode: rootNode, toNode: node2, withTitle: "blablinho")
        
        
        print(graph.grid)
        print(graph)
    }
}
