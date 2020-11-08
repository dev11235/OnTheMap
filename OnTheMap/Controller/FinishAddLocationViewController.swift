//
//  FinishAddLocationViewController.swift
//  OnTheMap
//
//  Created by Mikhail on 10/2/20.
//  Copyright © 2020 112358dev. All rights reserved.
//

import UIKit
import MapKit

class FinishAddLocationViewController: UIViewController {

    var mapString: String!
    var mediaURL: URL!
    var placeMark: CLPlacemark!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func finishTapped(_ sender: Any) {
        let latitude = placeMark.location!.coordinate.latitude
        let longitude = placeMark.location!.coordinate.longitude
        
        let newLocation = PostLocationRequest(firstName: UdacityClient.Auth.firstName, lastName: UdacityClient.Auth.lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL.absoluteString, uniqueKey: UdacityClient.Auth.accountId)
        
        UdacityClient.postLocation(location: newLocation) { (studentLocation, error) in
            if let studentLocation = studentLocation {
                OnTheMapModel.studentLocations.append(studentLocation)
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                let errorMessage = error?.localizedDescription ?? "Unknown Error"
                let alertVC = UIAlertController(title: "Find Location Failed", message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertVC, animated: true)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placeMark.location!.coordinate
        let regionRadius: CLLocationDistance = 10000
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
        }
    }
}

extension FinishAddLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pinView.canShowCallout = true
        pinView.pinTintColor = .red
        return pinView
    }
}
