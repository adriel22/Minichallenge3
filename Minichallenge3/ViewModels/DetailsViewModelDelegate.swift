//
//  DetailsViewModelDelegate.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 21/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import UIKit
protocol DetailsViewModelDelegate: AnyObject {
    func showAddView(_ controller: AddRamificationViewController)
    func updateView()
    
}
