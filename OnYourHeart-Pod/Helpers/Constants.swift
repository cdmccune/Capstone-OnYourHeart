//
//  Constants.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/21/22.
//

import Foundation

struct Constants {
    struct Storyboard {
        static let homeViewController = "MoodVC"
        static let tabBarController = "TabBarController"
        static let bibleBookCell = "BibleBookCell"
        static let chapterNumberCell = "ChapterNumberCell"
        static let segueScriptureDetailView = "toScriptureDetailView"
        static let segueScriptureListVC = "ToScriptureListViewController"
        static let verseCell = "VerseCell"
    }
    
    struct Firebase {
        //For Users Table
        static let usersKey = "users"
        static let firstNameKey = "firstName"
        static let lastNameKey = "lastName"
        static let uidKey = "uid"
        static let listKey = "list"
        static let listContents = ["Favorites", "Depressed", "Grateful", "Frustrated", "Content", "Angry"]
    }
    
    struct API {
        static let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        static let baseURL = "https://api.scripture.api.bible"
        static let bsbBibleKey = "bba9f40183526463-01"
        static let chaptersAndSectionsKey = "include-chapters-and-sections"
        static let trueKey = "true"
        static let falseKey = "false"
        static let version = "v1"
        static let biblesComponent = "bibles"
        static let chaptersComponent = "chapters"
        static let booksComponent = "books"
        static let contentTypeQuery = "content-type"
        static let json = "json"
        static let includeNotesQuery = "include-notes"
        static let includeTitlesQuery = "include-titles"
        static let includeChapterNumsQuery = "include-chapter-numbers"
        static let includeVerseNumsQuery = "include-verse-numbers"
        static let includeVerseSpansQuery = "include-verse-spans"
        static let apiKeyKey = "api-key"
    }
}
