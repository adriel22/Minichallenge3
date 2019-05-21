//
//  ShortcutView.swift
//  Minichallenge3
//
//  Created by Alan Victor Paulino de Oliveira on 16/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class ShortcutView: GraphItemView, CardViewProtocol {
    
    private var heightCircleView: CGFloat = 64
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "shortcut") {
            imageView.image = image
        } else {
            imageView.backgroundColor = .blue
        }
        return imageView
    }()
    
    private lazy var circleView: UIView = {
        let frame = CGRect(x: 0, y: 0, width: self.heightCircleView, height: self.heightCircleView)
        let view = UIView(frame: frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(color: .red)
        view.layer.cornerRadius = self.heightCircleView / 2
        view.layer.masksToBounds = true
        return view
        }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public weak var delegate: ShortcutViewDelegate?
    public weak var datasource: ShortcutViewDataSource? {
        didSet {
            guard let datasource = self.datasource else {
                return
            }
            
            self.lineView.backgroundColor = datasource.lineColor(forShortcutView: self)
        }
    }
    public var hasParent: Bool = true {
        didSet {
            hasLineToParent(hasParent: hasParent)
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        addSubview(lineView)
        addSubview(circleView)
        circleView.addSubview(imageView)
        
        setContraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapInShortcut))
        
        circleView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func setContraints() {
        //constraints to backgroundView from cicleView
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: 150)
        heightConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: self.heightCircleView),
            circleView.heightAnchor.constraint(equalToConstant: self.heightCircleView),
            heightConstraint
            ])
        //constraints to cicleView from imageView
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: circleView.heightAnchor, multiplier: 0.7),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
        //constraints to lineView from circleview
        let lineWidth = datasource?.widthLine(forShortcutView: self) ?? 3
        NSLayoutConstraint.activate([
            lineView.widthAnchor.constraint(equalToConstant: lineWidth),
            lineView.topAnchor.constraint(equalTo: self.topAnchor),
            lineView.bottomAnchor.constraint(equalTo: circleView.centerYAnchor),
            lineView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
    }
    
    func hasLineToParent(hasParent: Bool) {
        if hasParent {
            lineView.topAnchor.constraint(equalTo: self.topAnchor)
        } else {
            lineView.topAnchor.constraint(equalTo: circleView.centerYAnchor)
        }
    }
    
    @objc func tapInShortcut() {
        delegate?.tapInShortcut(self)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func setup(withViewModel viewModel: HistoryNodeViewModel) {
        
    }
}
