//
//  WidgetSyncManager.swift
//  
//
//  Created by Ant Gardiner on 12/10/23.
//

import Foundation
import SwiftUI
import WidgetKit
import OSLog
import AppIntents

public let StatusTimerWidget = "com.antokne.HWMTimers.TimerStatusWidget"

public class WidgetSyncManager {
	
	private let logger = Logger(subsystem: "HWMTimers", category: "WidgetSyncManager")

	public static let timersURL = HWMTimersAppGroup.timers.containerURL.appendingPathComponent("timers.json", conformingTo: .json)
	
	public init() {
		
	}
	
	public static func reloadTimerWidget() {

		
		// Call reload
		WidgetCenter.shared.reloadAllTimelines()
	}
	
	

}


//@available(watchOS 10.0, *)
//@available(iOS 17.0, *)
//public struct TimersWidgetConfigurationIntent: WidgetConfigurationIntent {
//	public static var title: LocalizedStringResource = "Timers"
//	public static var description = IntentDescription("Homeworld Mobile Timers.")
//	
//	public init() {
//		
//	}
//}
