//
//  BibleModel.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/22/22.
//

import Foundation

struct TopLevelBooksObject: Codable {
    var data: [Book]
}

struct Book: Codable {
    var id: String
    var bibleId: String
    var name: String
    var abbreviation: String
    var chapters: [Chapter]
}

struct Chapter: Codable {
    var id: String
    var bibleId: String
    var bookId: String
    var number: String
}


struct TopLevelChapterObject: Codable {
    var data: ChapterContent
}

struct ChapterContent: Codable {
    var id: String
    var bibleId: String
    var number: String
    var bookId: String
    var reference: String
    var copyright: String
    var verseCount: Int
    var content: [VerseContent]
}

struct VerseContent: Codable {
    var items: [VerseFragment]
}
struct VerseFragment: Codable {
    var text: String
    var attrs: VerseID
}

struct VerseID:Codable {
    var verseId: String
}

struct Verse: Codable {
    var content: String
    var id: String
    var chapterId: String
}
