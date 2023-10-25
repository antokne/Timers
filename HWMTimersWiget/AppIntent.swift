//
//  AppIntent.swift
//  HWMTimersWiget
//
//  Created by Ant Gardiner on 12/10/23.
//

import WidgetKit
import AppIntents

struct TimersWidgetConfigurationIntent: WidgetConfigurationIntent {
	static var title: LocalizedStringResource = "Timers"
	static var description = IntentDescription("Homeworld Mobile Timers.")
}
