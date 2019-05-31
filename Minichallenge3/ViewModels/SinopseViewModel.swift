//
//  SinopseViewModel.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 20/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation

class SinopseViewModel {
    weak var delegate: SinopseViewModelDelegate?
    
    func textWasSet(text: String?) {
        guard let text = text, !text.isEmpty else {
            delegate?.needSet(text: "Tap a sinopse...")
            return
        }
        var newText = text
        if let firstCharacter = newText.first, firstCharacter != "\"" {
            newText = "\"" + newText
        }
        
        if let lastCharacter = newText.last, lastCharacter != "\"" {
            newText.append("\"")
        }
        
        delegate?.needSet(text: newText)
    }
    
    func canAdd(text: String, withCursorPosition cursorPosition: Int, andTotalText totalText: String) -> Bool {
        if cursorPosition == 0 || cursorPosition == totalText.count {
            delegate?.needSetCursor(toPosition: totalText.count - 1)
            return false
        }
        
        if text == "\n" || text == "\"" {
            delegate?.needEndEdition()
            return false
        }
        return true
    }
    
    func willEndEdition(withText text: String) {
        if text == "\"\"" || text == "\"" || text.isEmpty {
            delegate?.needSet(text: "Tap a sinopse...")
        }
    }
    
    func didBeginEdition(withText text: String) {
        if text == "Tap a sinopse..." {
            delegate?.needSet(text: "\" \"")
        }
    }
}
