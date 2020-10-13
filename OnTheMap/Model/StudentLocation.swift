//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Mikhail on 9/30/20.
//  Copyright © 2020 112358dev. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
