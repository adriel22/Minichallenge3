//
//  Array+UIView.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

extension Array {
    func set<Value>(atributte: ReferenceWritableKeyPath<Element, Value>, value: Value) {

        for view in self {
            view[keyPath: atributte] = value
        }
    }

    func call(method: (Element) -> () -> Void) {
        for view in self {
            method(view)()
        }
    }
}
