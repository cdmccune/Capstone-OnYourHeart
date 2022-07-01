//
//  FavoriteVerse_Widget.swift
//  FavoriteVerse-Widget
//
//  Created by Curt McCune on 7/1/22.
//

import WidgetKit
import SwiftUI

struct FavoriteVerseEntry: TimelineEntry {
    let date: Date = Date()
    let favVerseItem: FavoriteVerse
}

struct Provider: TimelineProvider {
    @AppStorage(WidgetsConstants.Objects.favVerseItem, store: UserDefaults(suiteName: WidgetsConstants.Objects.groupName)) var primaryItemData: Data = Data()
    func placeholder(in context: Context) -> FavoriteVerseEntry {
        let favVerseItem = FavoriteVerse(scriptureTitle: "John 3:16", scriptureContent: "For God so loved the world that He gave His one and only Son, that everyone who believes in Him shall not perish but have eternal life.")
       return FavoriteVerseEntry(favVerseItem: favVerseItem)
    }

    func getSnapshot(in context: Context, completion: @escaping (FavoriteVerseEntry) -> ()) {
        guard let favVerseItem = try? JSONDecoder().decode(FavoriteVerse.self, from: primaryItemData) else {
            print("Unable to decode primary item.")
            return
        }
        let entry = FavoriteVerseEntry(favVerseItem: favVerseItem)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        guard let favVerseItem = try? JSONDecoder().decode(FavoriteVerse.self, from: primaryItemData) else {
            print("Unable to decode primary item.")
            return
        }
        let entry = FavoriteVerseEntry(favVerseItem: favVerseItem)

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct FavoriteVerse_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color(WidgetsConstants.Colors.lightTan)
            VStack(alignment: .center) {
                Text(entry.favVerseItem.scriptureTitle)
                    .font(.title)
                    .foregroundColor(Color(WidgetsConstants.Colors.darkBrown))
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.3)
                    .overlay(
                        Rectangle()
                            .frame(height: 2)
                            .offset(y:0)
                            .foregroundColor(Color(WidgetsConstants.Colors.darkBrown))
                        , alignment: .bottom
                    )
                    .lineLimit(1)
                    
                Spacer()
                Text(entry.favVerseItem.scriptureContent)
                    
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Color(WidgetsConstants.Colors.darkBrown))
                Spacer()
                Text("Berean Study Bible © Bible Hub, 2020.")
                    .foregroundColor(Color(WidgetsConstants.Colors.darkBrown))
                    .font(.caption2)
                    .fontWeight(.thin)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .padding(.bottom, 5.0)
                    .minimumScaleFactor(0.1)

            }
            .padding([.top, .leading, .trailing])
            
        }
        
    }
}

@main
struct FavoriteVerse_Widget: Widget {
    let kind: String = "FavoriteVerse_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FavoriteVerse_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("On Your Heart")
        .description("This is the widget to display your current favorite verse.")
        .supportedFamilies([.systemSmall,.systemMedium])
    }
}

struct FavoriteVerse_Widget_Previews: PreviewProvider {
    static var previews: some View {
                
        FavoriteVerse_WidgetEntryView(entry: FavoriteVerseEntry(favVerseItem: FavoriteVerse(scriptureTitle: "John 3:16", scriptureContent: "For God so loved the world that He gave His one and only Son, that everyone who believes in Him shall not perish but have eternal life.")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            
    }
}
