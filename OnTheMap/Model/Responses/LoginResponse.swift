//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Timi Tejumola on 29/05/2020.
//  Copyright © 2020 Timi Tejumola. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    var account:Account!
    var session:Session!
}

struct Session: Codable {
    var id: String!
    var exporation: Date!
}

struct Account: Codable {
    var registered: Bool!
    var key: String!
}
