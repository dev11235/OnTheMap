//
//  ViewController.swift
//  OnTheMap
//
//  Created by Mikhail on 9/25/20.
//  Copyright © 2020 112358dev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let udacitySignUpURL = URL(string: "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signup&sa=D&ust=1601068202862000&usg=AOvVaw1PkIjIiyvZkZ87wEF-fo0q")!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(udacitySignUpURL)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.postSession(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (success, error) in
            if success {
                print("successfully authenticated")
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            } else {
                self.showLoginFailure(message: error?.localizedDescription ?? "Unknown Error")
            }
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        signUpButton.isEnabled = !loggingIn
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default) { action in
            self.setLoggingIn(false)
        })
        show(alertVC, sender: nil)
    }
    
}

