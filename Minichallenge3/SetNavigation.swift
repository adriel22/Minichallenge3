//
//  SetNavigation.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import UIKit
// swiftlint:disable all
protocol SetNavigation: UIView {
    func setNavigation(in scrollView: UIScrollView, withTitle title: String)
}

extension SetNavigation{
    func setNavigation(in scrollView: UIScrollView, withTitle title: String){
        let navigationBar = UINavigationBar()
        navigationBar.barTintColor = UIColor(color: .darkBlue)
        navigationBar.isTranslucent = false
        navigationBar.prefersLargeTitles = true
        
        let navigationItens = UINavigationItem()
        navigationItens.title = title
        navigationItens.largeTitleDisplayMode = .automatic
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationBar.items = [navigationItens]
        
        navigationItens.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItens.rightBarButtonItem?.tintColor = UIColor.white
        scrollView.addSubview(navigationBar)
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        let navBarWidthConstraint = NSLayoutConstraint(item: navigationBar, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: 0)
        let navBarHeightConstraint = NSLayoutConstraint(item: navigationBar, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: scrollView, attribute: .height, multiplier: 0.05, constant: 0)
        navBarHeightConstraint.priority = UILayoutPriority(rawValue: 1000)
        let navBarCenteXConstraint = NSLayoutConstraint(item: navigationBar, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1, constant: 0)
        let navBarTopConstraint = NSLayoutConstraint(item: navigationBar, attribute: .top, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        let navBarBottomConstraint = NSLayoutConstraint(item: navigationBar, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: scrollView, attribute: .top, multiplier: 1, constant: UIScreen.main.bounds.height * 0.2)
        navBarBottomConstraint.priority = UILayoutPriority(rawValue: 999)
        
        self.addConstraints([navBarTopConstraint, navBarWidthConstraint, navBarCenteXConstraint, navBarHeightConstraint, navBarBottomConstraint])
        

    }
}
