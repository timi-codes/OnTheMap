//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Timi Tejumola on 29/05/2020.
//  Copyright © 2020 Timi Tejumola. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.6)])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.6)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let username = usernameTextField.text, let password = passwordTextField.text, !username.isEmpty, !password.isEmpty else {
            alert(title: "Missing credentials", description: "Please ensure your login detail was provided", style: .alert, actions: [], viewController: nil)
            return
        }
        
        let loginRequest = LoginData(username: username, password: password)
        showIndicator("Logging in...")
        MapClient.login(loginRequest) { (response) in
            
            self.dismiss(animated: true, completion: nil)

            switch response {
            case .success(let isSuccess):
                if isSuccess {
                    self.performSegue(withIdentifier: "Login", sender: self)
                }
            case .failure(let error):
                self.alert(title: "Login Failed", description: error.localizedDescription, style: .alert, actions: [], viewController: nil)
            }
        }
    }
    
}
