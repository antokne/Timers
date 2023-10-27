//
//  HWMTimerTimelineProvider.swift
//
//
//  Created by Ant Gardiner on 17/10/23.
//

import Foundation
import WidgetKit

// This does not work
#if false

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
public struct HWMTimerTimelineProvider: AppIntentTimelineProvider {
	
	public typealias Entry = TimersTimelineEntry
	public typealias Intent = TimersSharedWidgetConfigurationIntent
	
	public func placeholder(in context: Context) -> TimersTimelineEntry {
		TimersTimelineEntry(date: Date(), timers: timers)
	}
	
	public func snapshot(for configuration: TimersSharedWidgetConfigurationIntent, in context: Context) async -> TimersTimelineEntry {
		TimersTimelineEntry(date: Date(), timers: timers)
	}
	
	public func timeline(for configuration: TimersSharedWidgetConfigurationIntent, in context: Context) async -> Timeline<TimersTimelineEntry> {
		let entries: [TimersTimelineEntry] = [TimersTimelineEntry(date: Date(), timers: timers)]
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
	
	public func recommendations() -> [AppIntentRecommendation<TimersSharedWidgetConfigurationIntent>] {
		// Create an array with all the preconfigured widgets to show.
		[AppIntentRecommendation(intent: TimersSharedWidgetConfigurationIntent(), description: "HWM Timers Widget")]
	}
	
	public init() {
	}
	
}
#endif

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
public struct TimersTimelineEntry: TimelineEntry {
	public var date: Date
	public let timers: [AGHomeworldMobileTimer]
	
	/// Retrieves the timer that will complete first.
	public var firstRunningTimer: AGHomeworldMobileTimer? {
		let earliestTimer = timers.min()
		return (earliestTimer?.running ?? false) ? earliestTimer : nil
	}
	
	public init(date: Date, timers: [AGHomeworldMobileTimer]) {
		self.date = date
		self.timers = timers
	}
}
