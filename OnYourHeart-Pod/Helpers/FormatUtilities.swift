//
//  FormatUtilities.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/24/22.
//

//MRK.16

import Foundation

class FormatUtilities {
    static func formatVerseCode(verseId: String) -> String {
        let splitVerseCode = verseId.split(separator: ".")
        return splitVerseCode[1] + ":" + splitVerseCode[2]
    }
    static func getBookAndChapter(chapterId: String) -> String {
        if let name = BibleController.shared.books.first(where: {chapterId.contains($0.abbreviation)})?.name {
            let chapter = chapterId.split(separator: ".")[1]
            return name + " " + chapter
        } else {
            return "Couldn't find name"
        }
    }
}
