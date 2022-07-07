//
//  Constants.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/21/22.
//

import Foundation

//Constants to avoid "magic strings"

struct Constants {
    
    struct Notifications {
        static let favVerseUpdated = "favVerseUpdated"
        static let scriptureAdded = "scriptureAdded"
        static let listAdded = "listAdded"
    }
    
    
    struct Storyboard {
        //Controllers
        static let homeViewController = "MoodVC"
        static let tabBarController = "TabBarController"
        static let loginNavController = "LoginNavController"
        static let mainStoryboard = "Main"
        static let listDetailVC = "ListDetailVC"
        static let addListVC = "AddListVC"
        //Segues
        static let segueScriptureListVC = "ToScriptureListViewController"
        static let segueScriptureDetailView = "toScriptureDetailView"
        static let segueMoodScriptureVC = "toMoodScripture"
        static let toEditList = "EditList"
        //CellIds
        static let chapterNumberCell = "ChapterNumberCell"
        static let bibleBookCell = "BibleBookCell"
        static let verseCell = "VerseCell"
        static let searchVerseCell = "SearchVerseCell"
        static let moodCell = "MoodCell"
        static let listCell = "ListCell"
        static let listVerseCell = "ListVerseCell"
        static let topBookCell = "TopBookCell"
        //Media
        static let videoName = "ScriptureTypingWithVerse"
        static let videoType = "mp4"
    }
    
    struct Firebase {
        //For Users Table
        static let usersKey = "users"
        static let firstNameKey = "firstName"
        static let lastNameKey = "lastName"
        static let uidKey = "uid"
        static let listKey = "lists"
        static let nameKey = "name"
        static let colorKey = "color"
        static let textColorKey = "textColor"
        static let isEmotionKey = "isEmotion"
        static let listContents = [ListItem(name: "Favorites", color: [0.0, 0.0, 0.0], isEmotion: false), ListItem(name: "Anxiety", color: [255.0, 255.0, 255.0], isEmotion: true), ListItem(name: "Frustration", color: [106.0, 98.0, 98.0], isEmotion: true), ListItem(name: "Anger", color: [115.0, 86.0, 71.0], isEmotion: true), ListItem(name: "Sadness", color: [209.0, 128.0, 93.0], isEmotion: true)]
        
        //For ScriptureList Table
        static let scriptureListEntryKey = "scriptureList"
        static let listName = "listName"
        static let scriptureTitle = "scriptureTitle"
        static let chapterId = "chapterId"
        static let scriptureNumbers = "scriptureNumbers"
        
        //For Fav Verse
        static let favVerseKey = "favVerse"
        static let scriptureContentKey = "scriptureContent"
        
        //For Leaderboard
        static let bookPopularityCount = "bookPopularityCount"
        static let countKey = "count"
        
        
    }
    
       
    struct API {
        //General
        static let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        static let apiKeyKey = "api-key"
        static let baseURL = "https://api.scripture.api.bible"
        static let bsbBibleKey = "bba9f40183526463-01"
        static let trueKey = "true"
        static let falseKey = "false"
        static let version = "v1"
        static let fumsBaseURL = "https://fums.api.bible/f3"
        static let fumsTokenQuery = "t"
        static let dIdQuery = "dId"
        static let sIdQuery = "sId"
        static let uIdQuery = "uId"
        //Books Endpoint
        static let booksComponent = "books"
        static let biblesComponent = "bibles"
        static let chaptersComponent = "chapters"
        static let chaptersAndSectionsKey = "include-chapters-and-sections"
        //Chapter Endpoint
        static let contentTypeQuery = "content-type"
        static let json = "json"
        static let includeNotesQuery = "include-notes"
        static let includeTitlesQuery = "include-titles"
        static let includeChapterNumsQuery = "include-chapter-numbers"
        static let includeVerseNumsQuery = "include-verse-numbers"
        static let includeVerseSpansQuery = "include-verse-spans"
        //Search Endpoint
        static let searchComponent = "search"
        static let queryKey = "query"
        static let limitKey = "limit"
        static let sortKey = "sort"
        static let relevanceKey = "relevance"
        static let fuzzinessKey = "fuzziness"
        static let autoKey = "AUTO"
    }
}
