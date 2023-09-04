//
//  AGAssignment.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 29/08/23.
//

import Foundation


//struct Assignment: Codable, Identifiable {
//	var id = UUID()
//
//	var enabled = false
//	var timer: AGTimer
//
//}

public class AGAssignmentViewModel: ObservableObject {
	
	@Published var assignments: [AGTimer] = []
	
	var timerService: TimerNotificationService
	
	var timers = AGTimers()
	
	init(timerService: TimerNotificationService) {

		self.timerService = timerService

		Task {
			do {
				try await timers.loadTimers()
				assignments = timers.timers
			}
			catch {
				print(error)

			}
			if timers.timers.count == 0 {
				timers.timers = timers.defaultTimers
			}
			
			let notificationRequests = await timerService.getCurrentPendingNotifications()
			
			for request in notificationRequests {
				
				if let timer = timers.timers.first(where: { $0.notificationIdentifier == request.identifier }) {
					
					if let index = timers.timers.firstIndex(of: timer) {
						timers.timers[index].enabled = true
					}
					
				}
				
			}
			
			print(notificationRequests)
			
			Task { @MainActor in
				self.assignments = timers.timers
			}
		}
	}

}
