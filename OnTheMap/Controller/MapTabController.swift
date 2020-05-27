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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(addTapped))
    }
    
    
    @objc func addTapped(){
        performSegue(withIdentifier: "findOnMap", sender: nil)
    }
    
}
