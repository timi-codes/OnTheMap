//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Timi Tejumola on 29/05/2020.
//  Copyright © 2020 Timi Tejumola. All rights reserved.
//

import Foundation

struct LoginRequest:Codable {
    let udacity: LoginData
}

struct LoginData:Codable {
    let username: String
    let password: String
}
