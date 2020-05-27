//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Timi Tejumola on 26/05/2020.
//  Copyright © 2020 Timi Tejumola. All rights reserved.
//

import Foundation


struct StudentLocation: Codable {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
}
