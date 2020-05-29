//
//  PinSubmissionViewController.swift
//  OnTheMap
//
//  Created by Timi Tejumola on 27/05/2020.
//  Copyright © 2020 Timi Tejumola. All rights reserved.
//

import UIKit
import MapKit

class PinSubmissionViewController: UIViewController, UITextFieldDelegate {
    
    var address: String!
    var addressCoordinates: CLLocationCoordinate2D!

    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkTextField.delegate = self
        
        linkTextField.setLeftIcon("link")
        
        linkTextField.borderStyle = .none
        linkTextField.attributedPlaceholder = NSAttributedString(string: "Enter Your Location Here", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.6)])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showIndicator("Fetching Coordinates")
        getCoordinate(forAddress: address) { (coord) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            
            let pin = MKPointAnnotation()
            pin.coordinate = coord!
            self.addressCoordinates = coord!
            self.mapView.addAnnotation(pin)
            self.mapView.setCenter(coord!, animated: true)
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    

    @IBAction func submitPinTapped(_ sender: Any) {
        showIndicator("Posting pin...")
        let student = StudentLocation(objectId: "12", uniqueKey: "12345", firstName: "Tejumola", lastName: "Timi", mapString: address, mediaURL: linkTextField.text ?? "https://www.udacity.com", latitude: Float(addressCoordinates.latitude), longitude: Float(addressCoordinates.longitude))
                
        MapClient.postMyLocation(body: student) { (result) in
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        linkTextField.resignFirstResponder()
        return true
    }
    
    func getCoordinate(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void ){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            self.dismiss(animated: true, completion: nil)
            guard error == nil else{
                self.alert(title: "Invalid geocode", description: "Cannot find address coordinates", style: .alert, actions: [], viewController: nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToMapSegue" {
            let destVC = segue.destination as! MapViewController
            destVC.myCoordinate = addressCoordinates
        }
    }
}
