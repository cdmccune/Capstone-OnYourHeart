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
    case sessionError(Error)
    case responseNot200(HTTPURLResponse)
    case badData
    case errorDecodingData(Error)
    case errorReportingFUMS(Error)
    
    var errorDescription: String?{
        switch self {
        case .badBaseURL:
            return "Your baseURL had an error"
        case .badBuiltURL:
            return "Error building your URL"
        case .invalidApiKey:
            return "Your Api Key could not be accessed"
        case .sessionError(let error):
            return "Error with the url session request: \(error.localizedDescription)"
        case .responseNot200(let response):
            return "The response code was not 200: Code \(response.statusCode)"
        case .badData:
            return "The data could not be unwrapped"
        case .errorDecodingData(let error):
            return "Error decoding the data: \(error.localizedDescription)"
        case .errorReportingFUMS(let error):
            return "There was an error reporting to FUMS \(error)"
        }

    }
}
