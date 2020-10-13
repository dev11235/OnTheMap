//
//  ViewController.swift
//  OnTheMap
//
//  Created by Mikhail on 9/25/20.
//  Copyright © 2020 112358dev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.text = "112358dev@gmail.com"
        passwordTextField.text = "odSyQK1N@N"
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
//        UdacityClient.postSession(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (success, error) in
//            if success {
//                print("successfully authenticated")
//            } else {
//                print(error ?? "unknown error")
//            }
//        }
        
        UdacityClient.getStudentLocations { (studentLocations, error) in
            OnTheMapModel.studentLocations = studentLocations
        }
    }
    
}

