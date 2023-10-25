//
//  HWMTimersAppGroup.swift
//
//
//  Created by Ant Gardiner on 16/10/23.
//

import Foundation


public enum HWMTimersAppGroup: String {
	case timers =  "group.com.antokne.hwmtimers"
	
	public var containerURL: URL {
		switch self {
		case .timers:
			return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.rawValue)!
		}
	}
}
