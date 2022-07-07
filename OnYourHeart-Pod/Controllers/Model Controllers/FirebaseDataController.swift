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
    
    var currentListTag: Int? = nil
    var favVerse: ScriptureListEntry?
    var lists: [ListItem] = []
    var user: AppUser = AppUser(firstName: "John", lastName: "Doe", uid: "2")
    var sId: String = "12345"
    let db = Firestore.firestore()
    var topBooksList: [TopBook] = []
    
    
    
    
    //MARK: Firebase CRUD Functions
    

    
    //User Related
    func getUserInfo(uid: String, completion: @escaping (Result<AppUser, FirebaseError>) -> Void) {
        db.collection(Constants.Firebase.usersKey).whereField(Constants.Firebase.uidKey, isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                return completion(.failure(.errorPullingUserInfo(error)))
            }
            
            if let snapshot = snapshot {
                let data = snapshot.documents[0].data()
                guard let user = AppUser(from: data) else {return completion(.failure(.unknownError))}
                self.sId = "\(Int.random(in: 1...1000000000000))"
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
                return completion(.failure(.unknownError))
            }
            
            let newUser = AppUser(firstName: firstName, lastName: lastName, uid: result.user.uid)
            self.user = newUser
            
            let listsDictionary = Constants.Firebase.listContents.map({
                return [Constants.Firebase.nameKey : $0.name,
                        Constants.Firebase.colorKey : $0.color,
                        Constants.Firebase.textColorKey : $0.textColor,
                        Constants.Firebase.isEmotionKey : $0.isEmotion]
            })
            
            self.db.collection(Constants.Firebase.usersKey).addDocument(data: [
                Constants.Firebase.firstNameKey : firstName,
                Constants.Firebase.lastNameKey : lastName,
                Constants.Firebase.uidKey : result.user.uid,
                Constants.Firebase.listKey : listsDictionary
            ]) { error in
                if let error = error {
                    return completion(.failure(.errorSavingUserData(error)))
                } else {return completion(.success(true))}
            }
        }
    }
    
    //Scripture Related
    func add(scriptures: [Int], to listName: String, scriptureTitle: String, chapterId: String, scriptureContent: String, completion: @escaping (Result<ScriptureListEntry, FirebaseError>) -> Void) {
        
        let newScriptureListEntry = ScriptureListEntry(chapterId: chapterId, listName: listName, scriptureTitle: scriptureTitle, scriptureNumbers: scriptures, scriptureContent: scriptureContent)
        
        let bookAbb = FormatUtilities.getBookFromChaper(chapterId: chapterId)
        
        self.db.collection(Constants.Firebase.scriptureListEntryKey).addDocument(data: [
            Constants.Firebase.uidKey : newScriptureListEntry.uid,
            Constants.Firebase.chapterId : newScriptureListEntry.chapterId,
            Constants.Firebase.listName : newScriptureListEntry.listName,
            Constants.Firebase.scriptureTitle : newScriptureListEntry.scriptureTitle,
            Constants.Firebase.scriptureNumbers : newScriptureListEntry.scriptureNumbers,
            Constants.Firebase.scriptureContentKey : newScriptureListEntry.scriptureContent
        ]) {error in
            if let error = error {
                completion(.failure(.errorSavingUserData(error)))
            } else {
                self.db.collection(Constants.Firebase.bookPopularityCount).document(bookAbb)
                    .updateData([Constants.Firebase.countKey : FieldValue.increment(Int64(1))]) { error in
                        if let error = error {
                            completion(.failure(.errorIncrementingBookCount(error)))
                        } else {
                            return completion(.success(newScriptureListEntry))
                        }
                    }
            }
        }
    }
    
        func delete(scripture: ScriptureListEntry, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
            
         
            let bookAbb = FormatUtilities.getBookFromChaper(chapterId: scripture.chapterId)
            
            //Finds the verse
            db.collection(Constants.Firebase.scriptureListEntryKey)
                .whereField(Constants.Firebase.scriptureTitle, isEqualTo: scripture.scriptureTitle)
                .whereField(Constants.Firebase.uidKey, isEqualTo: scripture.uid)
                .whereField(Constants.Firebase.listName, isEqualTo: scripture.listName)
                .getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(.errorFetchingVerse(error)))
                    }
                    
                    guard let snapshot = snapshot else {return completion(.failure(.unknownError))}
                    
                    let document = snapshot.documents[0]
                    
                    //Actually Delete
                    self.db.collection(Constants.Firebase.scriptureListEntryKey).document(document.documentID)
                        .delete { error in
                            if let error = error {
                                completion(.failure(.errorDeletingVerse(error)))
                            } else {
                                self.db.collection(Constants.Firebase.bookPopularityCount).document(bookAbb)
                                    .updateData([Constants.Firebase.countKey : FieldValue.increment(Int64(-1))]) { error in
                                        if let error = error {
                                            completion(.failure(.errorDecrementingBookCount(error)))
                                        } else {
                                            return completion(.success(true))
                                        }
                                    }
                                
                            }
                        }
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
                
                
                guard let snapshot = snapshot else {return completion(.failure(.unknownError))}
                
                
                for document in snapshot.documents {
                    let data = document.data()
                    
                    guard let newVerse = ScriptureListEntry(from: data) else { return completion(.failure(.errorPullingFromSnapshotData))}

                    
                    scriptureList.append(newVerse)
                }
                return completion(.success(scriptureList))
            }
    }
    
    func setFavoriteVerse(verse: ScriptureListEntry, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        
        db.collection(Constants.Firebase.scriptureListEntryKey).document(user.uid).setData([
            Constants.Firebase.uidKey : verse.uid,
            Constants.Firebase.chapterId : verse.chapterId,
            Constants.Firebase.listName : verse.uid,
            Constants.Firebase.scriptureTitle : verse.scriptureTitle,
            Constants.Firebase.scriptureNumbers : verse.scriptureNumbers,
            Constants.Firebase.scriptureContentKey : verse.scriptureContent
        ]) { error in
            if let error = error {
                completion(.failure(.errorSettingFavVerse(error)))
            } else {
                
                self.saveFavoriteVerse(item: FavoriteVerse(scriptureTitle: verse.scriptureTitle, scriptureContent: verse.scriptureContent))
                
                completion(.success(true))
            }
        }
    }
    
    func saveFavoriteVerse(item: FavoriteVerse) {
        if #available(iOS 14, *) {
            let newPrimary = PrimaryItem(primaryItem: item)
            newPrimary.storeItem()
        }
    }
    
    
    //List Related
    func fetchAllLists(for uid: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        
        db.collection(Constants.Firebase.scriptureListEntryKey)
            .whereField(Constants.Firebase.uidKey, isEqualTo: uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    return completion(.failure(.errorFetchingList(error)))
                }
                
                guard let snapshot = snapshot else {return completion(.failure(.unknownError))}
                
                
                
                for document in snapshot.documents {
                    
                    let data = document.data()
                    guard let newScriptureListEntry = ScriptureListEntry(from: data) else {
                        return completion(.failure(.errorPullingFromSnapshotData))
                    }
                    
                    if document.documentID == uid {
                        self.favVerse = newScriptureListEntry
                    } else {
                    
                    guard let index = self.lists.firstIndex(where: {$0.name == newScriptureListEntry.listName}) else {return completion(.failure(.noListError(newScriptureListEntry.listName)))}
                    
                    self.lists[index].scriptureListEntries.append(newScriptureListEntry)
                }
                }
                return completion(.success(true))
            }
    }
    
    func createNewList(list: ListItem, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        
        let uid = self.user.uid
        
        db.collection(Constants.Firebase.usersKey).whereField(Constants.Firebase.uidKey, isEqualTo: uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    return completion(.failure(.errorFetchingList(error)))
                }
                
                guard let snapshot = snapshot else {return completion(.failure(.unknownError))}
                
                let document = snapshot.documents[0]
                let firebaseListItem: [String: Any] = [
                    Constants.Firebase.nameKey : list.name,
                    Constants.Firebase.colorKey : list.color,
                    Constants.Firebase.textColorKey : list.textColor,
                    Constants.Firebase.isEmotionKey : list.isEmotion]
                
                self.db.collection(Constants.Firebase.usersKey).document(document.documentID)
                    .updateData([Constants.Firebase.listKey : FieldValue.arrayUnion([firebaseListItem])]) { error in
                        if let error = error {
                            return completion(.failure(.errorAddingList(error)))
                        } else {
                            return completion(.success(true))
                        }
                    }
                
            }
        
    }
    
    func updateList(list: ListItem, color: UIColor, textColor: String, isEmotion: Bool, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        
        list.isEmotion = isEmotion
        list.textColor = ColorUtilities.blackOrWhiteText(color: color).rawValue
        list.color = ColorUtilities.getRGBFromColor(color: color)
        
        db.collection(Constants.Firebase.usersKey).whereField(Constants.Firebase.uidKey, isEqualTo: user.uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    return completion(.failure(.errorPullingUserInfo(error)))
                }
                
                guard let snapshot = snapshot else {return completion(.failure(.unknownError))}
                
                let document = snapshot.documents[0]
                
                let listsDictionary = self.user.lists.map({
                    return [Constants.Firebase.nameKey : $0.name,
                            Constants.Firebase.colorKey : $0.color,
                            Constants.Firebase.textColorKey : $0.textColor,
                            Constants.Firebase.isEmotionKey : $0.isEmotion]
                })
                
                self.db.collection(Constants.Firebase.usersKey).document(document.documentID)
                    .updateData([Constants.Firebase.listKey : listsDictionary]) { error in
                        if let error = error {
                            return completion(.failure(.errorAddingList(error)))
                        } else {
                            return completion(.success(true))
                        }
                    }
            }
    }
    
    func deleteList(list: ListItem, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        
        db.collection(Constants.Firebase.usersKey).whereField(Constants.Firebase.uidKey, isEqualTo: user.uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    return completion(.failure(.errorPullingUserInfo(error)))
                }
                
                guard let snapshot = snapshot else {return completion(.failure(.unknownError))}
                
                let document = snapshot.documents[0]
                
                let firebaseListItem: [String: Any] = [
                    Constants.Firebase.nameKey : list.name,
                    Constants.Firebase.colorKey : list.color,
                    Constants.Firebase.textColorKey : list.textColor,
                    Constants.Firebase.isEmotionKey : list.isEmotion]
              
                
                self.db.collection(Constants.Firebase.usersKey).document(document.documentID)
                    .updateData([Constants.Firebase.listKey : FieldValue.arrayRemove([firebaseListItem])]) { error in
                        if let error = error {
                            return completion(.failure(.errorDeletingList(error)))
                        } else {
                            guard let index = self.lists.firstIndex(of: list) else {return completion(.failure(.errorFindingListIndex))}
                            guard let index2 = self.lists.firstIndex(of: list) else {return completion(.failure(.errorFindingListIndex))}
                            self.lists.remove(at: index)
                            self.user.lists.remove(at: index2)
                            return completion(.success(true))
                        }
                    }
            }
    }
    
    
    func fetchTopBooks(completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        self.db.collection(Constants.Firebase.bookPopularityCount)
            .order(by: Constants.Firebase.countKey, descending: true)
            .limit(to: 20)
            .getDocuments { snapshot, error in
                if let error = error {
                    return completion(.failure(.errorFetchingTopBooks(error)))
                }
                
                guard let snapshot = snapshot else {return completion(.failure(.unknownError))}

                self.topBooksList = []
                
                for documents in snapshot.documents {
                    let data = documents.data()
                    
                    guard let newTopBook = TopBook(from: data) else {return completion(.failure(.errorPullingFromSnapshotData))}
                    
                    self.topBooksList.append(newTopBook)
                }
                
                
                return completion(.success(true))
            }
    }
    
    
}



