//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Mikhail on 10/2/20.
//  Copyright © 2020 112358dev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    @IBAction
    func addLocationTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addLocation", sender: nil)
    }
}
