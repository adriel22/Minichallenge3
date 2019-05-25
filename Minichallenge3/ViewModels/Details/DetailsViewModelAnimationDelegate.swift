//
//  DetailsViewModelAnimationDelegate.swift
//  Minichallenge3
//
//  Created by João Pedro Aragão on 25/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

protocol DetailsViewModelAnimationDelegate: class {
    func shouldAnimateUpnodeView() -> Bool
    func shouldAnimateDownnodeView() -> Bool
}
