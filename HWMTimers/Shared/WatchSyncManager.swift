//
//  WatchSyncManager.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 25/09/23.
//

import Foundation
import SwiftUI
import WatchConnectivity
import OSLog

class WatchSyncManager: NSObject, ObservableObject {
		
	private let logger = Logger(subsystem: "HWMTimers", category: "WatchSyncManager")
	
	private var session: WCSession?
	
	@Published var applicationContext: [String : Any] = [: ]

	override init() {
		super.init()
		setup()
	}

	private func setup() {
		
		guard WCSession.isSupported() else {
			logger.warning("WCSession is not supported")
			return
		}
		
		session = WCSession.default
		session?.delegate = self
		session?.activate()
		
	}
	
	func updateApplicationContext(_ applicationContext: [String : Any]) throws {
		logger.info("sending context \(applicationContext)")
		try session?.updateApplicationContext(applicationContext)
	}
}

extension WatchSyncManager: WCSessionDelegate {
	
#if os(iOS)
	func sessionDidBecomeInactive(_ session: WCSession) {
		logger.debug("sessionDidBecomeInactive")
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		logger.debug("sessionDidDeactivate")

	}
#endif
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		logger.debug("Got activationState state \(activationState.rawValue)")
	}
	
	func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
		logger.info("didReceiveApplicationContext \(applicationContext, privacy: .public)")

		Task { @MainActor in
			self.applicationContext = applicationContext
		}
	}
	
}
