//
//  UdacityClientError.swift
//  OnTheMap
//
//  Created by Mikhail on 10/11/20.
//  Copyright © 2020 112358dev. All rights reserved.
//

import UIKit

enum UdacityClientError: Error {
    case accountNotFound
}

extension UdacityClientError: LocalizedError {
    public var errorDescription: String? {
        
    }
}
