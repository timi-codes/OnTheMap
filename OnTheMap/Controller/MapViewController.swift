//
//  ViewController.swift
//  OnTheMap
//
//  Created by Timi Tejumola on 25/05/2020.
//  Copyright © 2020 Timi Tejumola. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, LoadDataProtocol {
    @IBOutlet weak var mapView: MKMapView!
    
    var myCoordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadData()
    }
    
    
    func loadData(){
        self.mapView.removeAnnotations(self.mapView.annotations)
        MapClient.getStudenLocations { result in
        switch result {
            case .success(let data):
                self.handleStudentLocationResponse(locations: data)
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print(error.localizedDescription)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    func handleStudentLocationResponse(locations: [StudentLocation]){
        var annotations = [MKPointAnnotation]()
        
        for student in locations {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
     @IBAction func unwindToMap(_ sender: UIStoryboardSegue){
        mapView.setCenter(myCoordinate!, animated: true)
        loadData()
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
        }else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!, let url = URL(string: toOpen) {
                app.open(url, options: [:], completionHandler: nil)
            }else {
                alert(title: "Invalid Url", description: "Cannot open \(String(describing: view.annotation?.subtitle))", style: .alert, actions: [], viewController: nil)
            }
            

        }
    }
}



