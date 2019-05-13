//
//  DetailsViewModel.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class DetailsViewModel: NSObject {
    var story: HistoryNode
    
    init(story: HistoryNode) {
        self.story = story
    }
    
    func textUpdated(with text: String) {
        
    }
    
    func branchAdded(withNodeTitle title: String) {
        
    }
}
