//
//  ItemViewConnector.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 12/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

/// A class responsible for make views that connects two specific item views
class ItemViewConnector {
    var eventHandler: GraphViewConnectionEventHandler?
    var originLineView: GraphLineView
    var destinyLineView: GraphLineView

    var lineWidth: CGFloat

    var lineLayer: CAShapeLayer?
    
    lazy var buttonImageView: UIImageView = {
        let buttonImageView = UIImageView()
       
        return buttonImageView
    }()
    
    lazy var buttonView: UIView = {
        let buttonView = UIView()
        
        buttonView.backgroundColor = UIColor.red
        buttonView.layer.masksToBounds = true
        buttonView.clipsToBounds = true
        buttonView.layer.cornerRadius = 15
        
        return buttonView
    }()
    
    lazy var buttonViewContainer: UIView = {
        let buttonViewContainer = UIView()
        
        buttonViewContainer.layer.shadowColor = UIColor.black.cgColor
        buttonViewContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        buttonViewContainer.layer.shadowOpacity = 0.5
        
        return buttonViewContainer
    }()

    /// Initialize the view components of the connection
    ///
    /// - Parameters:
    ///   - containerView: the containerView
    ///   - lineWidth: the width of the connection line
    ///   - originLineView: the line view for the origin item
    ///   - destinyLineView: the line view for the destiny item
    init(
        withContainerView containerView: UIView,
        lineWidth: CGFloat,
        originLineView: GraphLineView,
        andDestinyLineView destinyLineView: GraphLineView) {

        self.lineWidth = lineWidth

        self.originLineView = originLineView
        self.destinyLineView = destinyLineView
        
        buttonView.addSubview(buttonImageView)
        buttonViewContainer.addSubview(buttonView)
    }
    
    func createButton(withInfo info: (image: UIImage?, color: UIColor?), inPosition position: CGPoint, inContainerView containerView: UIView) {
        guard let buttonImage = info.image else {
            return
        }
        
        if buttonViewContainer.superview == nil {
            containerView.addSubview(buttonViewContainer)
        }
        buttonViewContainer.frame.size = CGSize(width: 30, height: 30)
        buttonView.frame.size = CGSize(width: 30, height: 30)
        buttonView.center = CGPoint(x: 15, y: 15)
        buttonViewContainer.center = position
        buttonImageView.image = buttonImage
        buttonImageView.frame.size = CGSize(width: 20, height: 20)
        buttonImageView.center = CGPoint(x: 15, y: 15)
        
        guard let buttonColor = info.color else {
            return
        }
        
        buttonView.backgroundColor = buttonColor
    }

    func createLine(
        fromItemView1 originItemView: GraphItemView,
        toItemView2 destinyItemView: GraphItemView,
        withBendDistance bendDistance: CGFloat,
        andButtonInfo buttonInfo: (UIImage?, UIColor?),
        inContainerView containerView: UIView) {

        lineLayer?.removeFromSuperlayer()

        let originLineViewBottom = originLineView.frame.maxY

        let positionInContainerForOrigin = originLineView.convert(
            originItemView.center.translateToY(originItemView.frame.maxY),
            to: containerView
        )

        let positionInContainerForDestiny = destinyLineView.convert(
            destinyItemView.center.translateToY(destinyItemView.frame.minY),
            to: containerView
        )
        
        let bendYPoint = originLineViewBottom + bendDistance

        let firstBendPoint = positionInContainerForOrigin.translateToY(bendYPoint)
        let secondBendPoint = positionInContainerForOrigin.translateToY(bendYPoint).translateToX(of: positionInContainerForDestiny)
        let connectionPoints = [
            positionInContainerForOrigin, firstBendPoint, secondBendPoint, positionInContainerForDestiny
        ]

        let bezierPath = UIBezierPath()
        bezierPath.addPolygon(withPoints: connectionPoints, closePolygon: false)

        let connectorLayer = CAShapeLayer()
        connectorLayer.path = bezierPath.cgPath
        connectorLayer.strokeColor = UIColor(color: .gray).cgColor
        connectorLayer.lineWidth = lineWidth
        connectorLayer.fillColor = UIColor.clear.cgColor
        connectorLayer.lineCap = .round

        containerView.layer.insertSublayer(connectorLayer, at: 0)
        
        createButton(withInfo: buttonInfo, inPosition: secondBendPoint, inContainerView: containerView)
        
        self.lineLayer = connectorLayer
    }
    
    func setEventHandler(
        forDelegate delegate: GraphViewDelegate,
        andConnection connection: Connection,
        atGraphView graphView: GraphView) {

        guard buttonViewContainer.superview != nil else {
            return
        }
        
        eventHandler = GraphViewConnectionEventHandler(
            withConnectionView: buttonViewContainer,
            andDelegate: delegate,
            inConnectionPostion: connection,
            andGraphView: graphView
        )
    }
    
    func erase() {
        lineLayer?.removeFromSuperlayer()
        buttonViewContainer.removeFromSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
