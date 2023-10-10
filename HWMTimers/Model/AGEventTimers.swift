//
//  AGTimers.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 28/08/23.
//

import Foundation
import UserNotifications
import DateBuilder

extension TimeOfDay {
	var description: String {
		String(format: "%02d%02d", hour, minute)
	}
}

public enum WeekDay: Int, Codable {
	case sunday = 1
	case monday = 2
	case tuesday = 3
	case wednesday = 4
	case thursday = 5
	case friday = 6
	case saturday = 7
	
	var name: String {
		switch self {
		case .sunday:
			return "Sunday"
		case .monday:
			return "Monday"
		case .tuesday:
			return "Tuesday"
		case .wednesday:
			return "Wednesday"
		case .thursday:
			return "Thursday"
		case .friday:
			return "Friday"
		case .saturday:
			return "Saturday"
		}
	}
	
	var day: DateBuilder.Week.GregorianWeekday {
		switch self {
		case .sunday:
			return DateBuilder.Week.GregorianWeekday.sunday
		case .monday:
			return DateBuilder.Week.GregorianWeekday.monday
		case .tuesday:
			return DateBuilder.Week.GregorianWeekday.tuesday
		case .wednesday:
			return DateBuilder.Week.GregorianWeekday.wednesday
		case .thursday:
			return DateBuilder.Week.GregorianWeekday.thursday
		case .friday:
			return DateBuilder.Week.GregorianWeekday.friday
		case .saturday:
			return DateBuilder.Week.GregorianWeekday.saturday
		}
	}
	
	func addDays(days: Int) -> WeekDay {
		let start = self.rawValue - 1 // index from 0
		let endDay = start + days
		let day = endDay % 7 + 1
		return WeekDay(rawValue: day) ?? .monday
	}
}

private var dateFomatter = DateFormatter()

public enum HomeworldMobileEventType: Codable {
	case daily(start: TimeOfDay)
	case day(weekDay: WeekDay, start: TimeOfDay)
	case weekly(weekDay: WeekDay, start: TimeOfDay)
	case event(weekDay: WeekDay, start: TimeOfDay, durationDays: Int)
	
	func formatTime() -> String {
		dateFomatter.dateStyle = .none
		dateFomatter.timeStyle = .short
//		dateFomatter.timeZone = TimerType.gmtCalendar.timeZone
		return dateFomatter.string(from: nextStartDate())
	}
	
	var name: String {
		switch self {
		case .daily(_):
			return "Daily"
		case .day(_, _):
			return "Day"
		case .weekly(_, _):
			return "Weekly"
		case .event(_, _, _):
			return "Event"
		}
	}
	
	var descrpition: String {
		switch self {
		case .daily(_):
			return "Resets at " + formatTime()
		case .day(let weekDay, _):
			return weekDay.name + " at "  + formatTime()
		case .weekly(let weekDay, _):
			return "On " + weekDay.name + " at "  + formatTime()
		case .event(let weekDay, _, let durationDays):
			return weekDay.name + " at " + formatTime() + " for \(durationDays) days."
		}
	}
	
	var message: String {
		switch self {
		case .daily(_):
			return "Has reset."
		case .day(_, _):
			return "Has reset."
		case .weekly(_, _):
			return "Has reset."
		case .event(_, _, _):
			return "Has started."
		}
	}
	

	public func nextStartDate(calendar: Calendar = HomeworldMobileEventType.gmtCalendar) -> Date {
		var startDate: Date = Date()
		DateBuilder.withCalendar(calendar) {
			switch self {
			case .daily(let start):
				startDate = nextValidDailyStartDate(start: start)
			case .day(let weekDay, let start):
				startDate = nextValidWeekDayStartDate(weekDay: weekDay, start: start)
			case .weekly(let weekDay, let start):
				startDate = nextValidWeekDayStartDate(weekDay: weekDay, start: start)
			case .event(let weekDay, let start, _):
				startDate = nextValidWeekDayStartDate(weekDay: weekDay, start: start)
			}
		}
		return startDate
	}
	
	public func nextEndDate(calendar: Calendar = HomeworldMobileEventType.gmtCalendar) -> Date? {
		DateBuilder.withCalendar(calendar) {
			switch self {
			case .daily(_),
					.day(_, _),
					.weekly(_, _):
				return nil
			case .event(let weekDay, let start, let durationDays):
				return nextValidEndDate(weekDay: weekDay, start: start, adding: durationDays)
			}
		}
	}
	
	public static var gmtCalendar: Calendar {
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = TimeZone(identifier: "GMT") ?? calendar.timeZone
		
		return calendar
	}
	
	private func nextValidDailyStartDate(start: TimeOfDay) -> Date {
		var startDate = Today().at(start).date()
		if startDate.timeIntervalSinceNow.sign == .minus {
			startDate = Tomorrow().at(start).date()
		}
		return startDate
	}
	
	private func nextValidWeekDayStartDate(weekDay: WeekDay, start: TimeOfDay) -> Date {
		var startDate = ThisWeek().weekday(weekDay.day).at(start).date()
		if startDate.timeIntervalSinceNow.sign == .minus {
			startDate = NextWeek().weekday(weekDay.day).at(start).date()
		}
		return startDate
	}
	
	private func nextValidEndDate(weekDay: WeekDay, start: TimeOfDay, adding days: Int) -> Date {
		var startDate = ThisWeek().weekday(weekDay.day).at(start)
		if startDate.date().timeIntervalSinceNow.sign == .minus {
			startDate = NextWeek().weekday(weekDay.day).at(start)
		}
		return startDate.addingDays(days).date()
	}
	
	public typealias Triggers = (start: UNNotificationTrigger, end: UNNotificationTrigger?)
	
