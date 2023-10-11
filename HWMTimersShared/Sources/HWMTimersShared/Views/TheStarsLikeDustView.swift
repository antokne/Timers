//
//  TheStarsLikeDustView.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 22/09/23.
//

import SwiftUI

public struct TheStarsLikeDustView: View {

	@StateObject private var starsGenerator: AGStarGenerator
	
	var fillColor: Color
	
	public init(starsGenerator: AGStarGenerator = AGStarGenerator(), fillColor: Color) {
		_starsGenerator = StateObject(wrappedValue: starsGenerator)
		self.fillColor = fillColor
	}

	public var body: some View {
		GeometryReader { geometry in
			
			TimelineView(.animation) { timeline in
				Canvas { context, size in
					
#if os(iOS)
					let xLeft: CGFloat = 22
					let xRight: CGFloat = size.width - 42
#elseif os(watchOS)
					let xLeft: CGFloat = -10
					let xRight: CGFloat = size.width - 10
#endif

					let topLeft = BevelledCorner(corner: .topLeft).path(in: CGRect(x: xLeft, y: geometry.safeAreaInsets.top, width: 20, height: 20))
					context.fill(topLeft, with: .color(fillColor))
					
					let topRight = BevelledCorner(corner: .topRight).path(in: CGRect(x: xRight, y: geometry.safeAreaInsets.top, width: 20, height: 20))
					context.fill(topRight, with: .color(fillColor))
					
					// _ = print(Int(timeline.date.timeIntervalSince1970))
					
					starsGenerator.update(to: timeline.date)
					
					context.addFilter(.blur(radius: 0.50, options: .dithersResult))

					for star in starsGenerator.stars {
						let age = timeline.date.distance(to: star.removalDate)
						let rect = CGRect(x: star.x * size.width, y: size.height - (size.height * age * star.speed), width: star.size, height: star.size)
						//						let shape = Circle().path(in: rect)
						
						let shape = Star(corners: star.points, smoothness: 0.1).path(in: rect)
						let shading = GraphicsContext.Shading.style(star.color)
						context.fill(shape, with: shading)
					}
					
				}
			}
			.ignoresSafeArea()
		}
	}
}

#Preview {
	TheStarsLikeDustView(fillColor: .blue)
		.background(.black)
}
