//
//  FirebaseDataController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/24/22.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class FirebaseDataController {
    
    
    //MARK: - Properties
    
    static var shared = FirebaseDataController()
    
    var user: User?
    
    
    
    //MARK: Firebase CRUD Functions
    
    func createUser(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                return completion(.failure(.creatingUserError(error)))
            }
            
            guard let result = result else {
                return completion(.failure(.uknownError))
            }
            
            let newUser = User(firstName: firstName, lastName: lastName, uid: result.user.uid)
            self.user = newUser
            
            let db = Firestore.firestore()
            db.collection(Constants.Firebase.usersKey).addDocument(data: [
                Constants.Firebase.firstNameKey : firstName,
                Constants.Firebase.lastNameKey : lastName,
                Constants.Firebase.uidKey : result.user.uid,
                Constants.Firebase.listKey : Constants.Firebase.listContents
            ]) { error in
                if let error = error {
                    return completion(.failure(.errorSavingUserData(error)))
                } else {return completion(.success(true))}
            }
        }
    }
    
    
}
