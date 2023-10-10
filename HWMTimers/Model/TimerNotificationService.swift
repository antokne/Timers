//
//  TimerNotificationService.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 31/08/23.
//

import Foundation
import UserNotifications
import NiceNotifications

class TimerNotificationService: NSObject, ObservableObject {
	
	override init() {
		super.init()
		setNotificationDelegate()
	}
	
	func update(timer: AGHomeworldMobileEventTimer) {
		if timer.enabled {
			setNotification(timer: timer)
		}
		else {
			removeNotification(timer: timer)
		}
	}
	
	func receivedNotification(info: [AnyHashable : Any]) {
		
		// lookup the timer using this info

		// If it does not exist or if disabled then remove it if repeating.
		
		
	}
	
	func setNotificationDelegate() {
		UNUserNotificationCenter.current().delegate = self
	}
	
	private func setNotification(timer: AGHomeworldMobileEventTimer) {
		
		let triggers = timer.type.notificationTriggers(repeats: timer.repeats)
		
		scheduleNotification(title: timer.name,
							 message: timer.type.message,
							 trigger: triggers.start,
							 id: timer.notificationIdentifier)
		
		if let endTrigger = triggers.end {
			scheduleNotification(title: timer.name,
								 message: "Has completed.",
								 trigger: endTrigger,
								 id: timer.notificationIdentifier)
		}
	}
	
	private func removeNotification(timer: AGHomeworldMobileEventTimer) {
		LocalNotifications.Env.removePendingNotificationRequests([timer.notificationIdentifier])
	}
	

	private func scheduleNotification(title: String,
								  message: String,
								  trigger: UNNotificationTrigger,
								  sound: UNNotificationSound = .default,
								  id: String) {
		
		let content = UNMutableNotificationContent()
		content.title = title
		content.body = message
		content.sound = sound
		let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
		LocalNotifications.directSchedule(request: request, permissionStrategy: .scheduleIfSystemAllowed)
		
	}
	
	func getCurrentPendingNotifications() async -> [UNNotificationRequest] {
		await UNUserNotificationCenter.current().pendingNotificationRequests()
	}
}


extension TimerNotificationService: UNUserNotificationCenterDelegate {
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
		return [.banner, .sound]
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		receivedNotification(info: userInfo)
		completionHandler()
	}
	
}
