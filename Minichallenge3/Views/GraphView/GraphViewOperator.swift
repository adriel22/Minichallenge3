//
//  GraphViewOperator.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class GraphViewOperator {

    func resetLinesLeftSpacing() {

    }

    func canAddNewLineAt(position: Int, parentLineFromPosition: GraphLineView?) -> Bool {
        let canAddNewLine: Bool = parentLineFromPosition == nil ||
            parentLineFromPosition!.hasConnectionChildLine == false

        return canAddNewLine
    }

    public func addLine(
        inPosition position: Int,
        inContainerView containerView: UIView,
        withDataSource datasource: GraphViewDatasource,
        andGraphView graphView: GraphView) {

        let parentLineFromPosition = position > 0 ? graphView.lineViews[position - 1] : nil
        let currentLineInPosition = graphView.lineViews[position]
        let canAddNewLine: Bool = canAddNewLineAt(position: position, parentLineFromPosition: parentLineFromPosition)

        guard canAddNewLine else {
            return
        }

        let lineMargin = datasource.lineSpacing(forGraphView: graphView)
        let defaultLeftMargin = datasource.leftSpacing(forGraphView: graphView)
        let newLineLeftMargin = currentLineInPosition.hasLeftSpace ? 0 : defaultLeftMargin
        let currentLineLeftMargin = currentLineInPosition.hasLeftSpace ? defaultLeftMargin : 0
        let newLineView = GraphLineView()

        newLineView.hasLeftSpace = newLineLeftMargin != 0

        containerView.insertSubview(newLineView, at: position)
        graphView.lineViews.insert(newLineView, at: position)

        newLineView.setConstraints(
            withTopAnchor: graphView.lineViewTopAnchor(
                forLastLineView: parentLineFromPosition,
                inContainerView: containerView
            ),
            andLineMargin: lineMargin,
            andLeftMargin: newLineLeftMargin
        )

        currentLineInPosition.setConstraints(
            withTopAnchor: newLineView.bottomAnchor,
            andLineMargin: lineMargin,
            andLeftMargin: currentLineLeftMargin
        )

        graphView.insert(
            nodeViews: graphView.getNodeViews(
                fromDatasource: datasource,
                forLineWithIndex: position
            ),
            inLineView: newLineView
        )

        graphView.setConstraintsFor(
            itemViews: newLineView.itemViews,
            atLineWithIndex: position,
            usingDatasource: datasource
        )

        newLineView.layer.opacity = 0

        UIView.animate(withDuration: 0.2, animations: {
            containerView.layoutIfNeeded()
        }, completion: { (_) in
            UIView.animate(withDuration: 0.2) {
                newLineView.layer.opacity = 1
            }
        })
    }
}
