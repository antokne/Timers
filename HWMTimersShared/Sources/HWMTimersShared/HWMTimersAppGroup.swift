//
//  HWMTimersAppGroup.swift
//
//
//  Created by Ant Gardiner on 16/10/23.
//

import Foundation


public enum HWMTimersAppGroup: String {
	case timers =  "group.com.antokne.hwmtimers"
	
	/// Returns the URL for the app group for hwm app.
	public var containerURL: URL {
		switch self {
		case .timers:
			return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.rawValue)!
		}
	}
}
