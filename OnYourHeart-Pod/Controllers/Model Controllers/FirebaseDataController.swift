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
    
    var user: AppUser = AppUser(firstName: "John", lastName: "Doe", uid: "2")
    let db = Firestore.firestore()
    
    
    
    //MARK: Firebase CRUD Functions
    
    func getUserInfo(uid: String, completion: @escaping (Result<AppUser, FirebaseError>) -> Void) {
        db.collection(Constants.Firebase.usersKey).whereField(Constants.Firebase.uidKey, isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                return completion(.failure(.errorPullingUserInfo(error)))
            }
                                  
            if let snapshot = snapshot {
                let data = snapshot.documents[0].data()
                guard let user = AppUser(from: data) else {return completion(.failure(.uknownError))}
                return completion(.success(user))
                
                } else {
                    return completion(.failure(.errorPullingFromSnapshotData))
                }
        }
    }
    
    func createUser(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                return completion(.failure(.creatingUserError(error)))
            }
            
            guard let result = result else {
                return completion(.failure(.uknownError))
            }
            
            print(result.description)
            
            let newUser = AppUser(firstName: firstName, lastName: lastName, uid: result.user.uid)
            self.user = newUser
            
            
            self.db.collection(Constants.Firebase.usersKey).addDocument(data: [
                Constants.Firebase.firstNameKey : firstName,
                Constants.Firebase.lastNameKey : lastName,
                Constants.Firebase.uidKey : result.user.uid,
                Constants.Firebase.listKey : [[
                    Constants.Firebase.nameKey : Constants.Firebase.listContents[0].name,
                    Constants.Firebase.colorKey : Constants.Firebase.listContents[0].color,
                    Constants.Firebase.textColorKey : Constants.Firebase.listContents[0].textColor],
                    [Constants.Firebase.nameKey : Constants.Firebase.listContents[1].name,
                     Constants.Firebase.colorKey : Constants.Firebase.listContents[1].color,
                     Constants.Firebase.textColorKey : Constants.Firebase.listContents[1].textColor],
                    [Constants.Firebase.nameKey : Constants.Firebase.listContents[2].name,
                     Constants.Firebase.colorKey : Constants.Firebase.listContents[2].color,
                     Constants.Firebase.textColorKey : Constants.Firebase.listContents[2].textColor]]
            ]) { error in
                if let error = error {
                    return completion(.failure(.errorSavingUserData(error)))
                } else {return completion(.success(true))}
            }
        }
    }
    
    func add(scriptures: [Int], to listName: String, scriptureTitle: String, chapterId: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        
        let newScriptureListEntry = ScriptureListEntry(chapterId: chapterId, listName: listName, scriptureTitle: scriptureTitle, scriptureNumbers: scriptures)
        
        self.db.collection(Constants.Firebase.scriptureListEntryKey).addDocument(data: [
            Constants.Firebase.uidKey : newScriptureListEntry.uid,
            Constants.Firebase.chapterId : newScriptureListEntry.chapterId,
            Constants.Firebase.listName : newScriptureListEntry.listName,
            Constants.Firebase.scriptureTitle : newScriptureListEntry.scriptureTitle,
            Constants.Firebase.scriptureNumbers : newScriptureListEntry.scriptureNumbers
        ]) {error in
            if let error = error {
                completion(.failure(.errorSavingUserData(error)))
            } else {return completion(.success(true))}
        }
    }
    
    func getVerses(for mood: String, completion: @escaping (Result<[ScriptureListEntry], FirebaseError>) -> Void) {
        
        var scriptureList: [ScriptureListEntry] = []
        db.collection(Constants.Firebase.scriptureListEntryKey)
            .whereField(Constants.Firebase.listName, isEqualTo: mood)
            .whereField(Constants.Firebase.uidKey, isEqualTo: user.uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(.errorGettingVerses(error)))
                }
                
                
                guard let snapshot = snapshot else {return completion(.failure(.uknownError))}
                
                
                for document in snapshot.documents {
                    let data = document.data()
                    
                    guard let newVerse = ScriptureListEntry(from: data) else { return completion(.failure(.errorPullingFromSnapshotData))}

                    
                    scriptureList.append(newVerse)
                }
                return completion(.success(scriptureList))
            }
    }
}
