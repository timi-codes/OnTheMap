//
//  MapClient.swift
//  OnTheMap
//
//  Created by Timi Tejumola on 26/05/2020.
//  Copyright © 2020 Timi Tejumola. All rights reserved.
//

import Foundation

class MapClient {
    static let apiKey=""
    struct Auth {
        fileprivate static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let orderByUpdatedAt = "?order=-updatedAt"
        
        case getStudentLocations
        case postMyLocation
        
        var stringValue: String {
            switch self {
                case .getStudentLocations: return Endpoints.base + "/StudentLocation\(Endpoints.orderByUpdatedAt)"
                case .postMyLocation: return Endpoints.base + "/StudentLocation"
            }
        }
        
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getStudenLocations(completion: @escaping (Result<[StudentLocation], Error>)->Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getStudentLocations.url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            
            do {
                let response = try JSONDecoder().decode(StudentLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.results))
                }
            }catch{
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    class func postMyLocation(body: StudentLocation, completion: @escaping (Result<[StudentLocation], Error>)->Void){
        var request = URLRequest(url: Endpoints.postMyLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }
}
