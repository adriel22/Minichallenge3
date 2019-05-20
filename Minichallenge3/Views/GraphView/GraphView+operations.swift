//
//  GraphView+operations.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 19/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

extension GraphView {
    private func prepareOperationContext(
        contextCompletion: (_ context: Context, _ finishedCompletion: @escaping () -> Void) -> Void) {
        guard let datasource = self.datasource else {
            return
        }
        connector.removeConnectors(fromContainerView: containerView)

        self.connector = GraphViewConnector()

        let context = (graphView: self, containerView: containerView as UIView, datasource: datasource)
        contextCompletion(context) { [weak self] in
            guard let self = self else { return }
            self.reloadConnections()
        }
    }

    public func addLine(inPosition position: Int) {
        prepareOperationContext { (context, finishedOperationCompletion) in
            graphOperator.insertLine(inPosition: position, withContext: context, completion: finishedOperationCompletion)
        }
    }

    public func addColumn(inPosition position: Int) {
        prepareOperationContext { (context, finishedOperationCompletion) in
            graphOperator.insertColumn(inPosition: position, withContext: context, completion: finishedOperationCompletion)
        }
    }

    public func appendLine() {
        prepareOperationContext { (context, finishedOperationCompletion) in
            graphOperator.appendLine(withContext: context, completion: finishedOperationCompletion)
        }
    }

    public func appendColumn() {
        prepareOperationContext { (context, finishedOperationCompletion) in
            graphOperator.appendColumn(withContext: context, completion: finishedOperationCompletion)
        }
    }

    public func removeLine(atPosition position: Int) {
        prepareOperationContext { (context, finishedOperationCompletion) in
            graphOperator.removeLine(inPosition: position, withContext: context, completion: finishedOperationCompletion)
        }
    }

    public func removeColumn(atPosition position: Int) {
        prepareOperationContext { (context, finishedOperationCompletion) in
            graphOperator.removeColumn(inPosition: position, withContext: context, completion: finishedOperationCompletion)
        }
    }

    public func addItem(atPositon positon: GridPosition, removingCurrent: Bool = false) {
        prepareOperationContext { (context, finishedOperationCompletion) in
            graphOperator.addItem(inPosition: positon, withContext: context, removingCurrent: removingCurrent, completion: finishedOperationCompletion)
        }
    }

    public func removeItem(atPositon positon: GridPosition) {
        prepareOperationContext { (context, finishedOperationCompletion) in
            graphOperator.removeItem(inPosition: positon, withContext: context, completion: finishedOperationCompletion)
        }
    }
}
