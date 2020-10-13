//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Mikhail on 9/27/20.
//  Copyright © 2020 112358dev. All rights reserved.
//

import Foundation

class UdacityClient {
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case postSession
        
        var urlString: String {
            switch self {
            case .postSession:
                return Endpoints.base + "/session"
            }
        }
        
        var url: URL {
            URL(string: urlString)!
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, body: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let newData = data.subdata(in: 5..<data.count)
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func postSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = UdacitySessionRequest(udacity: ["username": username, "password": password])
        
        taskForPOSTRequest(url: Endpoints.postSession.url, body: body, responseType: UdacitySessionResponse.self) { (response, error) in
            if let response = response {
                print("session id: \(response.session["id"]!)")
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
}
