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
            recognizer.direction = .Up
            faceView.addGestureRecognizer(recognizer)

            recognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.downSwipe(_:)))
            recognizer.direction = .Down
            faceView.addGestureRecognizer(recognizer)

        }
    }

    var expression = FacialExpressions(eyes: FacialExpressions.Eyes.Open,
                                        brows: FacialExpressions.EyeBrows.Forrowed,
                                        mouth: FacialExpressions.Mouth.Smirk) {
        didSet {
            redrawUI()
        }
    }

    @IBAction func tap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            }
        }
    }

    func upSwipe(recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .Ended {
            expression.mouth = expression.mouth.agitateMouth()
        }
    }

    func downSwipe(recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .Ended {
            expression.mouth = expression.mouth.relaxMouth()
        }
    }

    private var eyebBrowTilt = [FacialExpressions.EyeBrows.Happy: 1.0,
                                .Normal: 0.0,
                                .Forrowed: -1.0]

    private var mouthCurvature = [FacialExpressions.Mouth.Sad: -1.0,
                                  .Dissapointed: -0.5,
                                  .Neutral: 0.0,
                                  .Smirk: 0.5,
                                  .Smile: 1.0]

    private func redrawUI() {
        switch expression.eyes {
        case .Open: faceView.eyesAreClosed = false
        case .Closed: faceView.eyesAreClosed = true
        }

        faceView.eyeBrowTilt = eyebBrowTilt[expression.brows] ?? 0.0
        faceView.mouthCurvature = mouthCurvature[expression.mouth] ?? 0.0
    }
}

