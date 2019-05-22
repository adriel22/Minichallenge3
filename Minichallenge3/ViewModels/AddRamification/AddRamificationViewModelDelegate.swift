//
//  AddRamificationViewModelDelegate.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 21/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
protocol AddRamificationViewModelDelegate: AnyObject {
    func showKeyboard(_ notification: NSNotification)
    func hideKeyboard(_ notification: NSNotification)
}
