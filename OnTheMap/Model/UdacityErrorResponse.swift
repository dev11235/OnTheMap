//
//  UdacityErrorResponse.swift
//  OnTheMap
//
//  Created by Mikhail on 10/11/20.
//  Copyright © 2020 112358dev. All rights reserved.
//

import Foundation

struct UdacityErrorResponse: Codable {
    let status: Int
    let error: String
}

extension UdacityErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
