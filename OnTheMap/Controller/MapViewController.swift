//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Mikhail on 9/30/20.
//  Copyright © 2020 112358dev. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        // Do any additional setup after loading the view.
        UdacityClient.getStudentLocations(completion: handleStudentLocationsResponse(studentLocations:error:))
    }
    
    @IBAction
    func refreshTapped(_ sender: UIBarButtonItem) {
        UdacityClient.getStudentLocations(completion: handleStudentLocationsResponse(studentLocations:error:))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func handleStudentLocationsResponse(studentLocations: [StudentLocation], error: Error?) {
        OnTheMapModel.studentLocations = studentLocations
        
        for location in OnTheMapModel.studentLocations {
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = "\(location.firstName) \(location.lastName)"
            annotation.subtitle = location.mediaURL
            
            self.annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
}



extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
}
