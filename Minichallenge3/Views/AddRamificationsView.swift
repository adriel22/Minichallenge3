//
//  AddRamificationsView.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 16/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import UIKit

class AddRamificationView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 30, width: UIScreen.main.bounds.width, height: 40))
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    lazy var segmentedControl = UISegmentedControl()
    lazy var cardName = UITextField()
    lazy var createButton = UIButton()
    lazy var cancelButton = UIButton()
    lazy var searchBar = UISearchBar()
    
    var state: RamificationViewStates = .create

    override init(frame: CGRect) {

        super.init(frame: frame)
        self.backgroundColor = UIColor.white

        self.roundCorners([.topLeft, .topRight], radius: 20)

        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5

        self.addSubview(titleLabel)
        titleLabel.text = "Adicionar ramificação"

    }

    override func layoutSubviews() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: self.superview!.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: 250).isActive = true

        configureButtons()
        configureSegmentedControl()
        configureCardName()
        configureSearchBar()
        
        self.changeState(toState: .create)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCardName() {
        self.addSubview(cardName)
        cardName.placeholder = "Nome do card"

        cardName.translatesAutoresizingMaskIntoConstraints = false
        cardName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.widthAnchor.constraint(equalTo: cardName.widthAnchor, multiplier: 1, constant: 20).isActive = true
        cardName.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        cardName.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50).isActive = true
        let line = UIView()
        self.addSubview(line)
        line.layer.borderWidth = 0.3

        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.widthAnchor.constraint(equalTo: cardName.widthAnchor, multiplier: 1).isActive = true
        line.topAnchor.constraint(equalTo: cardName.bottomAnchor).isActive = true
        line.centerXAnchor.constraint(equalTo: cardName.centerXAnchor).isActive = true
    }

    private func configureButtons() {
        self.addSubview(createButton)
        self.addSubview(cancelButton)
        createButton.backgroundColor = UIColor(color: .darkBlue)
        cancelButton.backgroundColor = UIColor(color: .red)

        createButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10

        createButton.setTitle("Criar", for: .normal)
        cancelButton.setTitle("Cancelar", for: .normal)

        createButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        createButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -20).isActive = true
        createButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        createButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true

        cancelButton.heightAnchor.constraint(equalTo: createButton.heightAnchor, multiplier: 1).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor, multiplier: 1).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: createButton.trailingAnchor, constant: 20).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: createButton.centerYAnchor).isActive = true

    }

    private func configureSegmentedControl() {
        self.addSubview(segmentedControl)

        if segmentedControl.numberOfSegments < 2 {
            segmentedControl.insertSegment(withTitle: "Criar", at: 0, animated: false)
            segmentedControl.insertSegment(withTitle: "Reusar", at: 1, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor(color: .darkBlue)

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: 140).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    func configureSearchBar() {
        self.addSubview(searchBar)
        
        searchBar.placeholder = "Nome do card"
        
        searchBar.backgroundColor = UIColor.clear
        searchBar.barTintColor = UIColor.white
        searchBar.keyboardType = .default
        searchBar.autocorrectionType = .yes
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.widthAnchor.constraint(equalTo: searchBar.widthAnchor, multiplier: 1, constant: 20).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50).isActive = true
        let line = UIView()
        self.addSubview(line)
        line.layer.borderWidth = 0.3
        
        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.widthAnchor.constraint(equalTo: searchBar.widthAnchor, multiplier: 1).isActive = true
        line.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        line.centerXAnchor.constraint(equalTo: searchBar.centerXAnchor).isActive = true
    }
    
    func changeState(toState state: RamificationViewStates) {

        if state == .create {
            cardName.isHidden = false
            searchBar.isHidden = true
            self.state = .create
        } else {
            searchBar.isHidden = false
            cardName.isHidden = true
            self.state = .reuse
        }
    }
    
}

enum RamificationViewStates {
    case create
    case reuse
}
