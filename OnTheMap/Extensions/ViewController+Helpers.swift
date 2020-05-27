//
//  ViewController+Helpers.swift
//  OnTheMap
//
//  Created by Timi Tejumola on 27/05/2020.
//  Copyright © 2020 Timi Tejumola. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(title: String, description: String?, style: UIAlertController.Style, actions: [UIAlertAction], viewController: UIViewController?){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: description, preferredStyle: style)
            if actions.count == 0 {
                let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                alert.addAction(closeAction)
            } else {
                for action in actions {
                    alert.addAction(action)
                }
            }

            self.present(alert, animated: true)
        }
    }
    
    func showIndicator(_ text:String? = "Please wait..." ){
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
}
