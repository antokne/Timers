//
//  StarsModel.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 22/09/23.
//

import Foundation
import SwiftUI

struct SimpleStar: Hashable, Equatable {
	var x: Double
	var removalDate: Date
	var speed: Double
	var color: Color
	var size : Double
	var points: Int
}

class StarGenerator: ObservableObject {
	var stars = Set<SimpleStar>()
	
	var lastIntTime = 0
	
	func update(to date: Date) {
		
		if Int(date.timeIntervalSince1970) == lastIntTime {
			return
		}
		
		lastIntTime = Int(date.timeIntervalSince1970)
		
		stars = stars.filter { $0.removalDate > date }
		stars.insert(SimpleStar(x: Double.random(in: 0...1),
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
