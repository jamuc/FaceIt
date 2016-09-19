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
        pathForMouth().stroke()
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

    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = faceRadius / Ratios.MouthWidthToFaceRadiusScale
        let mouthHeight = faceRadius / Ratios.MouthHeightToFaceRadiusScale
        var mouthOrigin = faceCenter

        mouthOrigin.y += faceRadius / Ratios.MouthToFaceCenterOffset
        mouthOrigin.x -= mouthWidth / 2

        let mouthRect = CGRect(x: mouthOrigin.x, y: mouthOrigin.y, width: mouthWidth, height: mouthHeight)

        let mouthCurvature: Double = 1.0

        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)

        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)

        UIColor.blueColor().set()
        path.lineWidth = 5.0

        return path
    }

    private enum Eye {
        case Left
        case Right
    }

    private struct Ratios {
        static let EyeToFaceCenterOffset = CGFloat(3.0)
        static let EyeToFaceRadiusScale = CGFloat(10.0)
        static let MouthWidthToFaceRadiusScale = CGFloat(1)
        static let MouthHeightToFaceRadiusScale = CGFloat(3)
        static let MouthToFaceCenterOffset = CGFloat(3)
    }
}
