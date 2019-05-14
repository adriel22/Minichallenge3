//
//  KeyboardObserver.swift
//  foods_nano_challenge
//
//  Created by João Pedro Aragão on 24/10/18.
//  Copyright © 2018 João Pedro Aragão. All rights reserved.
//

import UIKit

/// Handles the move of some view according to the keyboard
class KeyboardObserver {
    
    /// View which will be moved up or down, according to the keyboard
    private static var view: UIView?
    private static var toolBarHeight: CGFloat = 0

    /// Function which adds the actions for when keyboardWillShowNotification
    /// or keyboardWillHideNotification be called and sets the view which will
    /// be moved up or down
    ///
    /// - Parameter view: View which will be moved up or down, according to the keyboard
    public static func addObservers(onView view: UIView, toolBarHeight: CGFloat = 0) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        KeyboardObserver.view = view
        KeyboardObserver.toolBarHeight = toolBarHeight
    }
    
    /// Function which removes the actions previously set by
    /// **KeyboardObserver.addObservers(onView view: UIView)**
    ///
    public static func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        KeyboardObserver.view = nil
        KeyboardObserver.toolBarHeight = 0
    }
    
    /// Moves the view up when the keyboard shows up
    ///
    /// - Parameter sender: Keyboard notification
    @objc private static func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            KeyboardObserver.view!.frame.origin.y -= (keyboardSize.height + KeyboardObserver.toolBarHeight)
            print(keyboardSize.height)
        }
    }
    
    /// Moves the view down when the keyboard it's dismissed
    ///
    /// - Parameter sender: Keyboard notification
    @objc private static func keyboardWillHide(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            KeyboardObserver.view!.frame.origin.y += (keyboardSize.height + KeyboardObserver.toolBarHeight)
            print(keyboardSize.height)
        }
    }
    
}
