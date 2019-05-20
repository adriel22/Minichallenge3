//
//  ShortcutViewDataSource.swift
//  Minichallenge3
//
//  Created by Alan Victor Paulino de Oliveira on 19/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import UIKit

protocol ShortcutViewDataSource: class {
    func widthLine(forShortcutView: ShortcutView) -> CGFloat
    func hasParent(forShortcutView: ShortcutView) -> Bool
}
