//
//  Array+set+call.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

extension Array {
    func set<Value>(atributte: ReferenceWritableKeyPath<Element, Value>, value: Value) {
        for element in self {
            element[keyPath: atributte] = value
        }
    }

    func call(method: (Element) -> () -> Void) {
        for element in self {
            method(element)()
        }
    }
}
