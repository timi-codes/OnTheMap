//
//  FindOnMapController.swift
//  OnTheMap
//
//  Created by Timi Tejumola on 27/05/2020.
//  Copyright © 2020 Timi Tejumola. All rights reserved.
//

import Foundation
import UIKit

class FindOnMapController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var locationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        
        locationTextField.setLeftIcon("map.fill")
        
        locationTextField.borderStyle = .none
        locationTextField.attributedPlaceholder = NSAttributedString(string: "Enter Your Location Here", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.6)])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
    }
    
    @IBAction func onFindOnTheMapPressed(_ sender: Any) {
        guard let location = locationTextField.text, !location.isEmpty else {
            alert(title: "Missing location", description: "Please add an location in the field ", style: .alert, actions: [], viewController: nil)
            return
        }
        
        performSegue(withIdentifier: "submitPin", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "submitPin" {
            let pinSubmissionVC = segue.destination as! PinSubmissionViewController
            pinSubmissionVC.address = locationTextField.text
        }
    }
    
    @objc func cancelTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTextField.resignFirstResponder()
        return true
    }
}
