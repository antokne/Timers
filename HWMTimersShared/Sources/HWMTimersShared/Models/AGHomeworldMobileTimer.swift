//
//  AGHomeworldMobileTimer.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 9/10/23.
//

import Foundation
import UserNotifications

public enum AGHomeworldMobileTimerType: Int, Codable {
	case remoteMining = 0
	case research = 1
}

public enum AGHomeworldMobileTimerDuration: CaseIterable, Identifiable, Codable {
	public var id: Self { self }
	case hr4
	case hr8
	
	public var name: String {
		switch self {
		case .hr4:
			return "4hrs"
		case .hr8:
			return "8hrs"
		}
	}
	
	var duration: TimeInterval {
		switch self {
		case .hr4:
			return 4 * 60 * 60
		case .hr8:
			return 8 * 60 * 60
		}
	}
}

public struct AGHomeworldMobileTimer: Codable, Identifiable {
	public var id: String {
		title
	}	
	public private(set) var title: String
	public private(set) var running: Bool = false
	var duration: [AGHomeworldMobileTimerDuration]
	public var selectedDuration: AGHomeworldMobileTimerDuration = .hr4
	var startDate: Date?
	public private(set) var formatedDurationLeft: String = ""
	public private(set) var type: AGHomeworldMobileTimerType
	var percentReduction: Int
	
	public init(title: String, running: Bool, duration: [AGHomeworldMobileTimerDuration], type: AGHomeworldMobileTimerType, percentReduction: Int = 0) {
		self.title = title
		self.running = running
		self.duration = duration
		self.type = type
		self.percentReduction = percentReduction
	}
	
	mutating public func startTimer(with percentReduction: Int, selectedDuration: AGHomeworldMobileTimerDuration) {
		self.selectedDuration = selectedDuration
		self.percentReduction = percentReduction
		let date = Date()
		startDate = date
		updateDurationLeft()
		running = true
		configureNotification(startDate: date)
	}
	
	mutating public func stopTimer() {
		running = false
		startDate = nil
		updateDurationLeft()
		removeNotification()
	}
	
	mutating public func timerAction() {
		
		updateDurationLeft()
//		print(formatedDurationLeft)
		
		let remaining = durationRemaining()
//		print(remaining)
		
		if remaining <= 0 {
			
			print("Completed!")
			
			running = false
		}
	}
	
	var adjustedDuration: Double {
		selectedDuration.duration - selectedDuration.duration * Double(percentReduction) / 100.0
	}
	
	func durationRemaining() -> TimeInterval {
		guard let startDate else {
			return 0
		}
		
		return round(adjustedDuration - Date().timeIntervalSince(startDate))
	}
	
	mutating func updateDurationLeft() {
		let interval = durationRemaining()
		formatedDurationLeft = interval.stringHoursMinutes()
	}
	
	func configureNotification(startDate: Date) {
		let content = UNMutableNotificationContent()
		content.title = title
		content.body = "has completed!"
		content.sound = .default
		content.userInfo = ["StartDate": startDate]
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: adjustedDuration, repeats: false)
		
		let request = UNNotificationRequest(identifier: notificationId,
											content: content,
											trigger: trigger)
		
		let notificationCenter = UNUserNotificationCenter.current()
		notificationCenter.add(request) { (error) in
			if error != nil {
				print("no it failed! \(error?.localizedDescription ?? "")")
			}
		}
		
		Task {
			await print(notificationCenter.pendingNotificationRequests())
		}
	}
	
	func removeNotification() {
		
		let notificationCenter = UNUserNotificationCenter.current()
		notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationId])
	}
	
	public var notificationId: String {
		"notification" + title
	}
	
	mutating public func configureTimer(with notificationRequest: UNNotificationRequest, with percentReduction: Int) {
		
		self.percentReduction = percentReduction
		
		// make sure it is the type of trigger we want.
		guard let notificationStartDate = notificationRequest.content.userInfo["StartDate"] as? Date else {
			return
		}
		
		let durationRemaining = adjustedDuration - Date().timeIntervalSince(notificationStartDate)
		if durationRemaining > 0 {
			running = true
			startDate = notificationStartDate
			updateDurationLeft()
			return
		}
	}
	
}

public extension AGHomeworldMobileTimer {
	
	func asData() -> Data? {
		guard let data = try? JSONEncoder().encode(self) else {
			return nil
		}
		return data
	}
	
	static func timer(from data: Data) throws -> AGHomeworldMobileTimer {
		return try JSONDecoder().decode(Self.self, from: data)
	}
}


extension AGHomeworldMobileTimer: Equatable {
	public static func ==(lhs: AGHomeworldMobileTimer, rhs: AGHomeworldMobileTimer) -> Bool {
		lhs.id == rhs.id
	}
}

extension TimeInterval {
	
	func stringHoursMinutes() -> String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.hour, .minute, .second]
		return formatter.string(from: self) ?? ""
	}
}
