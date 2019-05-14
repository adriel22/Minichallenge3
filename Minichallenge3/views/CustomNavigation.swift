//
//  CustomNavigation.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class CustomNavigation: UINavigationBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let maximunHeight = UIScreen.main.bounds.height * 0.2
    let minimunHeight = UIScreen.main.bounds.height * 0.05

    var height = UIScreen.main.bounds.height * 0.2
    private var navBarHeightConstraint: NSLayoutConstraint!

    override func didMoveToSuperview() {
        let view = self.superview!
        self.translatesAutoresizingMaskIntoConstraints = false
        let navBarWidthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        navBarHeightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height )
        let navBarCenteXConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let navBarTopConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: 0)

        view.addConstraints([navBarTopConstraint, navBarWidthConstraint, navBarCenteXConstraint, navBarHeightConstraint])

    }
    func updateHeight(_ height: CGFloat) {
        let view = self.superview!
        if height > minimunHeight && height < maximunHeight {
            view.removeConstraint(navBarHeightConstraint!)
            navBarHeightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height )
            navBarHeightConstraint!.priority = UILayoutPriority(rawValue: 1000)

            view.addConstraint(navBarHeightConstraint!)
            view.updateConstraints()
//            self.height = height
        }
        self.height = height
    }

    init(_ title: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.barTintColor = UIColor(color: .darkBlue)
        self.isTranslucent = false
        self.prefersLargeTitles = true

        let navigationItens = UINavigationItem()
        navigationItens.title = title
        navigationItens.largeTitleDisplayMode = .automatic
        self.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.items = [navigationItens]

        navigationItens.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItens.rightBarButtonItem?.tintColor = UIColor.white

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
