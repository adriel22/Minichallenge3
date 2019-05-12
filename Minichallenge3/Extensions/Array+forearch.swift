//
//  Array+forearch.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

extension Array {
    func forEach(completion: ((Element?, Element) -> Void)) {
        var lastElement: Element?

        self.forEach { (currentElement) in
            completion(lastElement, currentElement)

            lastElement = currentElement
        }
    }
    
    func forEach(completion: ((Element?, Element, Int) -> Void)) {
        var lastElement: Element?
        var currentIndex = 0
        
        self.forEach { (currentElement) in
            completion(lastElement, currentElement, currentIndex)
            
            lastElement = currentElement
            currentIndex += 1
        }
    }
}
