//
//  GraphViewOperator.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class GraphViewOperator {

    func resetLinesLeftSpacing(beginAtPosition position: Int, graphView: GraphView, leftSpacing: CGFloat) {

        (0...position).reversed().forEach { (currentPosition) in
            let lastPosition = currentPosition + 1
            let lastLine = graphView.lineViews[lastPosition]
            let currentLine = graphView.lineViews[currentPosition]
            let currentLineLeftSpace = lastLine.hasLeftSpace ? 0 : leftSpacing
            currentLine.hasLeftSpace = (currentLineLeftSpace != 0)

            currentLine.oldLineLeftAnchor?.constant = currentLineLeftSpace
        }
    }

    func canAddOperateAt(parentLineFromPosition: GraphLineView?) -> Bool {
        let canAddNewLine: Bool = (
            parentLineFromPosition == nil ||
            parentLineFromPosition!.hasConnectionChildLine == false
        )

        return canAddNewLine
    }

    func isValid(position: Int, inGraphView graphView: GraphView, extraSize: Int = 0) -> Bool {
        let positionIsValid = position >= 0 && position < (graphView.lineViews.count + extraSize)
        return positionIsValid
    }

    func animateLineInsertion(newLineView: GraphLineView) {
        newLineView.layer.opacity = 0

        UIView.animate(withDuration: 0.2, animations: {
            newLineView.superview?.layoutIfNeeded()
        }, completion: { (_) in
            UIView.animate(withDuration: 0.2) {
                newLineView.layer.opacity = 1
            }
        })
    }

    func animateLineRemotion(containerView: UIView) {

        UIView.animate(withDuration: 0.2, animations: {
            containerView.layoutIfNeeded()
        })
    }

    public func removeLine(
        inPosition position: Int,
        inContainerView containerView: UIView,
        withDataSource datasource: GraphViewDatasource,
        andGraphView graphView: GraphView) {

        guard isValid(position: position, inGraphView: graphView) else {
            return
        }

        let positionIsGreatherThenZero = position > 0
        let parentLineFromPosition = positionIsGreatherThenZero ? graphView.lineViews[position - 1] : nil
        let lineToRemove = graphView.lineViews[position]
        let hasNextLine = position + 1 < graphView.lineViews.count
        let nextLine = hasNextLine ? graphView.lineViews[position + 1] : nil
        let canRemoveLine: Bool = canAddOperateAt(parentLineFromPosition: parentLineFromPosition)
        let lineMargin = datasource.lineSpacing(forGraphView: graphView)

        guard canRemoveLine else {
            return
        }

        lineToRemove.removeFromSuperview()
        graphView.lineViews.remove(at: position)

        if positionIsGreatherThenZero {
            let defaultLeftMargin = datasource.leftSpacing(forGraphView: graphView)
            self.resetLinesLeftSpacing(beginAtPosition: position - 1, graphView: graphView, leftSpacing: defaultLeftMargin)
        }

        lineToRemove.removeOpenConstraints()
        lineToRemove.removeClosingConstraints()

        if let nextLine = nextLine {
            nextLine.setConstraints(withTopAnchor:
                graphView.lineViewTopAnchor(
                    forLastLineView: parentLineFromPosition,
                    inContainerView: containerView
                ),
                andLineMargin: lineMargin,
                andLeftMargin: nextLine.leftMargin ?? 0
            )
        } else if let parentLineFromPosition = parentLineFromPosition {
            parentLineFromPosition.setClosingConstraints()
        }

        animateLineRemotion(containerView: containerView)
    }

    public func appendLine(
        inContainerView containerView: UIView,
        withDataSource datasource: GraphViewDatasource,
        andGraphView graphView: GraphView) {

        let lastLine = graphView.lineViews.last
        let newLineView = GraphLineView()
        containerView.addSubview(newLineView)
        graphView.lineViews.append(newLineView)

        let lineMargin = datasource.lineSpacing(forGraphView: graphView)
        let leftMargin: CGFloat = {
            if let currentLastLine = lastLine {
                return currentLastLine.hasLeftSpace ? 0 : datasource.leftSpacing(forGraphView: graphView)
            }
            return 0.0
        }()

        lastLine?.removeClosingConstraints()
        newLineView.setConstraints(withTopAnchor:
            graphView.lineViewTopAnchor(
                forLastLineView: lastLine,
                inContainerView: containerView
            ),
            andLineMargin: lineMargin,
            andLeftMargin: leftMargin
        )

        newLineView.setClosingConstraints()

        setItems(
            inNewGraphLinew: newLineView,
            atPosition: graphView.lineViews.count - 1,
            inGraphView: graphView,
            usingDatasource: datasource
        )

        animateLineInsertion(newLineView: newLineView)
    }

    public func insertLine(
        inPosition position: Int,
        inContainerView containerView: UIView,
        withDataSource datasource: GraphViewDatasource,
        andGraphView graphView: GraphView) {

        guard isValid(position: position, inGraphView: graphView) else {
            return
        }

        let positionIsGreatherThenZero = position > 0
        let parentLineFromPosition = positionIsGreatherThenZero ? graphView.lineViews[position - 1] : nil
        let currentLineInPosition = graphView.lineViews[position]
        let canAddNewLine: Bool = canAddOperateAt(parentLineFromPosition: parentLineFromPosition)

        guard canAddNewLine else {
            return
        }

        let lineMargin = datasource.lineSpacing(forGraphView: graphView)
        let defaultLeftMargin = datasource.leftSpacing(forGraphView: graphView)
        let newLineLeftMargin: CGFloat = currentLineInPosition.hasLeftSpace ? 0 : defaultLeftMargin

        let newLineView = GraphLineView()

        newLineView.hasLeftSpace = newLineLeftMargin != 0

        containerView.insertSubview(newLineView, at: position)
        graphView.lineViews.insert(newLineView, at: position)

        if positionIsGreatherThenZero {
            self.resetLinesLeftSpacing(beginAtPosition: position - 1, graphView: graphView, leftSpacing: defaultLeftMargin)
        }

        // sets the constraints for the new line
        newLineView.setConstraints(
            withTopAnchor: graphView.lineViewTopAnchor(
                forLastLineView: parentLineFromPosition,
                inContainerView: containerView
            ),
            andLineMargin: lineMargin,
            andLeftMargin: newLineLeftMargin
        )

        // if there is a other line in the position, resets it constraints
        let currentLineLeftMargin = currentLineInPosition.hasLeftSpace ? defaultLeftMargin : 0
        currentLineInPosition.setConstraints(
            withTopAnchor: newLineView.bottomAnchor,
            andLineMargin: lineMargin,
            andLeftMargin: currentLineLeftMargin
        )

        setItems(
            inNewGraphLinew: newLineView,
            atPosition: position,
            inGraphView: graphView,
            usingDatasource: datasource
        )

        animateLineInsertion(newLineView: newLineView)
    }
    
    func insertColumn() {
        
    }

    private func setItems(
        inNewGraphLinew newLineView: GraphLineView,
        atPosition position: Int,
        inGraphView graphView: GraphView,
        usingDatasource datasource: GraphViewDatasource) {

        //insert the nodeviews in the new line
        graphView.insert(
            nodeViews: graphView.getNodeViews(
                fromDatasource: datasource,
                forLineWithIndex: position
            ),
            inLineView: newLineView
        )

        // set the constraints for the new line childs
        graphView.setConstraintsFor(
            itemViews: newLineView.itemViews,
            atLineWithIndex: position,
            usingDatasource: datasource
        )
    }
}
