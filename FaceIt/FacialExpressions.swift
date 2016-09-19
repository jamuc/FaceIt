//
//  Expressions.swift
//  FaceIt
//
//  Created by Jason Franklin on 19/09/16.
//  Copyright © 2016 Jason Franklin. All rights reserved.
//

import Foundation

struct FacialExpressions {

    var eyes: Eyes
    var brows: EyeBrows
    var mouth: Mouth

    enum Eyes: Int {
        case Open, Closed
    }

    enum EyeBrows: Int {
        case Happy, Normal, Forrowed

        func relaxEyeBrows() -> EyeBrows {
            return EyeBrows(rawValue: rawValue - 1) ?? .Happy
        }

        func agitateEyeBrows() -> EyeBrows {
            return EyeBrows(rawValue: rawValue + 1) ?? .Forrowed
        }
    }

    enum Mouth: Int {
        case Sad, Dissapointed, Neutral, Smirk, Smile

        func relaxMouth() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .Smile
        }

        func agitateMouth() -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .Sad
        }
    }
}
