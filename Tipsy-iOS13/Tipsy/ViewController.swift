//
//  ViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let stepper: UIStepper = {
        let stp = UIStepper()
        stp.maximumValue = 25
        stp.minimumValue = 2
        return stp
    }()
    
    var a = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stepper)
        
        stepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stepper.topAnchor.constraint(equalTo: view.topAnchor, constant: 500),
            stepper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stepper.widthAnchor.constraint(equalToConstant: 100),
            stepper.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        stepper.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        
    }
    
    
    @objc func tapped(_ sender: UIStepper) {
        print("1")
        print(sender.valuew)
        a = Int(sender.stepValue)
        
    }
    
    
}

