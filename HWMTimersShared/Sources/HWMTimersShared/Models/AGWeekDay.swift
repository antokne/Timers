//
//  WeekDay.swift
//
//
//  Created by Ant Gardiner on 12/10/23.
//

import Foundation
import DateBuilder

public enum AGWeekDay: Int, Codable {
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
	
	func addDays(days: Int) -> AGWeekDay {
		let start = self.rawValue - 1 // index from 0
		let endDay = start + days
		let day = endDay % 7 + 1
		return AGWeekDay(rawValue: day) ?? .monday
	}
}
