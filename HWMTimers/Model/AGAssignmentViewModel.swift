//
//  AGAssignment.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 29/08/23.
//

import Foundation
import SwiftUI
import HWMTimersShared

public class AGAssignmentViewModel: ObservableObject {
	
	@Published var assignments: [AGHomeworldMobileEvent] = []
	
	var timerService: TimerNotificationService
	
	var eventTimers = AGEventTimers()
	
	@Published var timers: [AGHomeworldMobileTimer] = []
	@AppStorage(SettingsProcessSpeedKey) var researchProcessSpeed: Int = 100

	init(timerService: TimerNotificationService) {

		self.timerService = timerService

		Task {
			do {
				try await eventTimers.loadEvents()
				updateAssignments(eventTimers.events)
			}
			catch {
				print(error)
			}
			
			let notificationRequests = await timerService.getCurrentPendingNotifications()
			
			for request in notificationRequests {
				
				if let timer = eventTimers.events.first(where: { $0.notificationIdentifier == request.identifier }) {
					
					if let index = eventTimers.events.firstIndex(of: timer) {
						eventTimers.events[index].enabled = true
					}
					
				}
				
			}
			
			print(notificationRequests)
			
			updateAssignments(eventTimers.events)
		}
		
		timers.append(AGHomeworldMobileTimer(title: "Remote Mining", running: false, duration: [.hr4, .hr8], type: .remoteMining, percentReduction: 100 - researchProcessSpeed))
		timers.append(AGHomeworldMobileTimer(title: "Research", running: false, duration: [.hr4, .hr8], type: .research))
		
	}
	
	func updateAssignments(_ assignments: [AGHomeworldMobileEvent]) {
		Task { @MainActor in
			self.assignments = assignments
		}
	}
	
}
