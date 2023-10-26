//
//  HWMTimersWiget.swift
//  HWMTimersWiget
//
//  Created by Ant Gardiner on 12/10/23.
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
				
		let entries: [TimersEntry] = [TimersEntry(date: Date(), timers: timers, configuration: configuration)]
		
		return Timeline(entries: entries, policy: .atEnd)
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

struct HWMTimersWigetEntryView : View {
	@Environment(\.widgetFamily) var family: WidgetFamily
	var entry: HWMTimerTimelineProvider.Entry
	
	var body: some View {
		switch family {
		case .systemSmall:
			HWMTimersWigetEntrySmallView(entry: entry)
		case .accessoryRectangular:
			HWMTimersWigetEntryRectangularView(entry: entry)
		case .accessoryCircular:
			HWMTimersWigetEntryCircularView(entry: entry)
		case .systemMedium, .systemLarge, .systemExtraLarge, .accessoryCorner,.accessoryInline:
			EmptyView()
		@unknown default:
			EmptyView()
		}
	}
}

struct HWMTimersWigetEntrySmallView : View {
	var entry: HWMTimerTimelineProvider.Entry
	
	var body: some View {
		ZStack {
			AccessoryWidgetBackground()
			VStack {
				HStack() {
					Text("Timers")
					Spacer()
					Image("hwm20")
				}
				.font(.title3)
				if entry.timers.isEmpty {
					Text("No timers configured.")
				}
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
								.font(.subheadline)
						}
						Spacer()
					}

				}
			}
			.foregroundColor(.white)
		}
	}
}

struct HWMTimersWigetEntryRectangularView : View {
	var entry: HWMTimerTimelineProvider.Entry
	
	var body: some View {
		ZStack {
			AccessoryWidgetBackground()
			HStack(spacing: 0) {
				if entry.timers.isEmpty {
					Text("No timers configured.")
				}
				ForEach(entry.timers) { timer in
					VStack(alignment: .leading, spacing: 0) {
						switch timer.type {
						case .remoteMining:
							RemoteMiningView(forgroundColor: .white)
								.frame(width: 20, height: 20)
						case .research:
							ResearchView(forgroundColor: .white)
								.frame(width: 20, height: 20)
						}
						if timer.running, let endDate = timer.endDate {
							Text(endDate, style: .timer)
								.font(.subheadline)
						}
						else {
							Text("\(timer.title)")
								.font(.subheadline)
						}
					}
				}
			}
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


struct HWMTimersWiget: Widget {
	let kind: String = StatusTimerWidget
	
	var body: some WidgetConfiguration {
		AppIntentConfiguration(kind: kind, intent: TimersWidgetConfigurationIntent.self, provider: HWMTimerTimelineProvider()) { entry in
			HWMTimersWigetEntryView(entry: entry)
				.containerBackground(.black, for: .widget)
		}
		.supportedFamilies([.systemSmall, .accessoryCircular, .accessoryRectangular])
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

#Preview(as: .systemSmall) {
	HWMTimersWiget()
} timeline: {
	TimersEntry(date: .now, timers: [timerRemoteMining, timerResearch], configuration: .smiley)
}
