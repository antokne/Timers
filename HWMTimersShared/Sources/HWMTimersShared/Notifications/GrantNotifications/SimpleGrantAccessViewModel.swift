//
//  SimpleGrantAccessViewModel.swift
//  Stradale
//
//  Created by Antony Gardiner on 27/06/23.
//

import Foundation
import SwiftUI
import Combine
import UserNotifications


public enum GrantAccessNotificationState {
	case notEnabled
	case denied
	case ok
}

private var IgnoreNotificationNotEnabledKey = "SimpleGrantAccess.IgnoreNotificationNotEnabledKey"


public class SimpleGrantAccessViewModel: ObservableObject {
	
	@Published var showNoticiationState: GrantAccessNotificationState = .notEnabled
	
	var allOK: Bool {
		showNoticiationState == .ok
	}
	
	
	@AppStorage(IgnoreNotificationNotEnabledKey) private var ignoreNotificationNotEnabled: Bool = false
	
	public init() {
		updateNotificationState()
	}
	
	// MARK: - Update state
	
	
	func updateNotificationState() {
		
		guard ignoreNotificationNotEnabled == false else {
			showNoticiationState = .ok
			return
		}
		
		let localNotifications = UNUserNotificationCenter.current()
		localNotifications.getNotificationSettings { setting in
			Task { @MainActor [weak self] in
				switch setting.authorizationStatus {
				case .notDetermined:
					self?.showNoticiationState = .notEnabled
				case .denied:
					self?.showNoticiationState = .denied
				case .authorized:
					self?.showNoticiationState = .ok
				case .provisional:
					self?.showNoticiationState = .ok
				case .ephemeral:
					self?.showNoticiationState = .ok
				@unknown default:
					self?.showNoticiationState = .notEnabled
				}
			}
		}
		

	}
	
	// MARK: - start nAuth
	
	func authNotifications() {
		let localNotifications = UNUserNotificationCenter.current()
		localNotifications.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			self.updateNotificationState()
		}
	}
	
	// MARK: - ignore
	
	func ignoreNotificationWarning() {
		ignoreNotificationNotEnabled = true
		updateNotificationState()
	}
}
