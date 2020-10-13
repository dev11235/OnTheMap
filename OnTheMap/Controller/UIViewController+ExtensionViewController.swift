//
//  UIViewController+ExtensionViewController.swift
//  OnTheMap
//
//  Created by Mikhail on 10/1/20.
//  Copyright © 2020 112358dev. All rights reserved.
//

import UIKit

extension UIViewController {
    @IBAction
    func refreshTapped(_ sender: UIBarButtonItem) {
        UdacityClient.getStudentLocations { (studentLocations, error) in
            OnTheMapModel.studentLocations = studentLocations
        }
    }
}
