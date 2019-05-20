//
//  NotifierView.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class NotifierView: UIView {
    var didLayoutSubViewsCompletions: [(() -> Void)] = []

    override func layoutSubviews() {
        super.layoutSubviews()
        didLayoutSubViewsCompletions.forEach { (completion) in
            completion()
        }
    }

    /// Wait for the layout of subviews of two views
    ///
    /// - Parameters:
    ///   - item1: the first view
    ///   - item2: the second view
    ///   - completion: a completion called when the layout happens
    static public func waitForSubviewLayout(
        view1: NotifierView,
        view2: NotifierView,
        completion: @escaping () -> Void) {
        
        var line1WasLayout = false
        var line2WasLayout = false

        view1.didLayoutSubViewsCompletions.append {
            line1WasLayout = true
            if line2WasLayout {
                completion()
                line2WasLayout = false
                line1WasLayout = false
            }
        }

        view2.didLayoutSubViewsCompletions.append {
            line2WasLayout = true
            if line1WasLayout {
                completion()
                line2WasLayout = false
                line1WasLayout = false
            }
        }
    }
}
