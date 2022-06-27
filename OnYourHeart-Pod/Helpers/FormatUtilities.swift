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
    static func getScriptureTitle(title: String, scriptureNumbers: [Int]) -> String {
        
        var formattedScriptures = ""
        if scriptureNumbers.count <= 1 {
            formattedScriptures = "\(scriptureNumbers[0])"
        } else if isIncremented(numList: scriptureNumbers) {
            formattedScriptures = "\(scriptureNumbers.first!)-\(scriptureNumbers.last!)"
        } else {
            formattedScriptures = scriptureNumbers.map({"\($0)"}).joined(separator: ",")
        }
        
        return title + ": " + formattedScriptures
        
        
        //Phillipians 4:6-8 or Philippians 4:5,6,8,20, Philippians 4:7
    }
    
    static func getVerseFromId(verseId: String) -> [Int] {
        
        let splitNumber = verseId.split(separator: ".")[2]
        guard let numbers = Int(splitNumber) else {return [1]}
        
        return [numbers]
    }
    
    static private func isIncremented(numList: [Int]) -> Bool {
        
        for num in (0..<numList.count-1) {
            if numList[num+1] - numList[num] > 1 {
                return false
            }
        }
        
        return true
    }
    
    
}
