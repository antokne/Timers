//
//  File.swift
//  
//
//  Created by Ant Gardiner on 16/10/23.
//

import Foundation

public extension Array where Element == AGHomeworldMobileTimer {
	func asJSONData() -> Data? {
		guard let data = try? JSONEncoder().encode(self) else {
			return nil
		}
		return data
	}
	
	static func loadTimers(from data: Data) throws -> [AGHomeworldMobileTimer] {
		return try JSONDecoder().decode(Self.self, from: data)
	}
}
