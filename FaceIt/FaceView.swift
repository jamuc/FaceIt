//
//  FaceView.swift
//  FaceIt
//
//  Created by Jason Franklin on 11/09/16.
//  Copyright © 2016 Jason Franklin. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {

    @IBInspectable
    var scale: CGFloat = 0.8 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }

    @IBInspectable
    var mouthCurvature: Double = 1.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyesAreClosed: Bool = false { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyeBrowTilt: Double = -1.0 { didSet { setNeedsDisplay() } }

    func scale(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            self.scale *= recognizer.scale
            recognizer.scale = 1.0
        default: break
        }
    }

    override func draw(_ rect: CGRect) {
        color.set()

        for path in [
                        pathForCenter(faceCenter, withRadius: faceRadius),
                        pathForEye(.left),
                        pathForEye(.right),
                        pathForBrow(.left),
                        pathForBrow(.right),
                        pathForMouth()
                    ] {
                        path.lineWidth = lineWidth
                        path.stroke()
                      }
    }

    // private
    fileprivate var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }

    fileprivate var faceCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    fileprivate func pathForCenter(_ center: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: center,
                            radius: radius,
                            startAngle: 0.0,
                            endAngle: CGFloat(2*M_PI),
                            clockwise: false)
        return path
    }

    fileprivate func pathForBrow(_ eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
        case .left: tilt *= -1.0
        case .right: break
        }

        var browCenter = getEyeCenter(eye)
        browCenter.y -= faceRadius / Ratios.BrowToFaceRadiusOffset
        let eyeRadius = faceRadius / Ratios.EyeToFaceRadiusScale
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        return path
    }

    fileprivate func getEyeCenter(_ eye: Eye) -> CGPoint {
        var eyeCenter = faceCenter

        eyeCenter.y -= faceRadius / Ratios.EyeToFaceCenterOffset

        switch(eye) {
        case .left: eyeCenter.x -= faceRadius / Ratios.EyeToFaceCenterOffset
        case .right: eyeCenter.x += faceRadius / Ratios.EyeToFaceCenterOffset
        }

        return eyeCenter
    }

    fileprivate func pathForEye(_ eye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / Ratios.EyeToFaceRadiusScale
        let eyeCenter = getEyeCenter(eye)

        if eyesAreClosed {
            let path = UIBezierPath()
            var eyeStart = eyeCenter
            var eyeEnd = eyeCenter

            eyeStart.x -= eyeRadius
            eyeEnd.x += eyeRadius

            path.move(to: eyeStart)
            path.addLine(to: eyeEnd)
            return path
        } else {
            return pathForCenter(eyeCenter, withRadius: eyeRadius)
        }
    }

    fileprivate func pathForMouth() -> UIBezierPath {
        let mouthWidth = faceRadius / Ratios.MouthWidthToFaceRadiusScale
        let mouthHeight = faceRadius / Ratios.MouthHeightToFaceRadiusScale
        var mouthOrigin = faceCenter

        mouthOrigin.y += faceRadius / Ratios.MouthToFaceCenterOffset
        mouthOrigin.x -= mouthWidth / 2

        let mouthRect = CGRect(x: mouthOrigin.x, y: mouthOrigin.y, width: mouthWidth, height: mouthHeight)

        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)

        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)

        return path
    }

    fileprivate enum Eye {
        case left
        case right
    }

    fileprivate struct Ratios {
        static let EyeToFaceCenterOffset = CGFloat(3.0)
        static let EyeToFaceRadiusScale = CGFloat(10.0)
        static let MouthWidthToFaceRadiusScale = CGFloat(1)
        static let MouthHeightToFaceRadiusScale = CGFloat(3)
        static let MouthToFaceCenterOffset = CGFloat(3)
        static let BrowToFaceRadiusOffset = CGFloat(5)
    }
}
