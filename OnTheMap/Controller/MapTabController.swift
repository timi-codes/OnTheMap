//
//  MapTabController.swift
//  OnTheMap
//
//  Created by Timi Tejumola on 26/05/2020.
//  Copyright © 2020 Timi Tejumola. All rights reserved.
//

import Foundation
import UIKit

class MapTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "On The Map"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
            
        let reload = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadMapData))
        
        let logoutImage = UIImage(systemName: "arrow.uturn.right")
        let logout = UIBarButtonItem(image: logoutImage, style: .done, target: self, action: #selector(logoutUser))
        
        navigationItem.rightBarButtonItems = [logout, reload]
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemIndigo,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        ]
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @objc func addTapped(){
        performSegue(withIdentifier: "findOnMap", sender: nil)
    }
    
    
    @objc func reloadMapData(){
        if let selectedViewController = self.selectedViewController {
            (selectedViewController as! LoadDataProtocol).loadData()
        }
    }
    
    @objc func logoutUser(){
        MapClient.logout { (result) in
            switch result {
            case .success(_):
                self.navigationController?.popToRootViewController(animated: true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
