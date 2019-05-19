//
//  GraphViewDelegate.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

protocol GraphViewDelegate: AnyObject {
    func itemWasSelectedAt(postion: GridPosition)
    func connectionButtonWasSelected(connection: Connection)
}
