//
//  FirebaseModel.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/24/22.
//

import Foundation
import UIKit
import FirebaseAuth

class AppUser {
    
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

extension AppUser {
    convenience init?(from data: [String: Any]) {
        
        guard let firstName = data[Constants.Firebase.firstNameKey] as? String, let lastName = data[Constants.Firebase.lastNameKey] as? String, let uid = data[Constants.Firebase.uidKey] as? String, let lists = data[Constants.Firebase.listKey] as? [[String: Any]] else {return nil}
        
        var listItems: [ListItem] = []
        
        for listItem in lists {
            guard let newListItem = ListItem(from: listItem) else {return nil}
            listItems.append(newListItem)
        }
            
        self.init(firstName: firstName, lastName: lastName, uid: uid, lists: listItems)
    }
}

class ScriptureListEntry {
    
    var uid: String
    var chapterId: String
    var listName: String
    var scriptureTitle: String
    var scriptureNumbers: [Int]
    var scriptureContent: String
    
    
    
    init(uid: String = FirebaseDataController.shared.user.uid, chapterId: String, listName: String, scriptureTitle: String, scriptureNumbers: [Int], scriptureContent: String) {
        self.uid = uid
        self.chapterId = chapterId
        self.listName = listName
        self.scriptureTitle = scriptureTitle
        self.scriptureNumbers = scriptureNumbers
        self.scriptureContent = scriptureContent
    }
}

extension ScriptureListEntry {
    convenience init?(from data: [String: Any]) {
        guard let chapterId = data[Constants.Firebase.chapterId] as? String,
              let listName = data[Constants.Firebase.listName] as? String,
              let scriptureTitle = data[Constants.Firebase.scriptureTitle] as? String,
              let scriptureNumbers = data[Constants.Firebase.scriptureNumbers] as? [Int],
              let scriptureContent = data[Constants.Firebase.scriptureContentKey] as? String
        else {return nil}
        
        
        self.init(chapterId: chapterId, listName: listName, scriptureTitle: scriptureTitle, scriptureNumbers: scriptureNumbers, scriptureContent: scriptureContent)
    }
}

extension ScriptureListEntry: Equatable {}
func ==(lhs: ScriptureListEntry, rhs: ScriptureListEntry) -> Bool{
    return lhs.scriptureTitle == rhs.scriptureTitle
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

extension ListItem {
    convenience init?(from listData: [String: Any]) {
        guard let color = listData[Constants.Firebase.colorKey] as? [Double],
              let name = listData[Constants.Firebase.nameKey] as? String,
              let textColor = listData[Constants.Firebase.textColorKey] as? String else {return nil}
        
        
        self.init(name: name, color: color, textColor: textColor)
    }
}
