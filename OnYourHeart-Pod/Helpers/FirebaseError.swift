//
//  FirebaseError.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/24/22.
//

import Foundation

enum FirebaseError: LocalizedError {
    case creatingUserError(Error)
    case uknownError
    case errorSavingUserData(Error)
    
    var errorDescription: String? {
        switch self {
        case .creatingUserError(let error):
            return("Error creating user \(error)")
        case .uknownError:
            return "Uknown error occured"
        case .errorSavingUserData(let error):
            return "Error saving user data: \(error)"
        }

    }
}
