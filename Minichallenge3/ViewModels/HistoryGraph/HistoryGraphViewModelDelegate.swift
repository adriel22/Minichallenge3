//
//  HistoryGraphViewModelDelegate.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 18/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

protocol HistoryGraphViewModelDelegate: AnyObject {
    func needReloadGraph()
    func needShowViewController(_ viewController: UIViewController)
    func needFocusNode(atPosition position: GridPosition)
    func needShowError(message: String)
    func needShowAlert(title: String, message: String, action: String, cancelAction: String, completion: @escaping () -> Void)
    func needShowInputAlert(title: String, message: String, action: String, cancelAction: String, completion: @escaping (String) -> Void)
    func needDeleteNode(atPositon position: GridPosition)
    func needReloadConnection()
    func needAppendColumn()
    func needAppendLine()
    func needInsertLine(atPosition position: Int)
    func needInsertColumn(atPosition position: Int)
    func needAddNode(atPosition position: GridPosition)
    func needMoveNode(fromPosition originPosition: GridPosition, toPosition destinyPosition: GridPosition)
    func needReloadNode(atPosition position: GridPosition)
}
