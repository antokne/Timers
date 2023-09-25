//
//  RemoteMining.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 28/08/23.
//

import SwiftUI

struct RemoteMining: Shape {

	
	
	func path(in rect: CGRect) -> Path {
		
		// this is a calc for length of side of a hexagon.

		
		
		// draw from the center of our rectangle
		let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
		
		// draw from the bottom left
		let start = CGPoint(x: 3 * rect.width / 8, y: 0)
		
		// we're ready to start with our path now
		var path = Path()
		
		// move to our initial position
		path.move(to: start)
		
		var point = CGPoint(x: 5 * rect.width / 8, y: 0)
		path.addLine(to: point)
		
		point = CGPoint(x: 5 * rect.width / 8, y: rect.height / 2)
		path.addLine(to: point)
		
		point = CGPoint(x: 3 * rect.width / 4, y: rect.height / 2)
		path.addLine(to: point)
		
		point = CGPoint(x: 3 * rect.width / 4, y: 3 * rect.height / 4)
		path.addLine(to: point)
		
		point = CGPoint(x: 1 * rect.width / 4, y: 3 * rect.height / 4)
		path.addLine(to: point)
		
		point = CGPoint(x: 1 * rect.width / 4, y: rect.height / 2)
		path.addLine(to: point)
		
		point = CGPoint(x: 3 * rect.width / 8, y: rect.height / 2)
		path.addLine(to: point)
		
		// close it
		path.addLine(to: start)
		
		let triangleStart = CGPoint(x: 1 * rect.width / 4, y: 5 + 3 * rect.height / 4)
		path.move(to: triangleStart)
		path.addLine(to: CGPoint(x: 3 * rect.width / 4, y: 5 + 3 * rect.height / 4))
		path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height))
		path.addLine(to: triangleStart)

		let p1Start = CGPoint(x: 4 + 1 * rect.width / 8 , y: 15 + 3 * rect.height / 4)
		path.move(to: p1Start)
		path.addLine(to: CGPoint(x: 4 + 2 * rect.width / 8 , y: 15 + 3 * rect.height / 4))
		path.addLine(to: CGPoint(x: rect.width / 2 - 2, y: rect.height + 5))
		path.addLine(to: CGPoint(x: 3 * rect.width / 8 - 2, y: rect.height + 5))
		path.move(to: p1Start)

		let p2Start = CGPoint(x: 6 * rect.width / 8 - 4, y: 15 + 3 * rect.height / 4)
		path.move(to: p2Start)
		path.addLine(to: CGPoint(x: 7 * rect.width / 8 - 4, y: 15 + 3 * rect.height / 4))
		path.addLine(to: CGPoint(x: 2 + 5 * rect.width / 8 , y: rect.height + 5))
		path.addLine(to: CGPoint(x: 2 + rect.width / 2  , y: rect.height + 5))

		path.move(to: p2Start)

		// create and apply a transform that moves our path down by that amount, centering the shape vertically
		let transform = CGAffineTransform(translationX: rect.origin.x + center.x / 2, y: rect.origin.y + center.y / 2)
		return path.applying(transform)
	}
}

// Draw our star shape in a view
struct RemoteMiningView: View {
	var forgroundColor: Color
	var body: some View {
		ZStack {
			Canvas { context, size in
				
				let shape = RemoteMining()
					.path(in: CGRect(x: -size.width / 4, y: -size.height / 4, width: size.width, height: size.height))
								
				context.fill(shape, with: .color(forgroundColor))
			}
		}
	}
}

struct RemoteMining_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			RemoteMiningView(forgroundColor: .blue)
				.frame(width: 50, height: 50)
				.background(.green)
			Text("Hello")
				.foregroundColor(.white)
		}
	}
}
