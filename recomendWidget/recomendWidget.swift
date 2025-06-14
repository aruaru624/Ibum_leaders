//
//  recomendWidget.swift
//  recomendWidget
//
//  Created by tanaka niko on 2025/06/15.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), quest: Quest(
            title: "グッジョブ！",
            ids: [],
            tags: [.genki, .pose],
            favorite: false,
            clear: false,
            explation: "元気よく親指を立てるポジティブなポーズ",
            recommendedPoses: ["ウインクしながら", "軽く前かがみで", "大きく腕を伸ばして"],
            recommendedLocation: "芝生の上で太陽に向かって",
            rarity: .common
        ), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), quest: Quest(
            title: "グッジョブ！",
            ids: [],
            tags: [.genki, .pose],
            favorite: false,
            clear: false,
            explation: "元気よく親指を立てるポジティブなポーズ",
            recommendedPoses: ["ウインクしながら", "軽く前かがみで", "大きく腕を伸ばして"],
            recommendedLocation: "芝生の上で太陽に向かって",
            rarity: .common
        ), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        var quest :Quest?

        Task { @MainActor in
                    
                // SwiftDataからデータ取得
        let context = sharedModelContainer.mainContext
        let quests = (try? context.fetch(FetchDescriptor<Quest>())) ?? []
        quest = quests.randomElement()
                    // 取得したデータを使ってentriesに追加
        }
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let num = Int.random(in: 0...15)
            print(num)
            let entry = SimpleEntry(date: entryDate, quest: quest ?? Quest(
                title: "グッジョブ！",
                ids: [],
                tags: [.genki, .pose],
                favorite: false,
                clear: false,
                explation: "元気よく親指を立てるポジティブなポーズ",
                recommendedPoses: ["ウインクしながら", "軽く前かがみで", "大きく腕を伸ばして"],
                recommendedLocation: "芝生の上で太陽に向かって",
                rarity: .common
            ), configuration: configuration)
            
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let quest :Quest
    let configuration: ConfigurationAppIntent
}

struct recomendWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.modelContext) private var context
    @Query var quests: [Quest]
    
//    @State var

    var body: some View {
        
        ZStack{
            Color(red: 151/255, green: 254/255, blue: 237/255)
                .ignoresSafeArea()
            HStack {
                

                    VStack{
                        Text(entry.quest.title)
                            .fontWeight(.bold)
                            .font(.system(size: 7))
                        Text("オススメ")
                            .font(.system(size: 3))
                        Text(entry.quest.recommendedLocation)
                            .font(.system(size: 5))
                    }
                ZStack{
                    Color.white
                        .aspectRatio(2/3, contentMode: .fit)
//                        .padding(10)
                    if let image = UIImage(named: String(entry.quest.title)){
                        Image(uiImage:image)
                            .resizable()
                            .aspectRatio(2/3, contentMode: .fill)
//                            .padding(10)
                            .clipShape(UnevenRoundedRectangle(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 15,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 0,
                                style: .continuous))
                        //                    Image(systemName: "camera")
                        //                        .resizable()
                        //                        .scaledToFit()
                        //                        .padding(10)
                        //                        .scaleEffect(0.4)
                        //                        .foregroundStyle(Color(red: 53/255, green: 162/255, blue: 159/255))
                    }
                    
                    
                    
                }
            }
        }
        
    }
}

struct recomendWidget: Widget {
    let kind: String = "recomendWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                recomendWidgetEntryView(entry: entry)
                    .containerBackground(Color(red: 151/255, green: 254/255, blue: 237/255), for: .widget)
                
                
            } else {
                recomendWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

//#Preview(as: .systemSmall) {
//    recomendWidget()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}
