//
//  TesteView.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 11/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class GraphView: UIScrollView {

    var containerView = UIView()

    var datasource: GraphViewDatasource? {
        didSet {
            if let datasource = datasource {
                build(withDatasource: datasource, inContainerView: containerView)
            }
        }
    }

    var gridLineViews: [UIView] = []

    init() {
        super.init(frame: CGRect.zero)
        addSubview(containerView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addSubview(containerView)
    }

    @discardableResult
    private func build(
        withDatasource dataSource: GraphViewDatasource,
        inContainerView containerView: UIView) -> [UIView?] {

        let gridSize = dataSource.gridSize(forGraphView: self)
        let linesRange = 0..<gridSize.height

        var lastLineView: UIView?

        let lineViews =  linesRange.map { [weak self] (currentLineIndex) -> UIView? in

            guard let self = self else {
                return nil
            }

            let lineView = self.insertColumns(
                inLineView: self.buildLine(
                    withTopAnchor: lineViewTopAnchor(
                        forLastLineView: lastLineView,
                        inContainerView: containerView
                    ),
                    andLineMargin: dataSource.lineSpacing(forGraphView: self),
                    inContainerView: containerView
                ),
                atIndex: currentLineIndex,
                withDataSource: dataSource
            )

            lastLineView = lineView

            return lineView
        }

        if let lastLineView = lastLineView {
            containerView.bottomAnchor.constraint(equalTo: lastLineView.bottomAnchor).isActive = true
            containerView.rightAnchor.constraint(equalTo: lastLineView.rightAnchor).isActive = true
        }

        return lineViews
    }

    private func lineViewTopAnchor(
        forLastLineView lastLineView: UIView?,
        inContainerView containerView: UIView) -> NSLayoutYAxisAnchor {

        guard let lastLineView = lastLineView else {
            return containerView.topAnchor
        }
        return lastLineView.bottomAnchor
    }

    private func buildLine(
        withTopAnchor topAnchor: NSLayoutYAxisAnchor,
        andLineMargin lineMargin: CGFloat,
        inContainerView contaienrView: UIView) -> UIView {

        let lineView = UIView.init()
        contaienrView.addSubview(lineView)

        lineView.translatesAutoresizingMaskIntoConstraints = false

        let lineViewHeightConstraint = lineView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150)
        lineViewHeightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: topAnchor, constant: lineMargin),
            lineView.leftAnchor.constraint(equalTo: contaienrView.leftAnchor),
            lineViewHeightConstraint
        ])

        return lineView
    }

    private func insertColumns(
        inLineView lineView: UIView?,
        atIndex lineIndex: Int,
        withDataSource dataSource: GraphViewDatasource) -> UIView? {

        guard let lineView = lineView else {
            return nil
        }

        let gridSize = dataSource.gridSize(forGraphView: self)
        let columnsRange = 0..<gridSize.width
        let columnsMargin = dataSource.columnSpacing(forGraphView: self)

        var lastItemView: UIView?

        columnsRange.forEach { [weak self] currentColumnIndex in
            guard let self = self else {
                return
            }

            let itemPosition = (lineIndex, currentColumnIndex)
            let itemView = dataSource.gridNodeView(forGraphView: self, inPosition: itemPosition) ?? UIView()
            let itemLeftAnchor = itemViewLeftAnchor(forLastItemView: lastItemView, inLineView: lineView)
            let itemViewWidthAnchor = dataSource.columnWidth(forGraphView: self, inXPosition: currentColumnIndex)

            lineView.addSubview(itemView)

            self.setItemViewConstraints(
                itemView: itemView,
                leftAnchor: itemLeftAnchor,
                widthAnchor: itemViewWidthAnchor,
                columnMargin: columnsMargin,
                inLineView: lineView
            )

            lastItemView = itemView
        }

        if let lastItemView = lastItemView {
            lineView.rightAnchor.constraint(equalTo: lastItemView.rightAnchor).isActive = true
        }

        return lineView
    }

    private func itemViewLeftAnchor(
        forLastItemView lastItemView: UIView?,
        inLineView lineView: UIView) -> NSLayoutXAxisAnchor {

        guard let lastItemView = lastItemView else {
            return lineView.leftAnchor
        }
        return lastItemView.rightAnchor
    }

    private func setItemViewConstraints(
        itemView: UIView,
        leftAnchor: NSLayoutXAxisAnchor,
        widthAnchor: CGFloat,
        columnMargin: CGFloat,
        inLineView lineView: UIView) {

        itemView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            itemView.widthAnchor.constraint(equalToConstant: widthAnchor),
            itemView.leftAnchor.constraint(equalTo: leftAnchor, constant: columnMargin),
            itemView.topAnchor.constraint(equalTo: lineView.topAnchor),
            itemView.bottomAnchor.constraint(lessThanOrEqualTo: lineView.bottomAnchor)
        ])
    }

    override func didMoveToSuperview() {

        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}
