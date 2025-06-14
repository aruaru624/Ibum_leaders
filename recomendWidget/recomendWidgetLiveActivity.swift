//
//  recomendWidgetLiveActivity.swift
//  recomendWidget
//
//  Created by tanaka niko on 2025/06/15.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct recomendWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct recomendWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: recomendWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension recomendWidgetAttributes {
    fileprivate static var preview: recomendWidgetAttributes {
        recomendWidgetAttributes(name: "World")
    }
}

extension recomendWidgetAttributes.ContentState {
    fileprivate static var smiley: recomendWidgetAttributes.ContentState {
        recomendWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: recomendWidgetAttributes.ContentState {
         recomendWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: recomendWidgetAttributes.preview) {
   recomendWidgetLiveActivity()
} contentStates: {
    recomendWidgetAttributes.ContentState.smiley
    recomendWidgetAttributes.ContentState.starEyes
}
