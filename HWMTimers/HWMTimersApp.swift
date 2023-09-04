//
//  HWMTimersApp.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 28/08/23.
//

import SwiftUI

@main
struct HWMTimersApp: App {
	
	@StateObject var timerNotificationService = TimerNotificationService()
	
	var body: some Scene {
		WindowGroup {
			ContentView(assignmentViewModel: AGAssignmentViewModel(timerService: timerNotificationService))
				.environmentObject(timerNotificationService)
		}
	}
	
}
