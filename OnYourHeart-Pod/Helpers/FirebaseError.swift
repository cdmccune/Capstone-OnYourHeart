//
//  FirebaseError.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/24/22.
//

import Foundation

enum FirebaseError: LocalizedError {
    case creatingUserError(Error)
    case unknownError
    case errorSavingUserData(Error)
    case errorGettingVerses(Error)
    case errorPullingFromSnapshotData
    case errorPullingUserInfo(Error)
    case errorFetchingList(Error)
    case noListError(String)
    case errorFetchingVerse(Error)
    case errorDeletingVerse(Error)
    case errorAddingList(Error)
    case errorSettingFavVerse(Error)
    case errorIncrementingBookCount(Error)
    case errorDecrementingBookCount(Error)
    case errorFetchingTopBooks(Error)
    
    
    
    var errorDescription: String? {
        switch self {
        case .creatingUserError(let error):
            return("Error creating user \(error)")
        case .unknownError:
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
        case .noListError(let listName):
            return "Could not find a list for user of name \(listName)"
        case .errorFetchingVerse(let error):
            return "There was an error finding verse: \(error)"
        case .errorDeletingVerse(let error):
            return "There was an error deleting the verse: \(error)"
        case .errorAddingList(let error):
            return "There was an error adding a list to the user \(error)"
        case .errorSettingFavVerse(let error):
            return "There was an error setting the favorite verse \(error)"
        case .errorIncrementingBookCount(let error):
            return "There was an error incrementing the book count \(error)"
        case .errorDecrementingBookCount(let error):
            return "There was an error decrementing the book count \(error)"
        case .errorFetchingTopBooks(let error):
            return "There was an error fetching the top books \(error)"
        }

    }
}
