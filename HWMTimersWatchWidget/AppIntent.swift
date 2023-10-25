//
//  AppIntent.swift
//  HWMTimersWatchWidgetExtension
//
//  Created by Ant Gardiner on 17/10/23.
//

import WidgetKit
import AppIntents

struct TimersWidgetConfigurationIntent: WidgetConfigurationIntent {
	static var title: LocalizedStringResource = "Timers"
	static var description = IntentDescription("Homeworld Mobile Timers.")
}
