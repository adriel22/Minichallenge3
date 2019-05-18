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

    func animateViewInsertion(newLineView: UIView, completion: @escaping () -> Void) {
        newLineView.layer.opacity = 0

        UIView.animate(withDuration: 0.2, animations: {
            newLineView.superview?.layoutIfNeeded()
        }, completion: { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                newLineView.layer.opacity = 1
            }, completion: { (_) in
                completion()
            })
        })
    }

    func animateViewRemotion(containerView: UIView) {

        UIView.animate(withDuration: 0.2, animations: {
            containerView.layoutIfNeeded()
        })
    }

    public func replace(
        item1: GraphItemView, andItem2 item2: GraphItemView,
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

        item1.removeOpenConstraints()
        item1.removeClosingConstraints()
        item1.removeFromSuperview()

        parentLine.insertSubview(item2, at: position.xPosition)
        item2.setConstraintsFor(
            leftAnchor: graphView.itemViewLeftAnchor(
                forLastItemView: parentItem,
                inLineView: parentLine
            ),
            widthAnchor: columnWidth,
            columnMargin: columnSpacing
        )

        if isTheLastInTheItem {
            item2.setClosingConstraints()
        } else {
            let childItem = graphView.lineViews[position.yPosition].itemViews[position.xPosition + 1]
            childItem.setConstraintsFor(
                leftAnchor: item2.rightAnchor,
                widthAnchor: columnWidth,
                columnMargin: columnSpacing
            )
        }

        animateViewInsertion(newLineView: item2, completion: completion)
    }

    public func removeItem(
        inPosition position: GridPosition,
        inContainerView containerView: UIView,
        withDatasource datasoure: GraphViewDatasource,
        andGraphView graphView: GraphView,
        completion: @escaping () -> Void) {

        guard isValidColumn(position: position.xPosition, inGraphView: graphView),
            isValidLine(position: position.yPosition, inGraphView: graphView) else {
                return
        }

        let newItem = GraphItemEmptyView()
        let currentItem = graphView.lineViews[position.yPosition].itemViews[position.xPosition]

        replace(
            item1: currentItem,
            andItem2: newItem,
            atPosition: position,
            withDatasource: datasoure,
            andGraphView: graphView,
            completion: completion
        )
    }

    public func addItem(
        inPosition position: GridPosition,
        inContainerView containerView: UIView,
        withDatasource datasoure: GraphViewDatasource,
        andGraphView graphView: GraphView,
        removingCurrent: Bool,
        completion: @escaping () -> Void) {

        guard isValidColumn(position: position.xPosition, inGraphView: graphView),
              isValidLine(position: position.yPosition, inGraphView: graphView),
              let newItem = datasoure.gridNodeView(forGraphView: graphView, inPosition: position) else {
            return
        }

        let currentItem = graphView.lineViews[position.yPosition].itemViews[position.xPosition]

        guard currentItem is GraphItemEmptyView || removingCurrent else {
            return
        }

        replace(
            item1: currentItem,
            andItem2: newItem,
            atPosition: position,
            withDatasource: datasoure,
            andGraphView: graphView,
            completion: completion
        )
    }

    public func removeColumn(
        inPosition position: Int,
        inContainerView containerView: UIView,
        withDataSource datasource: GraphViewDatasource,
        andGraphView graphView: GraphView) {

        guard isValidColumn(position: position, inGraphView: graphView) else {
            return
        }

        let positionIsGreatherThenZero = position > 0
        let defaultWidthAnchor = datasource.columnWidth(forGraphView: graphView, inXPosition: position)
        let defaultColumnSpacing = datasource.columnSpacing(forGraphView: graphView)

        graphView.lineViews.forEach { (_, currentLine, _) in
            let parentColumnFromPosition = positionIsGreatherThenZero ? currentLine.itemViews[position - 1] : nil
            let columnToRemove = currentLine.itemViews[position]
            let hasNextLine = position + 1 < currentLine.itemViews.count
            let nextColumn = hasNextLine ? currentLine.itemViews[position + 1] : nil

            columnToRemove.removeFromSuperview()

            columnToRemove.removeOpenConstraints()
            columnToRemove.removeClosingConstraints()

            if let nextColumn = nextColumn {
                nextColumn.setConstraintsFor(leftAnchor:
                    graphView.itemViewLeftAnchor(
                        forLastItemView: parentColumnFromPosition,
                        inLineView: currentLine
                    ),
                    widthAnchor: defaultWidthAnchor,
                    columnMargin: defaultColumnSpacing
                )
            } else if let parentColumnFromPosition = parentColumnFromPosition {
                parentColumnFromPosition.setClosingConstraints()
            }

            animateViewRemotion(containerView: containerView)
        }
    }

    public func removeLine(
        inPosition position: Int,
        inContainerView containerView: UIView,
        withDataSource datasource: GraphViewDatasource,
        andGraphView graphView: GraphView) {

        guard isValidLine(position: position, inGraphView: graphView) else {
            return
        }

        let positionIsGreatherThenZero = position > 0
        let parentLineFromPosition = positionIsGreatherThenZero ? graphView.lineViews[position - 1] : nil
        let lineToRemove = graphView.lineViews[position]
        let hasNextLine = position + 1 < graphView.lineViews.count
        let nextLine = hasNextLine ? graphView.lineViews[position + 1] : nil
        let canRemoveLine: Bool = canOperateLineAt(parentLineFromPosition: parentLineFromPosition)
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

        animateViewRemotion(containerView: containerView)
    }

    public func appendLine(
        inContainerView containerView: UIView,
        withDataSource datasource: GraphViewDatasource,
        andGraphView graphView: GraphView,
        completion: @escaping () -> Void) {

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

        animateViewInsertion(newLineView: newLineView, completion: completion)
    }

    func appendColumn(
        inContainerView containerView: UIView,
        withDataSource datasource: GraphViewDatasource,
        andGraphView graphView: GraphView) {

        graphView.lineViews.forEach { (_, currentLine, currentLineIndex) in
            let lastItem = currentLine.itemViews.last
            let currentGridPosition = (xPosition: currentLine.itemViews.count, yPosition: currentLineIndex)
            let defaultWidth = datasource.columnWidth(forGraphView: graphView, inXPosition: currentLine.itemViews.count)
            let columnMargin = datasource.columnSpacing(forGraphView: graphView)
            let defaultLineSpacing = datasource.lineSpacing(forGraphView: graphView)
            let connectorMargins = graphView.connector?.connectionMargin(forLineSpacing: defaultLineSpacing) ?? 0
            let newItemView = loadItemView(
                fromDatasource: datasource, inGraphView: graphView,
                atPosition: currentGridPosition
            )
            currentLine.addSubview(newItemView)
            lastItem?.removeClosingConstraints()
            newItemView.setConstraintsFor(
                leftAnchor: graphView.itemViewLeftAnchor(
                    forLastItemView: lastItem,
                    inLineView: currentLine
                ),
                widthAnchor: defaultWidth,
                columnMargin: columnMargin
            )

            newItemView.setClosingConstraints()

            setConnections(
                graphView: graphView,
                usingDatasource: datasource,
                forGridPosition: currentGridPosition,
                withConnectorMargins: connectorMargins,
                andContainerView: containerView
            )

            animateViewRemotion(containerView: containerView)
        }
    }

    public func insertLine(
        inPosition position: Int,
        inContainerView containerView: UIView,
        withDataSource datasource: GraphViewDatasource,
        andGraphView graphView: GraphView,
        completion: @escaping () -> Void) {

        guard isValidLine(position: position, inGraphView: graphView) else {
            return
        }

        let positionIsGreatherThenZero = position > 0
        let parentLineFromPosition = positionIsGreatherThenZero ? graphView.lineViews[position - 1] : nil
        let currentLineInPosition = graphView.lineViews[position]
        let canAddNewLine: Bool = canOperateLineAt(parentLineFromPosition: parentLineFromPosition)

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

        animateViewInsertion(newLineView: newLineView, completion: completion)
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

    func insertColumn(
        inPosition position: Int,
        inContainerView containerView: UIView,
        withDataSource datasource: GraphViewDatasource,
        andGraphView graphView: GraphView,
        completion: @escaping () -> Void) {

        guard isValidLine(position: position, inGraphView: graphView) else {
            return
        }

        let columnMargin = datasource.columnSpacing(forGraphView: graphView)
        let defaultWidthAnchor = datasource.columnWidth(forGraphView: graphView, inXPosition: position)
        let defaultLineSpacing = datasource.lineSpacing(forGraphView: graphView)
        let positionIsGreatherThenZero = position > 0
        let connectorMargins = graphView.connector?.connectionMargin(forLineSpacing: defaultLineSpacing) ?? 0

        graphView.lineViews.forEach { (_, currentLine, currentLinePosition) in
            let parentItemFromPosition = positionIsGreatherThenZero ? currentLine.itemViews[position - 1] : nil
            let currentItemInPosition = currentLine.itemViews[position]
            let currentGridPosition = (xPosition: position, yPosition: currentLinePosition)

            let newItemView = loadItemView(
                fromDatasource: datasource, inGraphView: graphView,
                atPosition: currentGridPosition
            )

            currentLine.insertSubview(newItemView, at: position)
            newItemView.setConstraintsFor(
                leftAnchor: graphView.itemViewLeftAnchor(
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
                graphView: graphView,
                usingDatasource: datasource,
                forGridPosition: currentGridPosition,
                withConnectorMargins: connectorMargins,
                andContainerView: containerView
            )

            animateViewInsertion(newLineView: newItemView, completion: completion)
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

    private func setConnections(
        graphView: GraphView,
        usingDatasource datasource: GraphViewDatasource,
        forGridPosition position: GridPosition,
        withConnectorMargins connectorMargin: CGFloat,
        andContainerView containerView: UIView) {

        let numberOfColumns = datasource.gridSize(forGraphView: graphView).width

        graphView.connector?.addConnectionViews(
            fromConnections: graphView.connector?.findConnection(
                atPosition: position,
                withDatasource: datasource,
                andGraphView: graphView) ?? [],
            withConnectorMargins: connectorMargin,
            connectorsOffset: graphView.connector?.itemConnectorsOffset(
                withNumberOfColumns: numberOfColumns,
                connectorMargins: connectorMargin,
                datasource: datasource,
                andGraphView: graphView
            ) ?? 0,
            containerView: containerView,
            andGraphView: graphView
        )
    }
}
