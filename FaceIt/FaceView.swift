//
//  FaceView.swift
//  FaceIt
//
//  Created by Jason Franklin on 11/09/16.
//  Copyright © 2016 Jason Franklin. All rights reserved.
//

import UIKit

class FaceView: UIView {

    override func drawRect(rect: CGRect) {
        let faceRadius = min(bounds.size.width, bounds.size.height) / 2
        let faceCenter = CGPoint(x: bounds.midX, y: bounds.midY)

        let path = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: false)

        UIColor.blueColor().set()
        path.lineWidth = 5.0
        path.stroke()
    }
}
