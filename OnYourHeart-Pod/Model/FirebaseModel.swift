//
//  FirebaseModel.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/24/22.
//

import Foundation
import UIKit

class User {
    
    var firstName: String
    var lastName: String
    var uid: String
    var lists: [ListItem]
    var favVerse: [String: String]
    
    
    init(firstName: String, lastName: String, uid: String, lists: [ListItem] = Constants.Firebase.listContents, favVerse: [String: String] = [:]) {
        self.firstName = firstName
        self.lastName = lastName
        self.uid = uid
        self.lists = lists
        self.favVerse = favVerse
    }
}

extension User {
    convenience init?(from data: [String: Any]) {
        
        guard let firstName = data[Constants.Firebase.firstNameKey] as? String, let lastName = data[Constants.Firebase.lastNameKey] as? String, let uid = data[Constants.Firebase.uidKey] as? String, let lists = data[Constants.Firebase.listKey] as? [ListItem] else {return nil}
            
        self.init(firstName: firstName, lastName: lastName, uid: uid, lists: lists)
    }
}

class ScriptureListEntry {
    
    var uid: String
    var chapterId: String
    var listName: String
    var scriptureTitle: String
    var scriptureNumbers: [Int]
    
    
    
    init(uid: String = FirebaseDataController.shared.user.uid, chapterId: String, listName: String, scriptureTitle: String, scriptureNumbers: [Int]) {
        self.uid = uid
        self.chapterId = chapterId
        self.listName = listName
        self.scriptureTitle = scriptureTitle
        self.scriptureNumbers = scriptureNumbers
    }
}

class ListItem {
    
    
    var name: String
    var color: [Double]
    var textColor: String

    init(name: String, color: [Double], textColor: String = "black") {
        self.name = name
        self.color = color
        self.textColor = textColor
    }
    
}
