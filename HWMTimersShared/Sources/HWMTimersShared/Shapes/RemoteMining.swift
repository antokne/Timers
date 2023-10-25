//
//  RemoteMining.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 28/08/23.
//

import SwiftUI

public struct RemoteMining: Shape {

	public func path(in rect: CGRect) -> Path {
		
		// this is a calc for length of side of a hexagon.
		
		// draw from the center of our rectangle
		let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
		
		var horizontalScale = 30.0 / 113.0
		var virticalScale = 60.0 / 121.0

		// draw from the top left
		let start = CGPoint(x: center.x - rect.width * horizontalScale * 0.5, y: 0)
		
		// we're ready to start with our path now
		var path = Path()
		
		// Draw the top press thing
		// move to our initial position top leftt
		path.move(to: start)
		
		// move to top right
		var point = CGPoint(x: center.x + rect.width * horizontalScale * 0.5, y: 0)
		path.addLine(to: point)
		
		// move down
		point = CGPoint(x: center.x + rect.width * horizontalScale * 0.5, y: rect.height * virticalScale)
		path.addLine(to: point)
		
		// move across
		horizontalScale = 68.0 / 113.0
		point = CGPoint(x: center.x + rect.width * horizontalScale * 0.5, y: rect.height * virticalScale)
		path.addLine(to: point)
		
		// move down
		let bottonHeightScale = 30.0 / 121
		point = CGPoint(x: center.x + rect.width * horizontalScale * 0.5, y: rect.height * virticalScale + rect.height * bottonHeightScale)
		path.addLine(to: point)
		
		// move to left
		point = CGPoint(x: center.x - rect.width * horizontalScale * 0.5, y: rect.height * virticalScale + rect.height * bottonHeightScale)
		path.addLine(to: point)
		
		// move UP
		point = CGPoint(x: center.x - rect.width * horizontalScale * 0.5, y: rect.height * virticalScale)
		path.addLine(to: point)
		
		// move to right
		horizontalScale = 30.0 / 113.0
		point = CGPoint(x: center.x - rect.width * horizontalScale * 0.5 , y: rect.height * virticalScale)
		path.addLine(to: point)
		
		// close it
		path.addLine(to: start)
		
		// Triangle
		horizontalScale = 60.0 / 113.0
		virticalScale = 38.0 / 121.0

		// top left
		let triangleStart = CGPoint(x: center.x - rect.width * horizontalScale * 0.5, y: center.y + rect.height * virticalScale)
		path.move(to: triangleStart)
		
		// move to right
		point = CGPoint(x: center.x + rect.width * horizontalScale * 0.5, y: center.y + rect.height * virticalScale)
		path.addLine(to: point)
		
		// move to bottom middle
		virticalScale = 61.0 / 121.0
		point = CGPoint(x: center.x, y: center.y + rect.height * virticalScale)
		path.addLine(to: point)

		// back to start
		path.addLine(to: triangleStart)

		// left side parallelagram
		horizontalScale = 23.0 / 113
		virticalScale = 47.0 / 121.0
		let p1Start = CGPoint(x: 0, y: center.y + rect.height * virticalScale)
		path.move(to: p1Start)
		
		// move to right
		let bottomHorizontalScale = 13.5 / 113
		path.addLine(to: CGPoint(x: rect.width * horizontalScale , y: center.y + rect.height * virticalScale))
		
		// move to bottom right
		path.addLine(to: CGPoint(x: center.x - rect.width * bottomHorizontalScale, y: rect.height))
		
		// move to bottom left
		path.addLine(to: CGPoint(x: center.x - rect.width * horizontalScale - rect.width * bottomHorizontalScale, y: rect.height))
		path.move(to: p1Start)

		// Right side Parallelagram
		// move to top left
		let p2Start = CGPoint(x: rect.width - rect.width * horizontalScale, y: center.y + rect.height * virticalScale)
		path.move(to: p2Start)
		
		// move to right
		path.addLine(to: CGPoint(x: rect.width , y: center.y + rect.height * virticalScale))
		
		// move to bottom right
		path.addLine(to: CGPoint(x: center.x + rect.width * horizontalScale + rect.width * bottomHorizontalScale , y: rect.height))
		
		// move to bottom left
		path.addLine(to: CGPoint(x:  center.x + rect.width * bottomHorizontalScale , y: rect.height))

		path.move(to: p2Start)

		// create and apply a transform that moves our path down by that amount, centering the shape vertically
		let transform = CGAffineTransform(translationX: rect.origin.x + center.x / 2, y: rect.origin.y + center.y / 2)
		return path.applying(transform)
	}
}

// Draw our star shape in a view
public struct RemoteMiningView: View {
	var forgroundColor: Color
	
	public init(forgroundColor: Color) {
		self.forgroundColor = forgroundColor
	}
	
	public var body: some View {
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
		ZStack {
			RemoteMiningView(forgroundColor: .white)
				.frame(width: 150, height: 150)
				//.border(.red)
				.clipped()
		}
		.background(.black)
	}
}
