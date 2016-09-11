//
//  FaceView.swift
//  FaceIt
//
//  Created by Jason Franklin on 11/09/16.
//  Copyright © 2016 Jason Franklin. All rights reserved.
//

import UIKit

class FaceView: UIView {

    let scale = CGFloat(0.8)

    override func drawRect(rect: CGRect) {
        pathForCenter(faceCenter, withRadius: faceRadius)
            .stroke()
        pathForEye(.Left).stroke()
        pathForEye(.Right).stroke()
    }

    // private
    private var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }

    private var faceCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    private func pathForCenter(center: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: center,
                            radius: radius,
                            startAngle: 0.0,
                            endAngle: CGFloat(2*M_PI),
                            clockwise: false)
        UIColor.blueColor().set()
        path.lineWidth = 5.0
        return path
    }

    private func pathForEye(eye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / Ratios.EyeToFaceRadiusScale
        var eyeCenter = faceCenter

        eyeCenter.y -= faceRadius / Ratios.EyeToFaceCenterOffset

        switch(eye) {
        case .Left: eyeCenter.x -= faceRadius / Ratios.EyeToFaceCenterOffset
        case .Right: eyeCenter.x += faceRadius / Ratios.EyeToFaceCenterOffset
        }

        return pathForCenter(eyeCenter, withRadius: eyeRadius)
    }

    private enum Eye {
        case Left
        case Right
    }

    private struct Ratios {
        static let EyeToFaceCenterOffset = CGFloat(3.0)
        static let EyeToFaceRadiusScale = CGFloat(10.0)
    }
}
