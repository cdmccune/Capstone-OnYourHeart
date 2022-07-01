//
//  PrimaryItem.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 7/1/22.
//

import SwiftUI
import WidgetKit

@available(iOS 14, *)
struct PrimaryItem {
    @AppStorage(WidgetsConstants.Objects.favVerseItem, store: UserDefaults(suiteName: WidgetsConstants.Objects.groupName)) var primaryItemData: Data = Data()
    let primaryItem: FavoriteVerse
    
    func storeItem() {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(primaryItem) else {
            print("Could not encode data")
            return
        }
        
        primaryItemData = data
        WidgetCenter.shared.reloadAllTimelines()
        print(String(decoding: primaryItemData, as: UTF8.self))
    }
}

class FavoriteVerse: Codable {
    
    var scriptureTitle: String
    var scriptureContent: String
    
    internal init(scriptureTitle: String, scriptureContent: String) {
        self.scriptureTitle = scriptureTitle
        self.scriptureContent = scriptureContent
    }
}



