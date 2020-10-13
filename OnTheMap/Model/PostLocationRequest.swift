//
//  PostLocationRequest.swift
//  OnTheMap
//
//  Created by Mikhail on 10/7/20.
//  Copyright © 2020 112358dev. All rights reserved.
//

import Foundation

struct PostLocationRequest: Codable {
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
}
