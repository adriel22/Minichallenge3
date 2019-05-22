//
//  SinopseViewModelDelegate.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 20/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

protocol SinopseViewModelDelegate: AnyObject {
    func needSet(text: String)
    func needEndEdition()
    func needSetCursor(toPosition position: Int)
}
