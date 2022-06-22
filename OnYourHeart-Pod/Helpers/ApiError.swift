//
//  ApiError.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/22/22.
//

import Foundation

enum ApiError: LocalizedError {
    case badBaseURL
    case badBuiltURL
    case invalidApiKey
    
    var errorDescription: String?{
        switch self {
        case .badBaseURL:
            return "Your baseURL had an error"
        case .badBuiltURL:
            return "Error building your URL"
        case .invalidApiKey:
            return "Your Api Key could not be accessed"
        }
    }
}
