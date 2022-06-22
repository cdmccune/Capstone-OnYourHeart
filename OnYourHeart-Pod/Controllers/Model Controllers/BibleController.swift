//
//  BibleController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/22/22.
//

import Foundation

class BibleController {
    
    // Bible API Fetching Functions
    
    
    
    
    
    func fetchBooks(completion: @escaping(Result<[Book], ApiError>) -> Void) {
        
        //URL Building
        
        let baseURL = Constants.API.baseURL
        
        let components = [Constants.API.version,
                         Constants.API.biblesComponent,
                         Constants.API.booksComponent]
        
        guard var baseURL = URL(string: baseURL) else {return completion(.failure(.badBaseURL))}
        
        components.forEach({baseURL.appendPathComponent($0)})
        
        var url = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let chaptersAndSectionsQuery = URLQueryItem(name: Constants.API.chaptersAndSectionsKey, value: Constants.API.trueKey)
        
        url?.queryItems = [chaptersAndSectionsQuery]
        
        guard let finalURL = url?.url else {return completion(.failure(.badBuiltURL))}
                                                              
        var request = URLRequest(url: finalURL)
        
        guard let apiKey = Constants.API.apiKey else {return completion(.failure(.invalidApiKey))}
        
        request.addValue(apiKey, forHTTPHeaderField: "api-key")
        
        //URL Session Here
        
        
    }
    
    func fetchChapter(_ chapter: String, from book: String) {
        
    }
    
    
    
}
