//
//  TimersViewModel.swift
//  HWMTimers Watch App
//
//  Created by Ant Gardiner on 18/09/23.
//

import Foundation
import UserNotifications
import Combine
import SwiftUI
import HWMTimersShared

protocol TimerNotificationProtocol: AnyObject {
	func timerChanged()
}

class TimersViewModel : ObservableObject {
	
	
	@Published var timerViewModels: [TimerViewModel] = []
	
	private var timerCancellable: AnyCancellable?
	
	@AppStorage(SettingsProcessSpeedKey) var researchProcessSpeed: Int = 100

	private var cancellable: AnyCancellable?
	
	init() {
		var timerViewModel = TimerViewModel(timer: AGHomeworldMobileTimer(title: "Remote Mining", running: false, duration:[.hr4, .hr8], type: .remoteMining, percentReduction: 100 - researchProcessSpeed), delegate: self)
		
		timerViewModels.append(timerViewModel)
		
		timerViewModel = TimerViewModel(timer: AGHomeworldMobileTimer(title: "Research", running: false, duration: [.hr4, .hr8], type: .research), delegate: self)
		timerViewModels.append(timerViewModel)
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
	
	func timerAction() {
	
		for timerViewModel in timerViewModels {
			if timerViewModel.timer.running {
				timerViewModel.timer.timerAction()
			}
		}
		
		checkCurrentTimers()
	}
	
	func checkCurrentTimers() {
		let running = timerViewModels.filter { $0.timer.running }
		if running.isEmpty {
			timerCancellable = nil
		}
		else {
			createTimerPublisherIfNotCreated()
		}
	}
	
	/// Received a timer update from remote.
	/// - Parameter timer: the timer received.
	func update(timer: AGHomeworldMobileTimer) {
	
		let timerModels = timerViewModels.filter { $0.timer.title == timer.title }
		
		guard let timerModel = timerModels.first else {
			return
		}
		
		print("Timer has changed \(timer)")

		// update local time to match remote, more or less.
		timerModel.timer = timer
		
		checkCurrentTimers()
	}
	
	func checkCurrentNotifications() async {
		
		let requests = await getCurrentPendingNotifications()
		for notificationRequest in requests {
			
			if let timerViewModel = timerViewModels.first(where: { $0.timer.notificationId == notificationRequest.identifier }) {
				// we have a timer notif set so start the timer.
				timerViewModel.configureTimer(with: notificationRequest)
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
	
	private func updateValues(applicationContext: [String : Any]) {
		
		if let researchProcessSpeed = applicationContext[SettingsProcessSpeedKey] as? Int {
			self.researchProcessSpeed = researchProcessSpeed
			print("researchProcessSpeed = \(researchProcessSpeed)")
		}
		
		if let changedTimerData = applicationContext[TimerChangedEventKey] as? Data,
		   let timer = try? AGHomeworldMobileTimer.timer(from: changedTimerData) {
			update(timer: timer)
		}
	}
	
	/// For Watch app only to listen for changes
	/// - Parameter watchSyncManager: the watch sync manager.
	func listenForContextChanges(watchSyncManager: WatchSyncManager) {
		
		guard cancellable == nil else {
			return
		}
		
		cancellable = watchSyncManager.$applicationContext
			.dropFirst()
			.receive(on: RunLoop.main)
			.sink { [weak self] applicationContext in
				self?.updateValues(applicationContext: applicationContext)
			}
	}
}

extension TimersViewModel: TimerNotificationProtocol {
	
	func timerChanged() {
		checkCurrentTimers()
		updateAppGroupData()
	}
	
	
}

extension TimersViewModel {
	
	func updateAppGroupData() {
		
		let timers = timerViewModels.map { $0.timer }
		let data = timers.asJSONData()
		do {
			try data?.write(to: WidgetSyncManager.timersURL, options: .atomic)
		}
		catch {
			print("Failed to write to file: \(error)")
		}
		
		WidgetSyncManager.reloadTimerWidget()
	}
}

