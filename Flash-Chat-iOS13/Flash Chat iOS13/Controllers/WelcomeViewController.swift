//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "1.svg")
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        letterAnimate()
        setUpImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    func setUpImage() {
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: view.frame.size.width / 2 - 100),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
       
        ])
    }
    
    func letterAnimate() {
        
        titleLabel.text = ""
        var charIndex = 0.0
        let tilet = K.appName
        for x in tilet {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                self.titleLabel.text?.append(x)
            }
            charIndex += 1
        }
        
    }
    
}