	public func notificationTriggers(repeats: Bool) -> Triggers {
		switch self {
		case .daily(let start):
			var date = DateComponents()
			date.calendar = HomeworldMobileEventType.gmtCalendar
			date.hour = start.hour
			date.minute = start.minute
			return (UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats), nil)
		case .day(let weekDay, let start),
				.weekly(let weekDay, let start):
			var date = DateComponents()
			date.calendar = HomeworldMobileEventType.gmtCalendar
			date.hour = start.hour
			date.minute = start.minute
			date.weekday = weekDay.rawValue
			return (UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats), nil)
		case .event(let weekDay, let start, let durationDays):
			var startDate = DateComponents()
			startDate.calendar = HomeworldMobileEventType.gmtCalendar
			startDate.hour = start.hour
			startDate.minute = start.minute
			startDate.weekday = weekDay.rawValue
			var endDate = DateComponents()
			endDate.calendar = HomeworldMobileEventType.gmtCalendar
			endDate.hour = start.hour
			endDate.minute = start.minute
			endDate.weekday = weekDay.addDays(days: durationDays).rawValue
			
			return (UNCalendarNotificationTrigger(dateMatching: startDate, repeats: repeats),
					UNCalendarNotificationTrigger(dateMatching: endDate, repeats: repeats))
			
		}
	}
}

extension HomeworldMobileEventType: Equatable {
	
}

public class AGHomeworldMobileEventTimer: Codable, Identifiable {
	
	// what type of time, e.g. daily, weekly, start - end etc.
	
	var name: String
	
	var enabled: Bool = false
	
	var repeats: Bool = true
	
	var type: HomeworldMobileEventType
	
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
	
	
	public init(name: String, type: HomeworldMobileEventType) {
		self.name = name
		self.type = type
	}
	
	var notificationIdentifier: String {
		"hwm-timer-notification-" + name
	}
}

extension AGHomeworldMobileEventTimer: Equatable {
	
	public static func == (lhs: AGHomeworldMobileEventTimer, rhs: AGHomeworldMobileEventTimer) -> Bool {
		lhs.name == rhs.name && lhs.type == rhs.type
	}
	
	
}


public class AGEventTimers: Codable {

	static var fileName = "homeworld-mobile-timers.json"
	
	static var dailyMarket = AGHomeworldMobileEventTimer(name: "Daily Market",
									 type: HomeworldMobileEventType.daily(start: TimeOfDay(hour: 2, minute: 0)))

	static var dailyAssignments = AGHomeworldMobileEventTimer(name: "Daily Assignments",
									  type: HomeworldMobileEventType.daily(start: TimeOfDay(hour: 3, minute: 0)))
	
	static var dailyLiaison = AGHomeworldMobileEventTimer(name: "Daily Liaison",
									  type: HomeworldMobileEventType.daily(start: TimeOfDay(hour: 0, minute: 0)))

	static var dailyClan = AGHomeworldMobileEventTimer(name: "Daily Clan Assignments",
								   type: HomeworldMobileEventType.daily(start: TimeOfDay(hour: 0, minute: 0)))
	
	static var communityThursday = AGHomeworldMobileEventTimer(name: "Community Thursday",
										   type: HomeworldMobileEventType.weekly(weekDay: .thursday,
																  start: TimeOfDay(hour: 15, minute: 0)))
	
	
	static var weeklyMarket = AGHomeworldMobileEventTimer(name: "Weekly Market",
									  type: HomeworldMobileEventType.weekly(weekDay: .monday,
															 start: TimeOfDay(hour: 2, minute: 0)))
	
	static var weeklyAssignments = AGHomeworldMobileEventTimer(name: "Weekly Assignments",
									  type: HomeworldMobileEventType.weekly(weekDay: .sunday,
															 start: TimeOfDay(hour: 3, minute: 0)))
	
	static var weekendEvent = AGHomeworldMobileEventTimer(name: "Weekend Event",
									  type: HomeworldMobileEventType.event(weekDay: .friday,
															start: TimeOfDay(hour: 11, minute: 0),
															durationDays: 3))
	
	static var iyatequaLiaison = AGHomeworldMobileEventTimer(name: "Iyatequa Liaison +XP",
									  type: HomeworldMobileEventType.day(weekDay: .monday, start: TimeOfDay(hour: 0, minute: 0)))

	static var tanochLiaison = AGHomeworldMobileEventTimer(name: "Tanoch Liaison +XP",
									  type: HomeworldMobileEventType.day(weekDay: .tuesday, start: TimeOfDay(hour: 0, minute: 0)))

	static var yaotLiaison = AGHomeworldMobileEventTimer(name: "Yaot Liaison +XP",
									  type: HomeworldMobileEventType.day(weekDay: .wednesday, start: TimeOfDay(hour: 0, minute: 0)))
	
	static var amassariLiaison = AGHomeworldMobileEventTimer(name: "Amassari Liaison +XP",
									type: HomeworldMobileEventType.day(weekDay: .thursday, start: TimeOfDay(hour: 0, minute: 0)))
	
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

	
	var timers: [AGHomeworldMobileEventTimer] = []
	
	var filePath: URL {
		URL
			.documentsDirectory
			.appendingPathComponent(AGEventTimers.fileName, conformingTo: .json)
	}
	
	func saveTimers() async throws {
	
		let encoder = JSONEncoder()
		let data = try encoder.encode(timers)
		
		
		try data.write(to: filePath, options: [.atomic])
	}
	
	func loadTimers() async throws {
		
		let data = try Data(contentsOf: filePath)
		let decoder = JSONDecoder()
		timers = try decoder.decode([AGHomeworldMobileEventTimer].self, from: data)
		
	}
	
	func deleteTimerFile() throws {
		try FileManager.default.removeItem(at: filePath)
	}
}
