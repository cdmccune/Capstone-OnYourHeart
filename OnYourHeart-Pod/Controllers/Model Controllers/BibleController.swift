//
//  BibleController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/22/22.
//

import Foundation

class BibleController {
    
    //MARK: - Properties
    
    static var shared = BibleController()
    
    var books: [Book] = []
    var chapters: [Chapter] = []
    var verses: [Verse] = []
    var searchVerses: [SearchVerse] = []
    
    // MARK: - Bible API Fetching Functions
    
    
    
    
    
    func fetchBooks(completion: @escaping(Result<[Book], ApiError>) -> Void) {
        
        //URL Building
        
        //Base URL with components
        let baseURL = Constants.API.baseURL
        let components = [Constants.API.version,
                          Constants.API.biblesComponent,
                          Constants.API.bsbBibleKey,
                         Constants.API.booksComponent]
        guard var baseURL = URL(string: baseURL) else {return completion(.failure(.badBaseURL))}
        components.forEach({baseURL.appendPathComponent($0)})
        var url = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        //Query
        let chaptersAndSectionsQuery = URLQueryItem(name: Constants.API.chaptersAndSectionsKey, value: Constants.API.trueKey)
        url?.queryItems = [chaptersAndSectionsQuery]
        guard let finalURL = url?.url else {return completion(.failure(.badBuiltURL))}
        
        //Header
        var request = URLRequest(url: finalURL)
        guard let apiKey = Constants.API.apiKey else {return completion(.failure(.invalidApiKey))}
        request.setValue(apiKey, forHTTPHeaderField: Constants.API.apiKeyKey)
        
        //URL Session to make the Api call
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(.sessionError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    return completion(.failure(.responseNot200(response)))
                }
            }
            
            guard let data = data else {return completion(.failure(.badData))}

            do {
                let topLevelBooksObject = try JSONDecoder().decode(TopLevelBooksObject.self, from: data)
                return completion(.success(topLevelBooksObject.data))
            } catch let e {
                return completion(.failure(.errorDecodingData(e)))
            }
        }.resume()
        
    }
    
    func fetchChapter(_ chapterID: String, completion: @escaping (Result<[Verse], ApiError>) -> Void) {
        
        //Request Building
        
        //BaseURL + Components
        let baseURL = Constants.API.baseURL
        let components = [Constants.API.version,
                          Constants.API.biblesComponent,
                          Constants.API.bsbBibleKey,
                          Constants.API.chaptersComponent,
        chapterID]
        guard var baseURL = URL(string: baseURL) else {return completion(.failure(.badBaseURL))}
        components.forEach({baseURL.appendPathComponent($0)})
        guard var url = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {return completion(.failure(.badBaseURL))}
        
        //Query Items
        let contentTypeQuery = URLQueryItem(name: Constants.API.contentTypeQuery, value: Constants.API.json)
        let includesTitlesQuery = URLQueryItem(name: Constants.API.includeTitlesQuery, value: Constants.API.falseKey)
        let includesNotesQuery = URLQueryItem(name: Constants.API.includeNotesQuery, value: Constants.API.falseKey)
        let includesVerseNumsQuery = URLQueryItem(name: Constants.API.includeVerseNumsQuery, value: Constants.API.falseKey)
        let includesVerseSpansQuery = URLQueryItem(name: Constants.API.includeVerseSpansQuery, value: Constants.API.falseKey)
        let includesChapterNumsQuery = URLQueryItem(name: Constants.API.includeChapterNumsQuery, value: Constants.API.falseKey)
        
        url.queryItems = [contentTypeQuery,
                           includesNotesQuery,
                           includesTitlesQuery,
                           includesChapterNumsQuery,
                           includesVerseNumsQuery,
                           includesVerseSpansQuery]
        guard let finalURL = url.url else {return completion(.failure(.badBuiltURL))}
        
        //Header
        var request = URLRequest(url:finalURL)
        guard let apiKey = Constants.API.apiKey else {return completion(.failure(.invalidApiKey))}
        request.setValue(apiKey, forHTTPHeaderField: Constants.API.apiKeyKey)
        
        //URL Session to make the Api call
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(.sessionError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    return completion(.failure(.responseNot200(response)))
                }
            }
            
            guard let data = data else {return completion(.failure(.badData))}
            
            do {
                let topLevelChapterObject = try JSONDecoder().decode(TopLevelChapterObject.self, from: data)
                let chapterContent = topLevelChapterObject.data
                var verses: [Verse] = []
                chapterContent.content.forEach { verseContent in
                    if verseContent.items.count > 0 {
                        verseContent.items.forEach { verseFragment in
                            if let index = verses.firstIndex(where: { $0.id == verseFragment.attrs.verseId}) {
                                verses[index].content += verseFragment.text
                            } else {
                                let newVerse = Verse(content: verseFragment.text, id: verseFragment.attrs.verseId, chapterId: chapterContent.id)
                                verses.append(newVerse)
                            }
                                
                        }
                    }
                }
                
                
                
                return completion(.success(verses))
            } catch let e {
                return completion(.failure(.errorDecodingData(e)))
            }
        }.resume()
        
    }
    
    
    func fetchQuery(_ query: String, completion: @escaping (Result<[SearchVerse], ApiError>) -> Void) {
        
    //https://api.scripture.api.bible/v1/bibles/bba9f40183526463-01/search?query=peace&limit=20&sort=relevance&fuzziness=AUTO
        
        //Request Building
        
        //BaseURL + Components
        let baseURL = Constants.API.baseURL
        let components = [Constants.API.version,
                          Constants.API.biblesComponent,
                          Constants.API.bsbBibleKey,
                          Constants.API.searchComponent]
        
        guard var baseURL = URL(string: baseURL) else {return completion(.failure(.badBaseURL))}
        components.forEach({baseURL.appendPathComponent($0)})
        guard var url = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {return completion(.failure(.badBaseURL))}
        
        
        //Query Items
        let searchQueryItem = URLQueryItem(name: Constants.API.queryKey, value: query)
        let limitQuery = URLQueryItem(name: Constants.API.limitKey, value: "20")
        let sortQuery = URLQueryItem(name: Constants.API.sortKey, value: Constants.API.relevanceKey)
        let fuzzinessQuery = URLQueryItem(name: Constants.API.fuzzinessKey, value: Constants.API.autoKey)
        
        url.queryItems = [searchQueryItem,
                          limitQuery,
                          sortQuery,
                          fuzzinessQuery]
        
        guard let finalURL = url.url else {return completion(.failure(.badBuiltURL))}
        
        //Header
        var request = URLRequest(url: finalURL)
        guard let apiKey = Constants.API.apiKey else { return completion(.failure(.invalidApiKey))
        }
        request.setValue(apiKey, forHTTPHeaderField: Constants.API.apiKeyKey)
        
        
        //URL Session to make the Api call
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(.sessionError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    return completion(.failure(.responseNot200(response)))
                }
            }
            
            guard let data = data else {
                return completion(.failure(.badData))
            }
            
            do {
                let topLevelSearchObject = try JSONDecoder().decode(TopLevelVerseObject.self, from: data)
                let verses = topLevelSearchObject.data.verses
                return completion(.success(verses))
            } catch let e {
                return completion(.failure(.errorDecodingData(e)))
            }
        }.resume()
    }
}
