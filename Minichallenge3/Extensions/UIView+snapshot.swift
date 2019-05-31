//
//  UIView+snapshot.swift
//  Minichallenge3
//
//  Created by Elias Paulino on 29/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

extension UIView {
    var snapshot: UIView {
        let selfShadowAtributtes = self.shadowAtributtes
        //remove shadow to draw the view hierarchy
        self.layer.shadowOpacity = 0
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView.init()
        imageView.bounds = self.bounds
        imageView.image = image
        imageView.center = self.center
        
        //place the shadow back
        
        self.layer.shadowOpacity = selfShadowAtributtes.opacity
        imageView.shadowAtributtes = selfShadowAtributtes
    
        return imageView
    }
}
