//
//  HWMTimersWatchWidgetExtension.swift
//  HWMTimersWatchWidgetExtension
//
//  Created by Ant Gardiner on 17/10/23.
//

import WidgetKit
import SwiftUI
import HWMTimersShared

struct HWMTimerTimelineProvider: AppIntentTimelineProvider {
	func placeholder(in context: Context) -> TimersEntry {
		TimersEntry(date: Date(), timers: timers, configuration: TimersWidgetConfigurationIntent())
	}
	
	func snapshot(for configuration: TimersWidgetConfigurationIntent, in context: Context) async -> TimersEntry {
		TimersEntry(date: Date(), timers: timers, configuration: configuration)
	}
	
	func timeline(for configuration: TimersWidgetConfigurationIntent, in context: Context) async -> Timeline<TimersEntry> {
		var entries: [TimersEntry] = []
		
		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let currentDate = Date()
		for hourOffset in 0 ..< 5 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = TimersEntry(date: entryDate, timers: timers, configuration: configuration)
			entries.append(entry)
		}
		
		return Timeline(entries: entries, policy: .atEnd)
	}
	
	func recommendations() -> [AppIntentRecommendation<TimersWidgetConfigurationIntent>] {
		// Create an array with all the preconfigured widgets to show.
		[AppIntentRecommendation(intent: TimersWidgetConfigurationIntent(), description: "Example Widget")]
	}
	
	private var timers: [AGHomeworldMobileTimer] {
		do {
			let data = try Data(contentsOf: WidgetSyncManager.timersURL)
			let timers = try Array.loadTimers(from: data)
			return timers
		}
		catch {
			return []
		}
	}
}

struct TimersEntry: TimelineEntry {
	var date: Date
	let timers: [AGHomeworldMobileTimer]
	let configuration: TimersWidgetConfigurationIntent
	
	var firstRunningTimer: AGHomeworldMobileTimer? {
		let earliestTimer = timers.min()
		return (earliestTimer?.running ?? false) ? earliestTimer : nil
	}
}

struct HWMTimersWatchWidgetEntryView : View {
	@Environment(\.widgetFamily) var family: WidgetFamily
	var entry: HWMTimerTimelineProvider.Entry
	
	var body: some View {
		switch family {
		case .accessoryCorner:
			HWMTimersWigetEntryCornerView(entry: entry)
		case .accessoryInline:
			HWMTimersWigetEntryInlineView(entry: entry)
		case .accessoryRectangular:
			HWMTimersWigetEntryRectangularView(entry: entry)
		case .accessoryCircular:
			HWMTimersWigetEntryCircularView(entry: entry)
		case .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge:
			EmptyView()
		@unknown default:
			EmptyView()
		}
	}
}

struct HWMTimersWigetEntryCircularView : View {
	var entry: HWMTimerTimelineProvider.Entry
	
	var body: some View {
		ZStack {
			AccessoryWidgetBackground()
			if let timer = entry.firstRunningTimer {
				VStack(alignment: .center, spacing: 0) {
					switch timer.type {
					case .remoteMining:
						RemoteMiningView(forgroundColor: .white)
							.frame(width: 15, height: 15)
					case .research:
						ResearchView(forgroundColor: .white)
							.frame(width: 15, height: 15)
					}
					if let endDate = timer.endDate {
						Text(endDate, style: .timer)
							.font(.body)
							.offset(CGSize(width: timer.widgetXOffset, height: 0.0))
					}
				}
			}
			else {
				Image("hwm20")
			}
		}
	}
}

struct HWMTimersWigetEntryRectangularView : View {
	var entry: HWMTimerTimelineProvider.Entry
	
	var body: some View {
		ZStack {
			AccessoryWidgetBackground()
			VStack {
				ForEach(entry.timers) { timer in
					HStack() {
						switch timer.type {
						case .remoteMining:
							RemoteMiningView(forgroundColor: .white)
								.frame(width: 35, height: 35)
						case .research:
							ResearchView(forgroundColor: .white)
								.frame(width: 35, height: 35)
						}
						if timer.running, let endDate = timer.endDate {
							Text(endDate, style: .timer)
						}
						else {
							Text("\(timer.title)")
						}
						Spacer()
					}
					
				}
			}
			.foregroundColor(.white)
		}
	}
}

struct HWMTimersWigetEntryInlineView : View {
	var entry: HWMTimerTimelineProvider.Entry
	
	var body: some View {
		ZStack {
			if let timer = entry.firstRunningTimer {
				if let endDate = timer.endDate {
					Text(endDate, style: .timer)
				}
			}
			else {
				Text("HWM Timers")
			}

		}
	}
}

struct HWMTimersWigetEntryCornerView : View {
	var entry: HWMTimerTimelineProvider.Entry
	
	var body: some View {
		ZStack {
			AccessoryWidgetBackground()
			if let timer = entry.firstRunningTimer {
			switch timer.type {
				case .remoteMining:
					RemoteMiningView(forgroundColor: .white)
						.frame(width: 25, height: 25)
				case .research:
					ResearchView(forgroundColor: .white)
						.frame(width: 25, height: 25)
				}
	
			}
			else {
				Text("HWM Timers")
			}
			
		}
		.widgetLabel {
			if let timer = entry.firstRunningTimer {
				if let endDate = timer.endDate {
					Text(endDate, style: .timer)
				}
			}
		}
	}
}

@main
struct HWMTimersWatchWidgetExtension: Widget {
	let kind: String = StatusTimerWidget
	
	var body: some WidgetConfiguration {
		AppIntentConfiguration(kind: kind, intent: TimersWidgetConfigurationIntent.self, provider: HWMTimerTimelineProvider()) { entry in
			HWMTimersWatchWidgetEntryView(entry: entry)
				.containerBackground(.fill.tertiary, for: .widget)
		}
		.supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryCorner, .accessoryInline])
		.configurationDisplayName("Homeworld Mobile Timers")
		.description("Shows the current status of timers")
	}
}

extension TimersWidgetConfigurationIntent {
	fileprivate static var smiley: TimersWidgetConfigurationIntent {
		let intent = TimersWidgetConfigurationIntent()
		return intent
	}
	
	fileprivate static var starEyes: TimersWidgetConfigurationIntent {
		let intent = TimersWidgetConfigurationIntent()
		return intent
	}
}

let timerRemoteMining = AGHomeworldMobileTimer(title: "Remote Mining", running: false, duration:[.hr4, .hr8], type: .remoteMining, percentReduction: 0)
let timerResearch = AGHomeworldMobileTimer(title: "Research", running: true, duration: [.hr4, .hr8], type: .research)

#Preview(as: .accessoryCircular) {
	HWMTimersWatchWidgetExtension()
} timeline: {
	TimersEntry(date: .now, timers: [timerRemoteMining, timerResearch], configuration: .smiley)
}

#Preview(as: .accessoryInline) {
	HWMTimersWatchWidgetExtension()
} timeline: {
	TimersEntry(date: .now, timers: [timerRemoteMining, timerResearch], configuration: .smiley)
}

#Preview(as: .accessoryCorner) {
	HWMTimersWatchWidgetExtension()
} timeline: {
	TimersEntry(date: .now, timers: [timerRemoteMining, timerResearch], configuration: .smiley)
}

#Preview(as: .accessoryRectangular) {
	HWMTimersWatchWidgetExtension()
} timeline: {
	TimersEntry(date: .now, timers: [timerRemoteMining, timerResearch], configuration: .smiley)
}
