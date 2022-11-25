//
//  BMIManager.swift
//  BMI Calculator
//
//  Created by JinSeok Yang on 2022/11/02.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

struct BMIManager {
    
    var bmi: BMI?
    
    mutating func getBMIData(weight: Float, height: Float) -> BMI {
        let bmiValue = weight / pow(height, 2)
        let bmiStr = String(format: "%.1f", bmiValue)

    
        switch bmiValue {
        case 0 ..< 18.5:
            bmi = BMI(value: bmiStr, advice: "많이 드셔야 겠어요.", color: .systemBlue)
            return bmi!
        case 18.5 ..< 24.9:
            bmi = BMI(value: bmiStr, advice: "정상입니다", color: .systemGreen)
            return bmi!
        default:
            bmi = BMI(value: bmiStr, advice: "간식 그만드세요.", color: .systemRed)
            return bmi!
        }
    }
    
    
}
