//
//  WatchContentViewModel.swift
//  HWMTimers Watch App
//
//  Created by Ant Gardiner on 18/09/23.
//

import Foundation
import UserNotifications
import Combine

enum AGTimerType {
	case remoteMining
	case research
}

struct AGTimer: Identifiable {
	var id = UUID()
	var title: String
	var running: Bool = false
	var duration: TimeInterval
	var startDate: Date?
	var formatedDurationLeft: String = ""
	var type: AGTimerType
	
	init(title: String, running: Bool, duration: TimeInterval, type: AGTimerType) {
		self.title = title
		self.running = running
		self.duration = duration
		self.type = type
	}
	
	
	mutating func startTimer() {
		let date = Date()
		startDate = date
		updateDurationLeft()
		running = true
		configureNotification(startDate: date)
	}
	
	mutating func stopTimer() {
		running = false
		startDate = nil
		updateDurationLeft()
		removeNotification()
	}
	
	mutating func timerAction() {
		
		updateDurationLeft()
		print(formatedDurationLeft)
		
		let remaining = durationRemaining()
		print(remaining)
		
		if remaining <= 0 {
			
			print("Completed!")
			
			running = false
		}
	}
	
	func durationRemaining() -> TimeInterval {
		guard let startDate else {
			return 0
		}
		
		return round(duration - Date().timeIntervalSince(startDate))
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
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duration, repeats: false)

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
	
	var notificationId: String {
		"notification" + title
	}
	
	mutating func configureTimer(whith notificationRequest: UNNotificationRequest) -> Bool {
		
		// make sure it is the type of trigger we want.
		guard let notificationStartDate = notificationRequest.content.userInfo["StartDate"] as? Date else {
			return false
		}

		let durationRemaining = duration - Date().timeIntervalSince(notificationStartDate)
		if durationRemaining > 0 {
			running = true
			startDate = notificationStartDate
			updateDurationLeft()
			return true
		}
		
		return false
	}
	
}

extension AGTimer: Equatable {
	static func ==(lhs: AGTimer, rhs: AGTimer) -> Bool {
		lhs.id == rhs.id
	}
}

class WatchContentViewModel : ObservableObject {
	
	
	@Published var timers: [AGTimer] = []
	
	private var timerCancellable: AnyCancellable?

	
	init() {
		timers.append(AGTimer(title: "Remote Mining", running: false, duration: 4 * 60 * 60, type: .remoteMining))
		timers.append(AGTimer(title: "Research", running: false, duration: 4 * 60 * 60, type: .research))
	}
	
	func startRemoteMiningTimer(timer: AGTimer) {
		
		createTimerPublisherIfNotCreated()
		
		var timer = timer
		timer.startTimer()
		update(timer: timer)
	}
	
	func createTimerPublisherIfNotCreated() {
		
		guard timerCancellable == nil else {
			return
		}
		
		timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
			.autoconnect()
			.sink { [weak self] timer in
				self?.timerAction()
			}
	}
	
	func cancelRemoteMiningTimer(timer: AGTimer) {
		
		var timer = timer
		timer.stopTimer()
		update(timer: timer)

		cancelUpdateTimerIfNoTimersRunning()
	}
	
	func timerAction() {
	
		for timer in timers {
			if timer.running {
				var timer = timer
				timer.timerAction()
				update(timer: timer)
			}
		}
		
		cancelUpdateTimerIfNoTimersRunning()
		
//		printTriggerFireDates()
	}

	func update(timer: AGTimer) {
		Task { @MainActor in
			if let index = timers.firstIndex(of: timer) {
				timers[index] = timer
			}
		}
	}
	
	func cancelUpdateTimerIfNoTimersRunning() {
		let running = timers.filter { $0.running }
		if running.isEmpty {
			timerCancellable = nil
		}
	}
	
	func checkCurrentNotifications() async {
		
		let requests = await getCurrentPendingNotifications()
		for notificationRequest in requests {
			
			if var timer = timers.first(where: { $0.notificationId == notificationRequest.identifier }) {
				// we have a timer notif set so start the timer.
				let running = timer.configureTimer(whith: notificationRequest)
				if running {
					createTimerPublisherIfNotCreated()
				}
				update(timer: timer)
			}
		}
		
	}
	
	func getCurrentPendingNotifications() async -> [UNNotificationRequest] {
		await UNUserNotificationCenter.current().pendingNotificationRequests()
	}
	
	func printTriggerFireDates() {
		
		Task {
			let requests = await getCurrentPendingNotifications()
			for request in requests {
				guard let trigger = request.trigger as? UNTimeIntervalNotificationTrigger else {
					continue
				}
				
				print("Next trigger date \(request.identifier) " + "\(trigger.nextTriggerDate()!)")
			}
		}
	}
}


extension TimeInterval {
	
	func stringHoursMinutes() -> String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.hour, .minute, .second]
		return formatter.string(from: self) ?? ""
	}
}
