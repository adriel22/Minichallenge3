//
//  GraphViewAnimator.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class GraphViewAnimator {
    func animateViewInsertion(newLineView: UIView, completion: @escaping () -> Void) {
        newLineView.layer.opacity = 0

        UIView.animate(withDuration: 0.2, animations: {
            newLineView.superview?.layoutIfNeeded()
        }, completion: { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                newLineView.layer.opacity = 1
            }, completion: { (done) in
                guard done else {
                    return
                }
                completion()
            })
        })
    }

    func animateViewRemotion(containerView: UIView, completion: @escaping () -> Void) {

        UIView.animate(withDuration: 0.2, animations: {
            containerView.layoutIfNeeded()
        }, completion: {(_) in
            completion()
        })
    }
}
