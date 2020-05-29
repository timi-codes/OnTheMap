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
        case login
        case logout
        
        var stringValue: String {
            switch self {
                case .getStudentLocations: return Endpoints.base + "/StudentLocation\(Endpoints.orderByUpdatedAt)"
                case .postMyLocation: return Endpoints.base + "/StudentLocation"
            case .login,.logout: return Endpoints.base + "/session"
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
    
    class func postMyLocation(body: StudentLocation, completion: @escaping (Result<PostLocationResponse, Error>)->Void){
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
            
            do {
                let response = try JSONDecoder().decode(PostLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            }catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    class func login(_ loginData: LoginData, completion: @escaping (Result<Bool, Error>)->Void){
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = LoginRequest(udacity: loginData)
        request.httpBody = try! JSONEncoder().encode(body)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
           guard let data = data else {
               DispatchQueue.main.async {
                   completion(.failure(error!))
               }
               return
           }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            print(String(data: newData, encoding: .utf8)!)
           
           do {
               let response = try JSONDecoder().decode(LoginResponse.self, from: newData)
            
            guard response.session?.id != nil else{
                DispatchQueue.main.async {
                   completion(.success(false))
                }
                return
            }
               DispatchQueue.main.async {
                   completion(.success(true))
               }
           }catch {
               DispatchQueue.main.async {
                   completion(.failure(error))
               }
           }
        }
        
        task.resume()
    }
    
    
    class func logout( completion: @escaping (Result<Bool, Error>)->Void){
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data else {
              DispatchQueue.main.async {
                  completion(.failure(error!))
              }
              return
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }
        task.resume()
    }
}
