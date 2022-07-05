//
//  FormatUtilities.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/24/22.
//


import Foundation


//Formates sscripture strings
class FormatUtilities {
    
    static func getBookFromChaper(chapterId: String) -> String {
        let splitChapter = chapterId.split(separator: ".")
        return "\(splitChapter[0])"
    }
    
    //Gets verse code like 4:12
    static func formatVerseCode(verseId: String) -> String {
        let splitVerseCode = verseId.split(separator: ".")
        return splitVerseCode[1] + ":" + splitVerseCode[2]
    }
    
    //Inputs a chapter Id like "Gen.3" and outputs "Genesis 3"
    static func getBookAndChapter(chapterId: String) -> String {
        if let name = BibleController.shared.books.first(where: {chapterId.contains($0.abbreviation)})?.name {
            let chapter = chapterId.split(separator: ".")[1]
            return name + " " + chapter
        } else {
            return "Couldn't find name"
        }
    }
    
    //Inputs a list of scriptures [9,10,11] and book and chapter title, outputs Philippians 4: 9-11
    static func getScriptureTitle(title: String, scriptureNumbers: [Int]) -> String {
        
        var formattedScriptures = ""
        if scriptureNumbers.count <= 1 {
            formattedScriptures = "\(scriptureNumbers[0])"
        } else if isIncremented(numList: scriptureNumbers) {
            formattedScriptures = "\(scriptureNumbers.first!)-\(scriptureNumbers.last!)"
        } else {
            formattedScriptures = scriptureNumbers.map({"\($0)"}).joined(separator: ",")
        }
        
        return title + ":" + formattedScriptures
        
        
        //Phillipians 4:6-8 or Philippians 4:5,6,8,20, Philippians 4:7
    }
    
    //Pulls verse number from the verse Id
    static func getVerseFromId(verseId: String) -> [Int] {
        
        let splitNumber = verseId.split(separator: ".")[2]
        guard let numbers = Int(splitNumber) else {return [1]}
        
        return [numbers]
    }
    
    //Checks if a list of numbers increments by one or not
    static private func isIncremented(numList: [Int]) -> Bool {
        
        for num in (0..<numList.count-1) {
            if numList[num+1] - numList[num] > 1 {
                return false
            }
        }
        
        return true
    }
    
}
