//
//  SimpleGrantAccessViewModel.swift
//  Stradale
//
//  Created by Antony Gardiner on 27/06/23.
//

import Foundation
import SwiftUI
import Combine
import NiceNotifications





enum GrantAccessNotificationState {
	case notEnabled
	case denied
	case ok
}

private var IgnoreNotificationNotEnabledKey = "SimpleGrantAccess.IgnoreNotificationNotEnabledKey"


class SimpleGrantAccessViewModel: ObservableObject {
	
	@Published var showNoticiationState: GrantAccessNotificationState = .notEnabled
	
	var allOK: Bool {
		showNoticiationState == .ok
	}
	
	
	@AppStorage(IgnoreNotificationNotEnabledKey) private var ignoreNotificationNotEnabled: Bool = false
	
	init() {
		updateNotificationState()
	}
	
	// MARK: - Update state
	
	
	func updateNotificationState() {
		
		guard ignoreNotificationNotEnabled == false else {
			showNoticiationState = .ok
			return
		}
		
		LocalNotifications.SystemAuthorization.getCurrent { status in
			Task { @MainActor [weak self] in
				switch status {
				case .allowed:
					self?.showNoticiationState = .ok
				case .deniedNow:
					self?.showNoticiationState = .denied
				case .deniedPreviously:
					self?.showNoticiationState = .denied
				case .undetermined:
					self?.showNoticiationState = .notEnabled
				}
			}
		}
	}
	
	// MARK: - start nAuth
	
	func authNotifications() {
		LocalNotifications.requestPermission(strategy: .askSystemPermissionIfNeeded) { [weak self] success in
			self?.updateNotificationState()
		}
	}
	
	// MARK: - ignore
	
	func ignoreNotificationWarning() {
		ignoreNotificationNotEnabled = true
		updateNotificationState()
	}
}
