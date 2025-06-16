//
//  recomendWidgetControl.swift
//  recomendWidget
//
//  Created by tanaka niko on 2025/06/15.
//

import AppIntents
import SwiftUI
import WidgetKit

struct recomendWidgetControl: ControlWidget {
    static let kind: String = "app.tanaka.a-ru.leaders.Ibum.recomendWidget"

    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: Self.kind,
            provider: Provider()
        ) { value in
            ControlWidgetToggle(
                "Start Timer",
                isOn: value.isRunning,
                action: StartTimerIntent(value.name)
            ) { isRunning in
                Label(isRunning ? "On" : "Off", systemImage: "timer")
            }
        }
        .displayName("オススメポーズ")
        .description("ポーズを参考にして写真を撮ろう！")
        
    }
}

extension recomendWidgetControl {
    struct Value {
        var isRunning: Bool
        var name: String
    }

    struct Provider: AppIntentControlValueProvider {
        func previewValue(configuration: TimerConfiguration) -> Value {
            recomendWidgetControl.Value(isRunning: false, name: configuration.timerName)
        }

        func currentValue(configuration: TimerConfiguration) async throws -> Value {
            let isRunning = true // Check if the timer is running
            return recomendWidgetControl.Value(isRunning: isRunning, name: configuration.timerName)
        }
    }
}

struct TimerConfiguration: ControlConfigurationIntent {
    static let title: LocalizedStringResource = "Timer Name Configuration"

    @Parameter(title: "Timer Name", default: "Timer")
    var timerName: String
}

struct StartTimerIntent: SetValueIntent {
    static let title: LocalizedStringResource = "Start a timer"

    @Parameter(title: "Timer Name")
    var name: String

    @Parameter(title: "Timer is running")
    var value: Bool

    init() {}

    init(_ name: String) {
        self.name = name
    }

    func perform() async throws -> some IntentResult {
        // Start the timer…
        return .result()
    }
}

//struct Provider: TimelineProvider {
//    func placeholder(in context: Context) -> Entry {
//        Entry(date: Date(), isRunning: false, name: "Timer")
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
//        let entry = Entry(date: Date(), isRunning: true, name: "Snapshot")
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
//        let entry = Entry(date: Date(), isRunning: true, name: "From Timeline")
//        let timeline = Timeline(entries: [entry], policy: .never)
//        completion(timeline)
//    }
//}

struct Entry: TimelineEntry {
    let date: Date
    let isRunning: Bool
    let name: String
}
