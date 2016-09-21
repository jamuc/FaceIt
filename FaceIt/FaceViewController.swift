//
//  ViewController.swift
//  FaceIt
//
//  Created by Jason Franklin on 11/09/16.
//  Copyright © 2016 Jason Franklin. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView! {
        didSet {
            redrawUI()
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.scale(_:))))

            var recognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.upSwipe(_:)))
            recognizer.direction = .up
            faceView.addGestureRecognizer(recognizer)

            recognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.downSwipe(_:)))
            recognizer.direction = .down
            faceView.addGestureRecognizer(recognizer)

        }
    }

    var expression = FacialExpressions(eyes: FacialExpressions.Eyes.open,
                                        brows: FacialExpressions.EyeBrows.forrowed,
                                        mouth: FacialExpressions.Mouth.smirk) {
        didSet {
            redrawUI()
        }
    }

    @IBAction func tap(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            switch expression.eyes {
            case .open: expression.eyes = .closed
            case .closed: expression.eyes = .open
            }
        }
    }

    func upSwipe(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            expression.mouth = expression.mouth.agitateMouth()
        }
    }

    func downSwipe(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            expression.mouth = expression.mouth.relaxMouth()
        }
    }

    fileprivate var eyebBrowTilt = [FacialExpressions.EyeBrows.happy: 1.0,
                                .normal: 0.0,
                                .forrowed: -1.0]

    fileprivate var mouthCurvature = [FacialExpressions.Mouth.sad: -1.0,
                                  .dissapointed: -0.5,
                                  .neutral: 0.0,
                                  .smirk: 0.5,
                                  .smile: 1.0]

    fileprivate func redrawUI() {
        switch expression.eyes {
        case .open: faceView.eyesAreClosed = false
        case .closed: faceView.eyesAreClosed = true
        }

        faceView.eyeBrowTilt = eyebBrowTilt[expression.brows] ?? 0.0
        faceView.mouthCurvature = mouthCurvature[expression.mouth] ?? 0.0
    }
}

