//
//  DAO.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

protocol DAO {
    associatedtype Element
    
    func getAll() -> [Element]
    func save(element: Element)
    func delete(element: Element)
    func get(elementWithID daoID: Int) -> Element
    func update(element: Element, withID identifier: Int)
}
