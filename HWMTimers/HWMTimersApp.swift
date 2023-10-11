//
//  HWMTimersApp.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 28/08/23.
//

import SwiftUI
import HWMTimersShared

@main
struct HWMTimersApp: App {
	
	@StateObject var timerNotificationService = TimerNotificationService()
	
	@StateObject var watchSyncManager = WatchSyncManager()
	
	var body: some Scene {
		WindowGroup {
			ContentView(assignmentViewModel: AGAssignmentViewModel(timerService: timerNotificationService), timersViewModel: TimersViewModel())
				.environmentObject(timerNotificationService)
				.environmentObject(watchSyncManager)
		}
	}
	
}
