//
//  ResultViewController.swift
//  BMI Calculator
//
//  Created by JinSeok Yang on 2022/11/02.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var statuLabel: UILabel!
    
    var result: BMI?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure() {
        if let result = result {
            resultLabel.text = result.value
            statuLabel.text = result.advice
            view.backgroundColor = result.color
        }
       
    }

    @IBAction func reCalculatePressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    

}
