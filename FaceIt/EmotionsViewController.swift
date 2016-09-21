//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Jason Franklin on 21/09/16.
//  Copyright © 2016 Jason Franklin. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let emotions = [
        "Angry": FacialExpressions(eyes: .closed, brows: .forrowed, mouth: .sad),
        "Happy": FacialExpressions(eyes: .open, brows: .normal, mouth: .smile),
        "Dissapointed": FacialExpressions(eyes: .closed, brows: .normal, mouth: .dissapointed)
    ]

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let faceViewController = segue.destination as? FaceViewController {
            if let button = sender as? UIButton {
                if let emotion = emotions[button.currentTitle!] {
                    faceViewController.expression = emotion
                }
            }
        }
    }
}
