//
//  StarGenerator.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 22/09/23.
//

import Foundation
import SwiftUI

public struct AGSimpleStar: Hashable, Equatable {
	var x: Double
	var removalDate: Date
	var speed: Double
	var color: Color
	var size : Double
	var points: Int
}

public class AGStarGenerator: ObservableObject {
	var stars = Set<AGSimpleStar>()
	
	var lastIntTime = 0
	
	public init(stars: Set<AGSimpleStar> = Set<AGSimpleStar>(), lastIntTime: Int = 0) {
		self.stars = stars
		self.lastIntTime = lastIntTime
	}
	
	func update(to date: Date) {
		
		if Int(date.timeIntervalSince1970) == lastIntTime {
			return
		}
		
		lastIntTime = Int(date.timeIntervalSince1970)
		
		stars = stars.filter { $0.removalDate > date }
		stars.insert(AGSimpleStar(x: Double.random(in: 0...1),
								removalDate: date + time,
								speed: Double.random(in: 0.01...0.02),
								color: color,
								size: Double.random(in: 5...10),
								points: Int.random(in: 4...8)))
	}
	
	var time: TimeInterval {
		Double.random(in: 50...55)
	}
	
	var color: Color {
		Color(red: Double.random(in: 0.5...1.0),
			  green: Double.random(in: 0.1...0.8),
			  blue: Double.random(in: 0.5...1.0))
	}
}
