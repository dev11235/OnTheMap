//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Mikhail on 9/27/20.
//  Copyright © 2020 112358dev. All rights reserved.
//

import Foundation

class UdacityClient {
    struct Auth {
        static var firstName = "Bill"
        static var lastName = "Gates"
        static var accountId = "987654321"
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case postSession
        case getLocations
        case postLocation
        
        var urlString: String {
            switch self {
            case .postSession: return Endpoints.base + "/session"
            case .getLocations: return Endpoints.base + "/StudentLocation?order=-updatedAt"
            case .postLocation: return Endpoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            URL(string: urlString)!
        }
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(String(data: data, encoding: .utf8)!)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, body: RequestType, hasSpecialSymbols: Bool = false, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                if hasSpecialSymbols {
                    data = data.subdata(in: 5..<data.count)
                }
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func postSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = UdacitySessionRequest(udacity: ["username": username, "password": password])
        
        taskForPOSTRequest(url: Endpoints.postSession.url, body: body, hasSpecialSymbols: true, responseType: UdacitySessionResponse.self) { (response, error) in
            if let response = response {
                print("session id: \(response.session["id"]!)")
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getLocations.url, responseType: StudentLocationsResponse.self) { (response, error) in
            if let response = response {
                print("got \(response.results.count) student locations")
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func postLocation(location: PostLocationRequest, completion: @escaping (StudentLocation?, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.postLocation.url, body: location, responseType: PostLocationResponse.self) { (response, error) in
            if let response = response {
                print("object id: \(response.objectId)")
                let studentLocation = StudentLocation(firstName: location.firstName, lastName: location.lastName, latitude: location.latitude, longitude: location.longitude, mapString: location.mapString, mediaURL: location.mediaURL, objectId: response.objectId, uniqueKey: Auth.accountId, updatedAt: response.createdAt)
                completion(studentLocation, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
}
