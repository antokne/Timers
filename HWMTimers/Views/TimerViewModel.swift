//
//  TimerViewModel.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 10/10/23.
//

import Foundation
import SwiftUI
import UserNotifications
import HWMTimersShared

class TimerViewModel : ObservableObject, Identifiable {
	
	@Published var timer: AGHomeworldMobileTimer
	
	@Published var selectedDuration: AGHomeworldMobileTimerDuration = .hr4

	weak var delegate: TimerNotificationProtocol?

	@AppStorage(SettingsResearchPercentBonusKey) var researchPercentBonus: Int = 0

	init(timer: AGHomeworldMobileTimer, delegate: TimerNotificationProtocol?) {
		self.timer = timer
		self.delegate = delegate
	}
	
	func startTimer() {
		let reduction = percentReduction(timer: timer)
		timer.startTimer(with: reduction, selectedDuration: selectedDuration)
		delegate?.timerChanged()
	}
	
	func cancelTimer() {
		timer.stopTimer()		
		delegate?.timerChanged()
	}
	
	func configureTimer(with notificationRequest: UNNotificationRequest) {
		let reduction = percentReduction(timer: timer)
		Task { @MainActor in
			timer.configureTimer(with: notificationRequest, with: reduction)
			delegate?.timerChanged()
		}
	}
	
	private func percentReduction(timer: AGHomeworldMobileTimer) -> Int {
		switch timer.type {
		case .remoteMining:
			return 0
		case .research:
			return researchPercentBonus
		}
	}
}
