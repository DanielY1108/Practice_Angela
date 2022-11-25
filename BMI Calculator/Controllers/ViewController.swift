//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Angela Yu on 21/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    var bmiManager = BMIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func moveHeightSlider(_ sender: UISlider) {
        let height = String(format: "%.2f", sender.value)
        heightLabel.text = "\(height) m"
    }
    
    @IBAction func moveWeightSlider(_ sender: UISlider) {
        let weight = String(format: "%.0f", sender.value)
        weightLabel.text = "\(weight) Kg"
    }
    
    @IBAction func calculateButton(_ sender: UIButton) {
        let bmi = bmiManager.getBMIData(weight: weightSlider.value, height: heightSlider.value)
        
        guard let secondVC =  storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else { return }
        secondVC.result = bmi
        present(secondVC, animated: true)
    }
    
   
}

