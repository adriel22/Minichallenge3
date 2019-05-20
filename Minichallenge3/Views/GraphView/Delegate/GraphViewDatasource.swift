//
//  GraphViewDatasource.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import Foundation
import UIKit

typealias GridSize = (width: Int, height: Int)
public typealias GridPosition = (yPosition: Int, xPosition: Int)

protocol GraphViewDatasource: AnyObject {

    func gridSize(forGraphView graphView: GraphView) -> GridSize
    func gridNodeView(forGraphView graphView: GraphView, inPosition position: GridPosition) -> GraphItemView?
    func columnWidth(forGraphView graphView: GraphView, inXPosition xPosition: Int) -> CGFloat
    func lineSpacing(forGraphView graphView: GraphView) -> CGFloat
    func columnSpacing(forGraphView graphView: GraphView) -> CGFloat
    func leftSpacing(forGraphView graphView: GraphView) -> CGFloat
    func connectionWidth(forGraphView graphView: GraphView) -> CGFloat
    func connectionsImage(forGraphView graphView: GraphView) -> UIImage?
    func connectionButtonColor(forGraphView graphView: GraphView) -> UIColor?
    func connections(forGraphView graphView: GraphView, fromItemAtPosition itemPosition: GridPosition) -> [GridPosition]
}
