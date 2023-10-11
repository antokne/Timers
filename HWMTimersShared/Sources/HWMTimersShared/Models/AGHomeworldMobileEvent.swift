//
//  AGHomeworldMobileEvent.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 28/08/23.
//

import Foundation
import DateBuilder

public class AGHomeworldMobileEvent: Codable, Identifiable {
	
	// what type of time, e.g. daily, weekly, start - end etc.
	
	public private(set) var name: String
	
	public var enabled: Bool = false
	
	public private(set) var repeats: Bool = true
	
	public private(set) var type: AGHomeworldMobileEventType
	
	// Daily market reset every day at 0200 GMT
	// Weekly Market reset weekly Monday 0200 GMT
	
	// Weekend event start Friday 1100GMT for 3 days.
	//	needs a start notif and an end notif.
	
	// liason rep event
	// Monday 0000 GMT for one day.
	// Tuesday 0000 GMT for one day.
	// Wednesday 0000 GMT for one day.
	
	// Liason reset
	// everyday 0000 gmt
	
	
	public init(name: String, type: AGHomeworldMobileEventType) {
		self.name = name
		self.type = type
	}
	
	public var notificationIdentifier: String {
		"hwm-timer-notification-" + name
	}
}

extension AGHomeworldMobileEvent: Equatable {
	
	public static func == (lhs: AGHomeworldMobileEvent, rhs: AGHomeworldMobileEvent) -> Bool {
		lhs.name == rhs.name && lhs.type == rhs.type
	}
	
	
}


public class AGEventTimers: Codable {

	static var fileName = "homeworld-mobile-timers.json"
	
	static var dailyMarket = AGHomeworldMobileEvent(name: "Daily Market",
									 type: AGHomeworldMobileEventType.daily(start: TimeOfDay(hour: 2, minute: 0)))

	static var dailyAssignments = AGHomeworldMobileEvent(name: "Daily Assignments",
									  type: AGHomeworldMobileEventType.daily(start: TimeOfDay(hour: 3, minute: 0)))
	
	static var dailyLiaison = AGHomeworldMobileEvent(name: "Daily Liaison",
									  type: AGHomeworldMobileEventType.daily(start: TimeOfDay(hour: 0, minute: 0)))

	static var dailyClan = AGHomeworldMobileEvent(name: "Daily Clan Assignments",
								   type: AGHomeworldMobileEventType.daily(start: TimeOfDay(hour: 0, minute: 0)))
	
	static var communityThursday = AGHomeworldMobileEvent(name: "Community Thursday",
										   type: AGHomeworldMobileEventType.weekly(weekDay: .thursday,
																  start: TimeOfDay(hour: 15, minute: 0)))
	
	
	static var weeklyMarket = AGHomeworldMobileEvent(name: "Weekly Market",
									  type: AGHomeworldMobileEventType.weekly(weekDay: .monday,
															 start: TimeOfDay(hour: 2, minute: 0)))
	
	static var weeklyAssignments = AGHomeworldMobileEvent(name: "Weekly Assignments",
									  type: AGHomeworldMobileEventType.weekly(weekDay: .sunday,
															 start: TimeOfDay(hour: 3, minute: 0)))
	
	static var weekendEvent = AGHomeworldMobileEvent(name: "Weekend Event",
									  type: AGHomeworldMobileEventType.event(weekDay: .friday,
															start: TimeOfDay(hour: 11, minute: 0),
															durationDays: 3))
	
	static var iyatequaLiaison = AGHomeworldMobileEvent(name: "Iyatequa Liaison +XP",
									  type: AGHomeworldMobileEventType.day(weekDay: .monday, start: TimeOfDay(hour: 0, minute: 0)))

	static var tanochLiaison = AGHomeworldMobileEvent(name: "Tanoch Liaison +XP",
									  type: AGHomeworldMobileEventType.day(weekDay: .tuesday, start: TimeOfDay(hour: 0, minute: 0)))

	static var yaotLiaison = AGHomeworldMobileEvent(name: "Yaot Liaison +XP",
									  type: AGHomeworldMobileEventType.day(weekDay: .wednesday, start: TimeOfDay(hour: 0, minute: 0)))
	
	static var amassariLiaison = AGHomeworldMobileEvent(name: "Amassari Liaison +XP",
									type: AGHomeworldMobileEventType.day(weekDay: .thursday, start: TimeOfDay(hour: 0, minute: 0)))
	
	var defaultTimers = [dailyMarket,
						 dailyAssignments,
						 dailyLiaison,
						 dailyClan,
						 communityThursday,
						 weeklyMarket,
						 weeklyAssignments,
						 weekendEvent,
						 iyatequaLiaison,
						 tanochLiaison,
						 yaotLiaison,
						 amassariLiaison]

	
	public private(set) var events: [AGHomeworldMobileEvent] = []
	
	var filePath: URL {
		URL
			.documentsDirectory
			.appendingPathComponent(AGEventTimers.fileName, conformingTo: .json)
	}
	
	func saveEvents() async throws {
	
		let encoder = JSONEncoder()
		let data = try encoder.encode(events)
		
		
		try data.write(to: filePath, options: [.atomic])
	}
	
	public func loadEvents() async throws {
		
		do {
			let data = try Data(contentsOf: filePath)
			let decoder = JSONDecoder()
			events = try decoder.decode([AGHomeworldMobileEvent].self, from: data)
		}
		catch {
			print("failed to load file \(error)")
		}
			
		if events.count == 0 {
			events = defaultTimers
		}
	}
	
	func deleteEventsFile() throws {
		try FileManager.default.removeItem(at: filePath)
	}
	
	public init() {
	}
}
