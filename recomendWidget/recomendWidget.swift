//
//  recomendWidget.swift
//  recomendWidget
//
//  Created by tanaka niko on 2025/06/15.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Providerr: AppIntentTimelineProvider {
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
        // 非同期でmainContextを取得
            let mainContext = await sharedModelContainer.mainContext

            // ここでfetchも非同期ならawaitを付ける
            let quests: [Quest]
            do {
                quests = try await mainContext.fetch(FetchDescriptor<Quest>())
            } catch {
                quests = []
                print("Fetch error: \(error)")
            }

            let quest = quests.randomElement()

            let currentDate = Date()
            var entries: [SimpleEntry] = []
            for hourOffset in 0..<5{
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, quest: quest ?? defaultQuest(), configuration: configuration)
                entries.append(entry)
            }

            return Timeline(entries: entries, policy: .atEnd)
    }
    
    func defaultQuest() -> Quest {
        Quest(
            title: "グッジョブ！",
            ids: [],
            tags: [.genki, .pose],
            favorite: false,
            clear: false,
            explation: "元気よく親指を立てるポジティブなポーズ",
            recommendedPoses: ["ウインクしながら", "軽く前かがみで", "大きく腕を伸ばして"],
            recommendedLocation: "芝生の上で太陽に向かって",
            rarity: .common
        )
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
    var entry: Providerr.Entry
    
    @Environment(\.modelContext) private var context
    @Query var quests: [Quest]
    
//    @State var

    var body: some View {
        
        ZStack{
            Color(red: 151/255, green: 254/255, blue: 237/255)
                .ignoresSafeArea()
//            Text("あ")
            
            HStack {

                    VStack{
                        Text("クエスト：" + entry.quest.title)
                            .fontWeight(.bold)
                            .font(.system(size: 10))
                            .padding(3)
                        Text("オススメのシチュエーション")
                            .font(.system(size: 7))
                            .fontWeight(.semibold)
                            .padding(1)

                        Text(entry.quest.recommendedLocation)
                            .font(.system(size: 8))
//                            .padding()

                        
//                            .frame(width: <#T##CGFloat?#>)
                    }
                ZStack{
                    Color.white
                        .aspectRatio(2/3, contentMode: .fit)
                    if let image = UIImage(named: String(entry.quest.title)),
                       let resizedImage = image.resized(to: CGSize(width: 200, height: 300)){
                       
    //                        .padding(10)
                        Image(uiImage:resizedImage)
                            
                            .resizable()
                            .aspectRatio(2/3, contentMode: .fit)
                            .padding(10)
//                            .background(.black)
//                            .foregroundStyle(.black)
                            .clipShape(UnevenRoundedRectangle(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 15,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 0,
                                style: .continuous))
//                        Image(systemName: "camera")
//                            .resizable()
//                            .scaledToFit()
////                            .padding(10)
//                            .scaleEffect(0.2)
//                            .foregroundStyle(Color(red: 53/255, green: 162/255, blue: 159/255))
                    }else{
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
//                            .padding(10)
                            .scaleEffect(0.2)
                            .foregroundStyle(Color(red: 53/255, green: 162/255, blue: 159/255))
                    }
//                    
                    
                    
                }
            }
        }
        
    }
    func defaultQuest() -> Quest {
        Quest(
            title: "グッジョブ！",
            ids: [],
            tags: [.genki, .pose],
            favorite: false,
            clear: false,
            explation: "元気よく親指を立てるポジティブなポーズ",
            recommendedPoses: ["ウインクしながら", "軽く前かがみで", "大きく腕を伸ばして"],
            recommendedLocation: "芝生の上で太陽に向かって",
            rarity: .common
        )
    }
}

struct recomendWidget: Widget {
    let kind: String = "recomendWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Providerr()) { entry in
            if #available(iOS 17.0, *) {
                recomendWidgetEntryView(entry: entry)
                    .containerBackground(Color(red: 151/255, green: 254/255, blue: 237/255), for: .widget)
                
                
            } else {
                recomendWidgetEntryView(entry: entry)
                    .padding()
                    .background(Color(red: 151/255, green: 254/255, blue: 237/255))
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

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1  // Widgetでは1が安全
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
