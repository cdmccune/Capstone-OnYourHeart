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
    case errorGettingVerses(Error)
    case errorPullingFromSnapshotData
    case errorPullingUserInfo(Error)
    case errorFetchingList(Error)
    
    var errorDescription: String? {
        switch self {
        case .creatingUserError(let error):
            return("Error creating user \(error)")
        case .uknownError:
            return "Uknown error occured"
        case .errorSavingUserData(let error):
            return "Error saving user data: \(error)"
        case .errorGettingVerses(let error):
            return "Could not get the scriptures requested: \(error)"
        case .errorPullingFromSnapshotData:
            return "Could not pull fields from snapshot data"
        case .errorPullingUserInfo(let error):
            return "Couldn't get user info: \(error)"
        case .errorFetchingList(let error):
            return "There was an error getting the list data: \(error)"
        }

    }
}
