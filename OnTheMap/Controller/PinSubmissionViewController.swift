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
            let pin = MKPointAnnotation()
            pin.coordinate = coord!
            self.addressCoordinates = coord!
            self.mapView.addAnnotation(pin)
            self.mapView.setCenter(coord!, animated: true)
        }
    }
    

    @IBAction func submitPinTapped(_ sender: Any) {
        showIndicator("Posting pin...")
        let student = StudentLocation(objectId: "12", uniqueKey: "12345", firstName: "Tejumola", lastName: "Timi", mapString: address, mediaURL: linkTextField.text ?? "https://www.udacity.com", latitude: Float(addressCoordinates.latitude), longitude: Float(addressCoordinates.longitude))
        print(student)

        MapClient.postMyLocation(body: student) { (result) in
            switch result {
            case .success(_):
                print("Success")
                self.performSegue(withIdentifier: "unwindToMapSegue", sender: nil)
            case .failure(let error):
                print("Failed")
                let closeAction = UIAlertAction(title: "Close", style: .default, handler: { action in
                    self.dismiss(animated: true)
                })
                self.alert(title: "Something went wrong", description: error.localizedDescription, style: .alert, actions: [closeAction], viewController: nil)
            }
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
            self.dismiss(animated: true)
            guard error == nil else{
                
                let closeAction = UIAlertAction(title: "Close", style: .default, handler: { action in
                    self.dismiss(animated: true)
                })
                
                self.alert(title: "Invalid geocode", description: "Cannot find address coordinates", style: .alert, actions: [closeAction], viewController: nil)
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
