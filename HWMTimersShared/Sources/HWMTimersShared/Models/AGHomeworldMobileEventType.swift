//
//  AGHomeworldMobileEventType.swift
//
//
//  Created by Ant Gardiner on 12/10/23.
//

import Foundation
import UserNotifications
import DateBuilder

private var dateFomatter = DateFormatter()

public enum AGHomeworldMobileEventType: Codable {
	case daily(start: TimeOfDay)
	case day(weekDay: AGWeekDay, start: TimeOfDay)
	case weekly(weekDay: AGWeekDay, start: TimeOfDay)
	case event(weekDay: AGWeekDay, start: TimeOfDay, durationDays: Int)
	
	func formatTime() -> String {
		dateFomatter.dateStyle = .none
		dateFomatter.timeStyle = .short
		//		dateFomatter.timeZone = TimerType.gmtCalendar.timeZone
		return dateFomatter.string(from: nextStartDate())
	}
	
	public var name: String {
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
	
	public var descrpition: String {
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
	
	public var message: String {
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
	
	
	public func nextStartDate(calendar: Calendar = AGHomeworldMobileEventType.gmtCalendar) -> Date {
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
	
	public func nextEndDate(calendar: Calendar = AGHomeworldMobileEventType.gmtCalendar) -> Date? {
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
	
	private func nextValidWeekDayStartDate(weekDay: AGWeekDay, start: TimeOfDay) -> Date {
		var startDate = ThisWeek().weekday(weekDay.day).at(start).date()
		if startDate.timeIntervalSinceNow.sign == .minus {
			startDate = NextWeek().weekday(weekDay.day).at(start).date()
		}
		return startDate
	}
	
	private func nextValidEndDate(weekDay: AGWeekDay, start: TimeOfDay, adding days: Int) -> Date {
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
			date.calendar = AGHomeworldMobileEventType.gmtCalendar
			date.hour = start.hour
			date.minute = start.minute
			return (UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats), nil)
		case .day(let weekDay, let start),
				.weekly(let weekDay, let start):
			var date = DateComponents()
			date.calendar = AGHomeworldMobileEventType.gmtCalendar
			date.hour = start.hour
			date.minute = start.minute
			date.weekday = weekDay.rawValue
			return (UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats), nil)
		case .event(let weekDay, let start, let durationDays):
			var startDate = DateComponents()
			startDate.calendar = AGHomeworldMobileEventType.gmtCalendar
			startDate.hour = start.hour
			startDate.minute = start.minute
			startDate.weekday = weekDay.rawValue
			var endDate = DateComponents()
			endDate.calendar = AGHomeworldMobileEventType.gmtCalendar
			endDate.hour = start.hour
			endDate.minute = start.minute
			endDate.weekday = weekDay.addDays(days: durationDays).rawValue
			
			return (UNCalendarNotificationTrigger(dateMatching: startDate, repeats: repeats),
					UNCalendarNotificationTrigger(dateMatching: endDate, repeats: repeats))
			
		}
	}
}

extension AGHomeworldMobileEventType: Equatable {
	
}

extension TimeOfDay {
	var description: String {
		String(format: "%02d%02d", hour, minute)
	}
}
