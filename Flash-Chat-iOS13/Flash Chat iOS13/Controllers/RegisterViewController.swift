//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {

    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        guard let email = emailTextfield.text, let password = passwordTextfield.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: K.registerSegue, sender: self)
            }
        }
    
    }
    
 
    
    
}
