//
//  GraphViewOperator.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 13/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class GraphViewOperator {

    typealias Context = (graphView: GraphView, containerView: UIView, datasource: GraphViewDatasource)

    var animator = GraphViewAnimator()

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

    func canOperateLineAt(parentLineFromPosition: GraphLineView?) -> Bool {
        let canOperateLine: Bool = (
            parentLineFromPosition == nil ||
            parentLineFromPosition!.hasConnectionChildLine == false
        )

        return canOperateLine
    }

    func isValidLine(position: Int, inGraphView graphView: GraphView, extraSize: Int = 0) -> Bool {
        let positionIsValid = position >= 0 && position < (graphView.lineViews.count + extraSize)
        return positionIsValid
    }

    func isValidColumn(position: Int, inGraphView graphView: GraphView, extraSize: Int = 0) -> Bool {
        guard let columnCount = graphView.lineViews.first?.itemViews.count else {
            return false
        }

        let positionIsValid = position >= 0 && position < (columnCount + extraSize)
        return positionIsValid
    }

    public func replace(
        items: (currentItem: GraphItemView, newItem: GraphItemView),
        atPosition position: GridPosition,
        withDatasource datasoure: GraphViewDatasource,
        andGraphView graphView: GraphView,
        completion: @escaping () -> Void) {

        let columnWidth  = datasoure.columnWidth(forGraphView: graphView, inXPosition: position.xPosition)
        let columnSpacing = datasoure.columnSpacing(forGraphView: graphView)
        let isTheLastInTheItem = position.xPosition == graphView.lineViews[position.yPosition].itemViews.count
        let positionXIsGreatherThenZero = position.xPosition > 0
        let parentLine = graphView.lineViews[position.yPosition]
        let parentItem = positionXIsGreatherThenZero ?
            graphView.lineViews[position.yPosition].itemViews[position.xPosition - 1] : nil

        items.currentItem.removeOpenConstraints()
        items.currentItem.removeClosingConstraints()
        items.currentItem.removeFromSuperview()

        parentLine.insertSubview(items.newItem, at: position.xPosition)
        items.newItem.setConstraintsFor(
            leftAnchor: graphView.itemViewLeftAnchor(
                forLastItemView: parentItem,
                inLineView: parentLine
            ),
            widthAnchor: columnWidth,
            columnMargin: columnSpacing
        )

        if isTheLastInTheItem {
            items.newItem.setClosingConstraints()
        } else {
            let childItem = graphView.lineViews[position.yPosition].itemViews[position.xPosition + 1]
            childItem.setConstraintsFor(
                leftAnchor: items.newItem.rightAnchor,
                widthAnchor: columnWidth,
                columnMargin: columnSpacing
            )
        }

        animator.animateViewInsertion(newLineView: items.newItem, completion: completion)
    }

    public func removeItem(inPosition position: GridPosition, withContext context: Context, completion: @escaping () -> Void) {

        guard isValidColumn(position: position.xPosition, inGraphView: context.graphView),
            isValidLine(position: position.yPosition, inGraphView: context.graphView) else {
                return
        }

        let newItem = GraphItemEmptyView()
        let currentItem = context.graphView.lineViews[position.yPosition].itemViews[position.xPosition]

        replace(
            items: (
                currentItem: currentItem,
                newItem: newItem
            ),
            atPosition: position,
            withDatasource: context.datasource,
            andGraphView: context.graphView,
            completion: completion
        )
    }

    public func addItem(inPosition position: GridPosition, withContext context: Context, removingCurrent: Bool, completion: @escaping () -> Void) {

        guard isValidColumn(position: position.xPosition, inGraphView: context.graphView),
              isValidLine(position: position.yPosition, inGraphView: context.graphView),
              let newItem = context.datasource.gridNodeView(forGraphView: context.graphView, inPosition: position) else {
            return
        }

        let currentItem = context.graphView.lineViews[position.yPosition].itemViews[position.xPosition]

        guard currentItem is GraphItemEmptyView || removingCurrent else {
            return
        }

        replace(
            items: (
                currentItem: currentItem,
                newItem: newItem
            ),
            atPosition: position,
            withDatasource: context.datasource,
            andGraphView: context.graphView,
            completion: completion
        )
    }

    public func removeColumn(inPosition position: Int, withContext context: Context, completion: @escaping () -> Void) {

        guard isValidColumn(position: position, inGraphView: context.graphView) else {
            return
        }

        let positionIsGreatherThenZero = position > 0
        let defaultWidthAnchor = context.datasource.columnWidth(forGraphView: context.graphView, inXPosition: position)
        let defaultColumnSpacing = context.datasource.columnSpacing(forGraphView: context.graphView)

        context.graphView.lineViews.forEach { (_, currentLine, _) in
            let parentColumnFromPosition = positionIsGreatherThenZero ? currentLine.itemViews[position - 1] : nil
            let columnToRemove = currentLine.itemViews[position]
            let hasNextLine = position + 1 < currentLine.itemViews.count
            let nextColumn = hasNextLine ? currentLine.itemViews[position + 1] : nil

            columnToRemove.removeFromSuperview()

            columnToRemove.removeOpenConstraints()
            columnToRemove.removeClosingConstraints()

            if let nextColumn = nextColumn {
                nextColumn.setConstraintsFor(leftAnchor:
                    context.graphView.itemViewLeftAnchor(
                        forLastItemView: parentColumnFromPosition,
                        inLineView: currentLine
                    ),
                    widthAnchor: defaultWidthAnchor,
                    columnMargin: defaultColumnSpacing
                )
            } else if let parentColumnFromPosition = parentColumnFromPosition {
                parentColumnFromPosition.setClosingConstraints()
            }

            animator.animateViewRemotion(containerView: context.containerView, completion: completion)
        }
    }

    public func removeLine(inPosition position: Int, withContext context: Context, completion: @escaping () -> Void) {

        guard isValidLine(position: position, inGraphView: context.graphView) else {
            return
        }

        let positionIsGreatherThenZero = position > 0
        let parentLineFromPosition = positionIsGreatherThenZero ? context.graphView.lineViews[position - 1] : nil
        let lineToRemove = context.graphView.lineViews[position]
        let hasNextLine = position + 1 < context.graphView.lineViews.count
        let nextLine = hasNextLine ? context.graphView.lineViews[position + 1] : nil
        let canRemoveLine: Bool = canOperateLineAt(parentLineFromPosition: parentLineFromPosition)
        let lineMargin = context.datasource.lineSpacing(forGraphView: context.graphView)

        guard canRemoveLine else {
            return
        }

        lineToRemove.removeFromSuperview()
        context.graphView.lineViews.remove(at: position)

        if positionIsGreatherThenZero {
            let defaultLeftMargin = context.datasource.leftSpacing(forGraphView: context.graphView)
            self.resetLinesLeftSpacing(beginAtPosition: position - 1, graphView: context.graphView, leftSpacing: defaultLeftMargin)
        }

        lineToRemove.removeOpenConstraints()
        lineToRemove.removeClosingConstraints()

        if let nextLine = nextLine {
            nextLine.setConstraints(withTopAnchor:
                context.graphView.lineViewTopAnchor(
                    forLastLineView: parentLineFromPosition,
                    inContainerView: context.containerView
                ),
                andLineMargin: lineMargin,
                andLeftMargin: nextLine.leftMargin ?? 0
            )
        } else if let parentLineFromPosition = parentLineFromPosition {
            parentLineFromPosition.setClosingConstraints()
        }

        animator.animateViewRemotion(containerView: context.containerView, completion: completion)
    }

    public func appendLine(withContext context: Context, completion: @escaping () -> Void) {

        let lastLine = context.graphView.lineViews.last
        let newLineView = GraphLineView()
        context.containerView.addSubview(newLineView)
        context.graphView.lineViews.append(newLineView)

        let lineMargin = context.datasource.lineSpacing(forGraphView: context.graphView)
        let leftMargin: CGFloat = {
            if let currentLastLine = lastLine {
                return currentLastLine.hasLeftSpace ? 0 : context.datasource.leftSpacing(forGraphView: context.graphView)
            }
            return 0.0
        }()

        lastLine?.removeClosingConstraints()
        newLineView.setConstraints(withTopAnchor:
            context.graphView.lineViewTopAnchor(
                forLastLineView: lastLine,
                inContainerView: context.containerView
            ),
            andLineMargin: lineMargin,
            andLeftMargin: leftMargin
        )

        newLineView.setClosingConstraints()

        setItems(
            inNewGraphLinew: newLineView,
            atPosition: context.graphView.lineViews.count - 1,
            inGraphView: context.graphView,
            usingDatasource: context.datasource
        )

        animator.animateViewInsertion(newLineView: newLineView, completion: completion)
    }

    func appendColumn(withContext context: Context, completion: @escaping () -> Void) {

        context.graphView.lineViews.forEach { (_, currentLine, currentLineIndex) in
            let lastItem = currentLine.itemViews.last
            let currentGridPosition = (xPosition: currentLine.itemViews.count, yPosition: currentLineIndex)
            let defaultWidth = context.datasource.columnWidth(forGraphView: context.graphView, inXPosition: currentLine.itemViews.count)
            let columnMargin = context.datasource.columnSpacing(forGraphView: context.graphView)
            let defaultLineSpacing = context.datasource.lineSpacing(forGraphView: context.graphView)
            let connectorMargins = context.graphView.connector.connectionMargin(forLineSpacing: defaultLineSpacing)
            let newItemView = loadItemView(
                fromDatasource: context.datasource, inGraphView: context.graphView,
                atPosition: currentGridPosition
            )
            currentLine.addSubview(newItemView)
            lastItem?.removeClosingConstraints()
            newItemView.setConstraintsFor(
                leftAnchor: context.graphView.itemViewLeftAnchor(
                    forLastItemView: lastItem,
                    inLineView: currentLine
                ),
                widthAnchor: defaultWidth,
                columnMargin: columnMargin
            )

            newItemView.setClosingConstraints()

            setConnections(
                withContext: context,
                position: currentGridPosition,
                andConnectorMargins: connectorMargins
            )

            animator.animateViewRemotion(containerView: context.containerView, completion: completion)
        }
    }

    public func insertLine(inPosition position: Int, withContext context: Context, completion: @escaping () -> Void) {

        guard isValidLine(position: position, inGraphView: context.graphView) else {
            return
        }

        let positionIsGreatherThenZero = position > 0
        let parentLineFromPosition = positionIsGreatherThenZero ? context.graphView.lineViews[position - 1] : nil
        let currentLineInPosition = context.graphView.lineViews[position]
        let canAddNewLine: Bool = canOperateLineAt(parentLineFromPosition: parentLineFromPosition)

        guard canAddNewLine else {
            return
        }

        let lineMargin = context.datasource.lineSpacing(forGraphView: context.graphView)
        let defaultLeftMargin = context.datasource.leftSpacing(forGraphView: context.graphView)
        let newLineLeftMargin: CGFloat = currentLineInPosition.hasLeftSpace ? 0 : defaultLeftMargin

        let newLineView = GraphLineView()

        newLineView.hasLeftSpace = newLineLeftMargin != 0

        context.containerView.insertSubview(newLineView, at: position)
        context.graphView.lineViews.insert(newLineView, at: position)

        if positionIsGreatherThenZero {
            self.resetLinesLeftSpacing(beginAtPosition: position - 1, graphView: context.graphView, leftSpacing: defaultLeftMargin)
        }

        // sets the constraints for the new line
        newLineView.setConstraints(
            withTopAnchor: context.graphView.lineViewTopAnchor(
                forLastLineView: parentLineFromPosition,
                inContainerView: context.containerView
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
            inGraphView: context.graphView,
            usingDatasource: context.datasource
        )
        
        animator.animateViewInsertion(newLineView: newLineView, completion: completion)
    }

    func loadItemView(
        fromDatasource
        datasource: GraphViewDatasource,
        inGraphView graphView: GraphView,
        atPosition position: GridPosition) -> GraphItemView {

        if let newItemView = datasource.gridNodeView(
            forGraphView: graphView,
            inPosition: position
            ) {
            return newItemView
        } else {
            return GraphItemEmptyView()
        }
    }

    func insertColumn(inPosition position: Int, withContext context: Context, completion: @escaping () -> Void) {
        guard isValidLine(position: position, inGraphView: context.graphView) else {
            return
        }

        let columnMargin = context.datasource.columnSpacing(forGraphView: context.graphView)
        let defaultWidthAnchor = context.datasource.columnWidth(forGraphView: context.graphView, inXPosition: position)
        let defaultLineSpacing = context.datasource.lineSpacing(forGraphView: context.graphView)
        let positionIsGreatherThenZero = position > 0
        let connectorMargins = context.graphView.connector.connectionMargin(forLineSpacing: defaultLineSpacing)

        context.graphView.lineViews.forEach { (_, currentLine, currentLinePosition) in
            let parentItemFromPosition = positionIsGreatherThenZero ? currentLine.itemViews[position - 1] : nil
            let currentItemInPosition = currentLine.itemViews[position]
            let currentGridPosition = (xPosition: position, yPosition: currentLinePosition)

            let newItemView = loadItemView(
                fromDatasource: context.datasource, inGraphView: context.graphView,
                atPosition: currentGridPosition
            )

            currentLine.insertSubview(newItemView, at: position)
            newItemView.setConstraintsFor(
                leftAnchor: context.graphView.itemViewLeftAnchor(
                    forLastItemView: parentItemFromPosition,
                    inLineView: currentLine
                ),
                widthAnchor: defaultWidthAnchor,
                columnMargin: columnMargin
            )

            currentItemInPosition.setConstraintsFor(
                leftAnchor: newItemView.rightAnchor,
                widthAnchor: defaultWidthAnchor,
                columnMargin: columnMargin
            )

            setConnections(
                withContext: context,
                position: currentGridPosition,
                andConnectorMargins: connectorMargins
            )

            animator.animateViewInsertion(newLineView: newItemView, completion: completion)
        }
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

    private func setConnections(withContext context: Context, position: GridPosition, andConnectorMargins connectorMargin: CGFloat) {

        let numberOfColumns = context.datasource.gridSize(forGraphView: context.graphView).width

        context.graphView.connector.addConnectionViews(
            fromConnections: context.graphView.connector.findConnection(
                atPosition: position,
                withDatasource: context.datasource,
                andGraphView: context.graphView) ?? [],
            withConnectorMargins: connectorMargin,
            connectorsOffset: context.graphView.connector.itemConnectorsOffset(
                withNumberOfColumns: numberOfColumns,
                connectorMargins: connectorMargin,
                datasource: context.datasource,
                andGraphView: context.graphView
            ) ?? 0,
            containerView: context.containerView,
            andGraphView: context.graphView
        )
    }
}
