//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Mikhail on 10/2/20.
//  Copyright © 2020 112358dev. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {

    @IBOutlet weak var geocodeTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var acivityIndicator: UIActivityIndicatorView!
    var placeMark: CLPlacemark?
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func setUI(geocoding: Bool) {
        if geocoding {
            acivityIndicator.startAnimating()
        } else {
            acivityIndicator.stopAnimating()
        }
        
        geocodeTextField.isEnabled = !geocoding
        mediaURLTextField.isEnabled = !geocoding
    }
    
    func getErrorMessageForGeocodinFailure(_ error: Error?) -> String {
        if let clError = error as? CLError {
            switch clError.code {
            case .geocodeFoundNoResult:
                return "Location not found."
            default:
                return clError.localizedDescription
            }
        } else {
            return error?.localizedDescription ?? ""
        }
    }
    
    func showGeocodingFailure(message: String) {
        let alertVC = UIAlertController(title: "Find Location Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertVC, animated: true)
    }
    
    func handleForwardGeocode(placeMarks: [CLPlacemark]?, error: Error?) {
        setUI(geocoding: false)
        if let placeMark = placeMarks?[0] {
            self.placeMark = placeMark
            self.performSegue(withIdentifier: "finishAddLocation", sender: nil)
        } else {
            showGeocodingFailure(message: getErrorMessageForGeocodinFailure(error))
        }
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        if mediaURLTextField.text?.isEmpty == true {
            showGeocodingFailure(message: "Empty link.")
        }
        
        setUI(geocoding: true)
        
        CLGeocoder().geocodeAddressString(geocodeTextField.text!) { (placeMarks, error) in
            DispatchQueue.main.async {
                self.handleForwardGeocode(placeMarks: placeMarks, error: error)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI(geocoding: false)
        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let placeMark = placeMark {
            let finishAddLocationController = segue.destination as! FinishAddLocationViewController
            finishAddLocationController.placeMark = placeMark
            finishAddLocationController.mapString = placeMark.name!
            finishAddLocationController.mediaURL = URL(string: self.mediaURLTextField.text!)
        }
    }
}
