//
//  AGAssignment.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 29/08/23.
//

import Foundation
import SwiftUI

public class AGAssignmentViewModel: ObservableObject {
	
	@Published var assignments: [AGHomeworldMobileEventTimer] = []
	
	var timerService: TimerNotificationService
	
	var timerEvents = AGEventTimers()
	
	@Published var timers: [AGHomeworldMobileTimer] = []
	@AppStorage(SettingsResearchPercentBonusKey) var researchPercentBonus: Int = 0

	
	init(timerService: TimerNotificationService) {

		self.timerService = timerService

		Task {
			do {
				try await timerEvents.loadTimers()
				assignments = timerEvents.timers
			}
			catch {
				print(error)

			}
			if timerEvents.timers.count == 0 {
				timerEvents.timers = timerEvents.defaultTimers
			}
			
			let notificationRequests = await timerService.getCurrentPendingNotifications()
			
			for request in notificationRequests {
				
				if let timer = timerEvents.timers.first(where: { $0.notificationIdentifier == request.identifier }) {
					
					if let index = timerEvents.timers.firstIndex(of: timer) {
						timerEvents.timers[index].enabled = true
					}
					
				}
				
			}
			
			print(notificationRequests)
			
			Task { @MainActor in
				self.assignments = timerEvents.timers
			}
		}
		
		timers.append(AGHomeworldMobileTimer(title: "Remote Mining", running: false, duration: 4 * 60 * 60, type: .remoteMining, percentReduction: researchPercentBonus))
		timers.append(AGHomeworldMobileTimer(title: "Research", running: false, duration: 4 * 60 * 60, type: .research))
		
	}
	
}