//Constants.Firebase.listKey : [
//                    [Constants.Firebase.nameKey : Constants.Firebase.listContents[0].name,
//                     Constants.Firebase.colorKey : Constants.Firebase.listContents[0].color,
//                     Constants.Firebase.textColorKey : Constants.Firebase.listContents[0].textColor,
//                     Constants.Firebase.isEmotionKey : Constants.Firebase.listContents[0].isEmotion],
//                    [Constants.Firebase.nameKey : Constants.Firebase.listContents[1].name,
//                     Constants.Firebase.colorKey : Constants.Firebase.listContents[1].color,
//                     Constants.Firebase.textColorKey : Constants.Firebase.listContents[1].textColor,
//                     Constants.Firebase.isEmotionKey : Constants.Firebase.listContents[1].isEmotion],
//                    [Constants.Firebase.nameKey : Constants.Firebase.listContents[2].name,
//                     Constants.Firebase.colorKey : Constants.Firebase.listContents[2].color,
//                     Constants.Firebase.textColorKey : Constants.Firebase.listContents[2].textColor,
//                     Constants.Firebase.isEmotionKey : Constants.Firebase.listContents[2].isEmotion],
//                    [Constants.Firebase.nameKey : Constants.Firebase.listContents[3].name,
//                     Constants.Firebase.colorKey : Constants.Firebase.listContents[3].color,
//                     Constants.Firebase.textColorKey : Constants.Firebase.listContents[3].textColor,
//                     Constants.Firebase.isEmotionKey : Constants.Firebase.listContents[3].isEmotion]
