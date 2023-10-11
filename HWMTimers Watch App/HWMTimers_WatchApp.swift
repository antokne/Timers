//
//  HWMTimers_WatchApp.swift
//  HWMTimers Watch Watch App
//
//  Created by Ant Gardiner on 14/09/23.
//

import SwiftUI
import HWMTimersShared

@main
struct HWMTimers_WatchApp: App {
		
	@StateObject var watchSyncManager = WatchSyncManager()

	var body: some Scene {
		WindowGroup {
			NavigationStack {
				ContentView()
					.environmentObject(watchSyncManager)
					.edgesIgnoringSafeArea(.all)
			}
		}
	}
}
