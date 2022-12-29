//
//  ViewController.swift
//  Calculator Layout iOS13
//
//  Created by Angela Yu on 01/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    private var isFinishTypingNumer: Bool = true
    
    private var displayValue: Double {
        get {
            guard let number = Double(displayLabel.text!) else {
                print("Cannot convert display label text to a Double")
                return 0
            }
            return number
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    private var calculator = CalculateLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        isFinishTypingNumer = true
        
        if let calcMethod = sender.currentTitle {
            calculator.setNumber(displayValue)
            
            guard let result = calculator.calculate(symbol: calcMethod) else {
                print("The result of the calculation is nil")
                return
            }
            displayValue = result
        }
    }
    
    
    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        if let numberValue = sender.currentTitle {
            if isFinishTypingNumer {
                displayLabel.text = numberValue
                isFinishTypingNumer = false
            } else {
                if numberValue == "." {
                    let isInt = floor(displayValue) == displayValue
                    
                    if !isInt {
                        return
                    }
                }
                displayLabel.text?.append(numberValue)
            }
        }
    }
}

