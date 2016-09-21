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
        case open, closed
    }

    enum EyeBrows: Int {
        case happy, normal, forrowed

        func relaxEyeBrows() -> EyeBrows {
            return EyeBrows(rawValue: rawValue - 1) ?? .happy
        }

        func agitateEyeBrows() -> EyeBrows {
            return EyeBrows(rawValue: rawValue + 1) ?? .forrowed
        }
    }

    enum Mouth: Int {
        case sad, dissapointed, neutral, smirk, smile

        func relaxMouth() -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }

        func agitateMouth() -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .sad
        }
    }
}
