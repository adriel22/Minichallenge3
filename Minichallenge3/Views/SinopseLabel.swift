//
//  SinopseLabel.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class SinopseTextView: UITextView {
    weak var sinopseDelegate: SinopseDelegate?
    
    lazy var viewModel: SinopseViewModel = {
        let viewModel = SinopseViewModel()
        
        viewModel.delegate = self
        
        return viewModel
    }()
    
    override var text: String? {
        set {
            viewModel.textWasSet(text: newValue)
        }
        get {
            return super.text
        }
    }
    
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        font = UIFont(name: "Baskerville", size: CGFloat(17))
        textAlignment = .center
        textColor = UIColor(color: .darkBlue)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clear
        delegate = self
        textContainer.maximumNumberOfLines = 2
        textContainer.lineBreakMode = .byTruncatingTail
    }
    
    func cursorPosition() -> Int? {
        guard let rangeStart = selectedTextRange?.start else {
            return nil
        }
        
        let cursorPosition = offset(from: beginningOfDocument, to: rangeStart)
        
        return cursorPosition
    }
}

extension SinopseTextView: SinopseViewModelDelegate {
    func needCurrentText() -> String {
        return self.text ?? ""
    }
    
    func needSetCursor(toPosition positionOffset: Int) {
        if let positionOfCursor = position(from: beginningOfDocument, offset: positionOffset) {
            
            self.selectedTextRange = self.textRange(from: positionOfCursor, to: positionOfCursor)
        }
    }
    
    func needEndEdition() {
        self.resignFirstResponder()
    }
    
    func needSet(text: String) {
        super.text = text
        sinopseDelegate?.textWasEdited(text: text)
    }
}

extension SinopseTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        viewModel.textWasSet(text: textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let cursorPosition = cursorPosition(), let totalText = self.text else {
            return false
        }
        
        return viewModel.canAdd(text: text, withCursorPosition: cursorPosition, andTotalText: totalText)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel.willEndEdition(withText: textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        viewModel.didBeginEdition(withText: textView.text)
    }
}
