//
//  TesteView.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 11/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class GraphView: UIScrollView {

    var containerView = NotifierView()

    var connector = GraphViewConnector()

    var graphOperator = GraphViewOperator()

    weak var datasource: GraphViewDatasource? {
        didSet {
            if let datasource = datasource {
                build(datasource: datasource, inContainerView: containerView)
                if let delegate = graphDelegate {
                    self.setEventHandlers(delegate: delegate)
                }
            }
        }
    }
    
    weak var graphDelegate: GraphViewDelegate? {
        didSet {
            if let delegate = graphDelegate {
                setEventHandlers(delegate: delegate)
            }
        }
    }

    var lineViews: [GraphLineView] = []

    init() {
        super.init(frame: CGRect.zero)
        addSubview(containerView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addSubview(containerView)
    }

    private func prepareOperationContext(
        contextCompletion: (_ context: GraphViewOperator.Context, _ finishedCompletion: @escaping () -> Void) -> Void) {
        guard let datasource = self.datasource else {
            return
        }
        connector.removeConnectors(fromContainerView: containerView)

        self.connector = GraphViewConnector()

        let context = (graphView: self, containerView: containerView as UIView, datasource: datasource)
        contextCompletion(context) { [weak self] in
            guard let self = self else {
                return
            }
            self.connector.build(withDatasource: datasource, graphView: self, andContainerView: self.containerView)
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

    func reloadData() {
        guard let datasource = self.datasource else {
            return
        }

        containerView.removeFromSuperview()
        self.containerView = NotifierView()
        addSubview(containerView)
        setConstraints()

        build(datasource: datasource, inContainerView: containerView)
        guard let delegate = self.graphDelegate else {
            return
        }
        setEventHandlers(delegate: delegate)
    }

    func reloadConnections() {
        guard let datasource = self.datasource else {
            return
        }

        connector.removeConnectors(fromContainerView: containerView)
        connector.build(withDatasource: datasource, graphView: self, andContainerView: containerView)
    }
    
    func setEventHandlers(delegate: GraphViewDelegate) {
        lineViews.forEach { (_, currentLineView, currentLineIndex) in
            currentLineView.itemViews.forEach(completion: { (_, currentItemView, currentItemIndex) in
                let itemPosition = (yPosition: currentLineIndex, xPosition: currentItemIndex)
                guard currentItemView.eventHandler == nil, !(currentItemView is GraphItemEmptyView) else {
                    return
                }
                
                currentItemView.eventHandler = GraphViewEventHandler(
                    withItemView: currentItemView,
                    inPosition: itemPosition,
                    andGraphDelegate: delegate
                )
            })
        }
    }

    /// It builds the graphView and set it constraints.
    ///
    /// - Parameters:
    ///   - datasource: the datasource of the graph
    ///   - containerView: the containerview
    private func build(datasource: GraphViewDatasource, inContainerView containerView: UIView) {
        let numberOfLines = datasource.gridSize(forGraphView: self).height

        let lineViews = create(numberOfLines)
        insert(lineViews: lineViews, inContainerView: containerView)
        insertItemViewsIn(lineViews: lineViews, usingDatasource: datasource)
        setConstraintsFor(lineViews: lineViews, usingDatasource: datasource)
        setConstraintsForItemViewsIn(lineViews: lineViews, usingDatasource: datasource)

        self.lineViews = lineViews

        connector.removeConnectors(fromContainerView: containerView)
        connector.build(withDatasource: datasource, graphView: self, andContainerView: containerView)
    }

    /// It create the line views
    ///
    /// - Parameter numberOfLines: number of lines to create
    /// - Returns: the line views
    private func create(_ numberOfLines: Int) -> [GraphLineView] {
        return (0..<numberOfLines).map { _ -> GraphLineView in
            let lineView = GraphLineView()
            return lineView
        }
    }

    /// It gets the node views from the datasource for a given line
    ///
    /// - Parameters:
    ///   - datasource: the graph datasource
    ///   - lineIndex: the line index
    /// - Returns: the node views
    internal func getNodeViews(
        fromDatasource datasource: GraphViewDatasource,
        forLineWithIndex lineIndex: Int) -> [GraphItemView?] {

        let numberOfColumns = datasource.gridSize(forGraphView: self).width

        return (0..<numberOfColumns).map { (currentColumnIndex) -> GraphItemView? in
            let nodePosition = (xPosition: currentColumnIndex, yPosition: lineIndex)
            let nodeView = datasource.gridNodeView(forGraphView: self, inPosition: nodePosition)

            return nodeView
        }
    }

    /// It inserts the line views in a container view
    ///
    /// - Parameters:
    ///   - lineViews: the views of the graph lines
    ///   - containerView: the lines superview
    private func insert(lineViews: [GraphLineView], inContainerView containerView: UIView) {
        lineViews.forEach { (currentLineView) in
            containerView.addSubview(currentLineView)
        }
    }

    /// It inserts the node views in a given line view
    ///
    /// - Parameters:
    ///   - nodeViews: the node views to insert
    ///   - lineView: the nodes parent line
    internal func insert(nodeViews: [GraphItemView?], inLineView lineView: UIView) {
        nodeViews.forEach { (nodeView) in
            let nodeView = nodeView ?? GraphItemEmptyView()

            lineView.addSubview(nodeView)
        }
    }

    /// It inserts the node views in a list of lineViews.
    /// It will get the node views and insert in the line view for earch line.
    ///
    /// - Parameters:
    ///   - lineViews: the live views that will contain the node views
    ///   - datasource: the data source of the graph
    private func insertItemViewsIn(lineViews: [GraphLineView], usingDatasource datasource: GraphViewDatasource) {
        let numberOfLines = lineViews.count

        (0..<numberOfLines).forEach { [weak self] (currentLineViewIndex) in
            guard let self = self else {
                return
            }

            let currentLineView = lineViews[currentLineViewIndex]

            let nodeViews = self.getNodeViews(fromDatasource: datasource, forLineWithIndex: currentLineViewIndex)
            self.insert(nodeViews: nodeViews, inLineView: currentLineView)
        }
    }

    /// It sets the constrains for the given line views. Warning: the lineviews need to have a parent view.
    ///
    /// - Parameters:
    ///   - lineViews: the line views
    ///   - datasource: the graph datasource
    private func setConstraintsFor(lineViews: [GraphLineView], usingDatasource datasource: GraphViewDatasource) {
        guard let containerView = lineViews.first?.superview else {
            return
        }

        let leftSpacing = datasource.leftSpacing(forGraphView: self)

        lineViews.forEach { [weak self] (lastLineView, currentLineView, currentLineViewIndex) in
            guard let self = self else { return }

            let lineSpacing = datasource.lineSpacing(forGraphView: self)
            let lineTopAnchor = self.lineViewTopAnchor(forLastLineView: lastLineView, inContainerView: containerView)
            let leftSpacing = currentLineViewIndex.isMultiple(of: 2) ? 0 : leftSpacing

            currentLineView.hasLeftSpace = leftSpacing != 0

            currentLineView.setConstraints(
                withTopAnchor: lineTopAnchor,
                andLineMargin: lineSpacing,
                andLeftMargin: leftSpacing
            )
        }

        lineViews.last?.setClosingConstraints()
    }

    /// It sets the constraints for a list of item views
    ///
    /// - Parameters:
    ///   - itemViews: the item views list
    ///   - lineIndex: the index of the line that contains these items
    ///   - datasource: the data source of the graph
    internal func setConstraintsFor(
        itemViews: [GraphItemView],
        atLineWithIndex lineIndex: Int,
        usingDatasource datasource: GraphViewDatasource) {

        guard let lineView = itemViews.first?.parentLine else {
            return
        }

        let columnsMargin = datasource.columnSpacing(forGraphView: self)

        itemViews.forEach { [weak self] (lastItemView, currentItemView, currentColumnIndex) in
            guard let self = self else { return }

            let itemLeftAnchor = itemViewLeftAnchor(forLastItemView: lastItemView, inLineView: lineView)
            let itemWidthAnchor = datasource.columnWidth(forGraphView: self, inXPosition: currentColumnIndex)
            
            currentItemView.setConstraintsFor(
                leftAnchor: itemLeftAnchor,
                widthAnchor: itemWidthAnchor,
                columnMargin: columnsMargin
            )
        }

        if let lastItemView = itemViews.last {
            lastItemView.setClosingConstraints()
        }
    }

    /// Its sets the constraints for the item views that are inside the given line views.
    ///
    /// - Parameters:
    ///   - lineViews: the line views that contains the item views.
    ///   - datasource: the datasource of the graph
    private func setConstraintsForItemViewsIn(
        lineViews: [GraphLineView],
        usingDatasource datasource: GraphViewDatasource) {

        lineViews.forEach { (_, currentLineView, currentLineViewIndex) in
            setConstraintsFor(
                itemViews: currentLineView.itemViews,
                atLineWithIndex: currentLineViewIndex,
                usingDatasource: datasource
            )
        }
    }

    /// It determines the line view top anchor based in it posiiton in the containerView.
    ///
    /// - Parameters:
    ///   - lastLineView: the line view that appear before the lineview
    ///   - containerView: the line superview
    /// - Returns: the top anchor for the given line view
    internal func lineViewTopAnchor(
        forLastLineView lastLineView: UIView?,
        inContainerView containerView: UIView) -> NSLayoutYAxisAnchor {

        guard let lastLineView = lastLineView else {
            return containerView.topAnchor
        }
        return lastLineView.bottomAnchor
    }

    /// It determines the item view left anchor based in it position in the line view.
    ///
    /// - Parameters:
    ///   - lastItemView: the item that appear before the given item view
    ///   - lineView: the item superview
    /// - Returns: the left anchor of the given item view
    internal func itemViewLeftAnchor(
        forLastItemView lastItemView: UIView?,
        inLineView lineView: UIView) -> NSLayoutXAxisAnchor {

        guard let lastItemView = lastItemView else {
            return lineView.leftAnchor
        }
        return lastItemView.rightAnchor
    }
    
    private func setConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor)
            ])
    }

    override func didMoveToSuperview() {
        setConstraints()
    }

    func itemView(forPosition position: GridPosition) -> GraphItemView? {
        guard position.yPosition >= 0 && position.yPosition < self.lineViews.count else {
            return nil
        }

        let lineView = self.lineViews[position.yPosition]

        guard position.xPosition >= 0 && position.xPosition < lineView.itemViews.count else {
            return nil
        }

        return lineView.itemViews[position.xPosition]
    }
}
