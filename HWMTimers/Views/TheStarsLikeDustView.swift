//
//  TheStarsLikeDustView.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 22/09/23.
//

import SwiftUI

struct TheStarsLikeDustView: View {

	@StateObject private var starsGenerator = StarGenerator()

	var body: some View {
		GeometryReader { geometry in
			
			TimelineView(.animation) { timeline in
				Canvas { context, size in
					
#if os(iOS)
					let topLeft = BevelledCorner(corner: .topLeft).path(in: CGRect(x: 22, y: geometry.safeAreaInsets.top, width: 20, height: 20))
					context.fill(topLeft, with: .color(.homeworld.blue))
					
					let topRight = BevelledCorner(corner: .topRight).path(in: CGRect(x: size.width - 42, y: geometry.safeAreaInsets.top, width: 20, height: 20))
					context.fill(topRight, with: .color(.homeworld.blue))
#endif
					
					// _ = print(Int(timeline.date.timeIntervalSince1970))
					
					starsGenerator.update(to: timeline.date)
					
					for star in starsGenerator.stars {
						let age = timeline.date.distance(to: star.removalDate)
						let rect = CGRect(x: star.x * size.width, y: size.height - (size.height * age * star.speed), width: star.size, height: star.size)
						//						let shape = Circle().path(in: rect)
						
						let shape = Star(corners: star.points, smoothness: 0.1).path(in: rect)
						
						context.fill(shape, with: .color(star.color))
					}
					
				}
			}
			.ignoresSafeArea()
		}
	}
}

#Preview {
	TheStarsLikeDustView()
}
