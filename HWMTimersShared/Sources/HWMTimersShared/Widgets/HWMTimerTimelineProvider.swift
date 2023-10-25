//
//  HWMTimerTimelineProvider.swift
//
//
//  Created by Ant Gardiner on 17/10/23.
//

import Foundation
import WidgetKit

//@available(watchOS 10.0, *)
//@available(iOS 17.0, *)
//public struct HWMTimerTimelineProvider: AppIntentTimelineProvider {
//	
//	public func placeholder(in context: Context) -> TimersEntry {
//		TimersEntry(date: Date(), timers: timers, configuration: TimersWidgetConfigurationIntent())
//	}
//	
//	public func snapshot(for configuration: TimersWidgetConfigurationIntent, in context: Context) async -> TimersEntry {
//		TimersEntry(date: Date(), timers: timers, configuration: configuration)
//	}
//	
//	public func timeline(for configuration: TimersWidgetConfigurationIntent, in context: Context) async -> Timeline<TimersEntry> {
//		
//		let entries: [TimersEntry] = [TimersEntry(date: Date(), timers: timers, configuration: configuration)]
//		
//		return Timeline(entries: entries, policy: .atEnd)
//	}
//	
//	private var timers: [AGHomeworldMobileTimer] {
//		do {
//			let data = try Data(contentsOf: WidgetSyncManager.timersURL)
//			let timers = try Array.loadTimers(from: data)
//			return timers
//		}
//		catch {
//			return []
//		}
//	}
//	
//	public func recommendations() -> [AppIntentRecommendation<TimersWidgetConfigurationIntent>] {
//		// Create an array with all the preconfigured widgets to show.
//		[AppIntentRecommendation(intent: TimersWidgetConfigurationIntent(), description: "HWM Timers Widget")]
//	}
//	
//	public init() {
//		
//	}
//	
//}
//
//@available(watchOS 10.0, *)
//@available(iOS 17.0, *)
//public struct TimersEntry: TimelineEntry {
//	public var date: Date
//	public let timers: [AGHomeworldMobileTimer]
//	let configuration: TimersWidgetConfigurationIntent
//	
//	public var firstRunningTimer: AGHomeworldMobileTimer? {
//		let earliestTimer = timers.min()
//		return (earliestTimer?.running ?? false) ? earliestTimer : nil
//	}
//	
//	public init(date: Date, timers: [AGHomeworldMobileTimer], configuration: TimersWidgetConfigurationIntent) {
//		self.date = date
//		self.timers = timers
//		self.configuration = configuration
//	}
//}
