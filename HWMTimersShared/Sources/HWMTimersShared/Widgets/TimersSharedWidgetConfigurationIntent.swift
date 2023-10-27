//
//  TimersSharedWidgetConfigurationIntent.swift
//
//
//  Created by Ant Gardiner on 27/10/23.
//

import Foundation
import AppIntents

// This does not work
#if false

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
public struct SharedWidgetConfigurationIntents: AppIntentsPackage {}

@available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
public struct TimersSharedWidgetConfigurationIntent: AppIntentsPackage, WidgetConfigurationIntent {
	public static var title: LocalizedStringResource = "Timers"
	public static var description = IntentDescription("Homeworld Mobile Timers.")
	
	public init() {
		
	}
}

#endif
