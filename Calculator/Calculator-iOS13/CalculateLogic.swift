//
//  Calculate.swift
//  Calculator-iOS13
//
//  Created by JINSEOK on 2022/12/28.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import UIKit

enum Operation: String {
    case convertMinus = "+/-"
    case ac = "AC"
    case persent = "%"
    case division = "÷"
    case multiply = "×"
    case minus = "-"
    case plus = "+"
    case equals = "="
}

struct CalculateLogic {
    
    private var intermediateCalculation: (num1: Double, symbol: String)?
    
    private var number: Double?
    
    mutating func setNumber(_ number: Double) {
        self.number = number
    }
    
    mutating func calculate(symbol: String) -> Double? {
        guard let num = number else { return nil }
        switch symbol {
        case Operation.convertMinus.rawValue:
            return num * -1
        case Operation.ac.rawValue:
            return 0
        case Operation.persent.rawValue:
            return num / 100
        case Operation.equals.rawValue:
            return performTwoNumCalculation(num2: num)
        default:
            intermediateCalculation = (num, symbol)
        }
        return nil
    }
    
    private func performTwoNumCalculation(num2: Double) -> Double? {
        if let num1 = intermediateCalculation?.num1, let operation = intermediateCalculation?.symbol {
            switch operation {
            case Operation.plus.rawValue:
                return num1 + num2
            case Operation.minus.rawValue:
                return num1 - num2
            case Operation.multiply.rawValue:
                return num1 * num2
            case Operation.division.rawValue:
                return num1 / num2
            default: break
            }
        }
        return nil
    }
}
