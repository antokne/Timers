//
//  AGHomeworldMobileEventTimerTests.swift
//  HWMTimersTests
//
//  Created by Ant Gardiner on 29/08/23.
//

import XCTest
import DateBuilder

@testable import HWMTimers

final class AGHomeworldMobileEventTimerTests: XCTestCase {
	
	var gmtCalendar: Calendar {
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = TimeZone(identifier: "GMT") ?? calendar.timeZone
		return calendar
	}
	
	override func setUpWithError() throws {
	}
	
	override func tearDownWithError() throws {
	}
	
	func testExample() throws {
		
	}
	
	
	func testTimersDaily() throws {
		
		let timer = AGHomeworldMobileEvent(name: "Daily Market", type: AGHomeworldMobileEventType.daily(start: TimeOfDay(hour: 2, minute: 0)))
		XCTAssertEqual(timer.name, "Daily Market")
		
		let startDate = timer.type.nextStartDate()
		XCTAssertTrue(startDate.timeIntervalSinceNow.sign == .plus)
		
		
		// GMT Value
		var hour = gmtCalendar.component(.hour, from: startDate)
		XCTAssertEqual(hour, 2)
		
		
		// NZ TIME ZONE!!!
		hour = Calendar.current.component(.hour, from: startDate)
		XCTAssertEqual(hour, 15)

	}
	
	func testTimerWeekDay() throws {
		
		let timer = AGHomeworldMobileEvent(name: "Daily Rep liason",
							type: AGHomeworldMobileEventType.day(weekDay: .tuesday, start: TimeOfDay(hour: 0, minute: 0)))
		XCTAssertEqual(timer.name, "Daily Rep liason")
		
		// should always be in the future!
		let startDate = timer.type.nextStartDate()
		XCTAssertTrue(startDate.timeIntervalSinceNow.sign == .plus)
		
		
		// GMT Value
		let hour = gmtCalendar.component(.hour, from: startDate)
		XCTAssertEqual(hour, 0)
		
		let day = gmtCalendar.component(.weekday, from: startDate)
		XCTAssertEqual(day, WeekDay.tuesday.rawValue)
	}
	
	func testTimerWeekly() throws {
		
		let timer = AGHomeworldMobileEvent(name: "Weekly Market",
							type: AGHomeworldMobileEventType.weekly(weekDay: .monday,
												   start: TimeOfDay(hour: 2, minute: 0)))
		XCTAssertEqual(timer.name, "Weekly Market")
		
		// should always be in the future!
		let startDate = timer.type.nextStartDate()
		XCTAssertTrue(startDate.timeIntervalSinceNow.sign == .plus)
		
		
		// GMT Value
		let hour = gmtCalendar.component(.hour, from: startDate)
		XCTAssertEqual(hour, 2)
		
		let day = gmtCalendar.component(.weekday, from: startDate)
		XCTAssertEqual(day, WeekDay.monday.rawValue)
	}
	
	
	func testTimerEvent() throws {
		
		let timer = AGHomeworldMobileEvent(name: "Weekend Event",
							type: AGHomeworldMobileEventType.event(weekDay: .friday,
												  start: TimeOfDay(hour: 11, minute: 0),
												  durationDays: 3))
		XCTAssertEqual(timer.name, "Weekend Event")

		// should always be in the future!
		let startDate = timer.type.nextStartDate()
		XCTAssertTrue(startDate.timeIntervalSinceNow.sign == .plus)
		
		let endDate = timer.type.nextEndDate()
		XCTAssertTrue(startDate.timeIntervalSinceNow.sign == .plus)
		
		XCTAssertEqual(startDate.advanced(by: 3 * 60 * 60 * 24 ), endDate)

		let hour = gmtCalendar.component(.hour, from: startDate)
		XCTAssertEqual(hour, 11)
		
		let day = gmtCalendar.component(.weekday, from: startDate)
		XCTAssertEqual(day, WeekDay.friday.rawValue)
	}
	
	func testSerialize() async throws {
		
		let timers = AGEventTimers()
		let currentTimers = timers.timers
		
		print(timers.filePath)

		XCTAssertFalse(FileManager.default.fileExists(atPath: timers.filePath.path(percentEncoded: false)))
		
		try await timers.saveTimers()
		
		XCTAssertTrue(FileManager.default.fileExists(atPath: timers.filePath.path(percentEncoded: false)))
		
		let loadedTimers = timers.timers
		
		XCTAssertEqual(currentTimers, loadedTimers)
		
		try FileManager.default.removeItem(at: timers.filePath)
	}
}
