//
//  BevelledCorner.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 31/08/23.
//

import SwiftUI

enum BevelCorner {
	case topLeft
	case topRight
	case bottomLeft
	case bottomRight
}

struct BevelledCorner: Shape {
	
	// what type of corner is it.
	var corner: BevelCorner
	
	func path(in rect: CGRect) -> Path {

		// this is a calc for length of side of a hexagon.
		var sideLength: Double {
			rect.width - sqrt(rect.width * rect.width / 3)
		}
		
		// draw from the center of our rectangle
		let center = CGPoint(x: rect.width / 2, y: rect.height / 2)

		// draw from the bottom left
		let start = CGPoint(x: 0, y: rect.height)
	
		// we're ready to start with our path now
		var path = Path()
		
		// move to our initial position
		path.move(to: start)
		
		// up
		var point = CGPoint(x: 0, y: sideLength)
		path.addLine(to: point)
		
		// diagonal up and right
		point = CGPoint(x: sideLength, y: 0)
		path.addLine(to: point)

		// top right
		point = CGPoint(x: rect.width, y: 0)
		path.addLine(to: point)

		// down
		point = CGPoint(x: rect.width, y: rect.height / 4)
		path.addLine(to: point)
		
		// to the left
		point = CGPoint(x: rect.width / 2, y: rect.height / 4)
		path.addLine(to: point)

		// diagonal left and down
		point = CGPoint(x: rect.width / 4, y: rect.height / 2)
		path.addLine(to: point)

		// down
		point = CGPoint(x: rect.width / 4, y: rect.height)
		path.addLine(to: point)

		// close it
		path.addLine(to: start)
		
		
		// rotate depending on which corner it's wanted.
		switch corner {
		case .topLeft:
			break
		case .topRight:
			path = path.applying(CGAffineTransform(rotationAngle: Angle(degrees: 90).radians))
		case .bottomLeft:
			path = path.applying(CGAffineTransform(rotationAngle: Angle(degrees: -90).radians))
		case .bottomRight:
			path = path.applying(CGAffineTransform(rotationAngle: Angle(degrees: 180).radians))
		}

		// create and apply a transform that moves our path down by that amount, centering the shape vertically
		let transform = CGAffineTransform(translationX: rect.origin.x + center.x, y: rect.origin.y + center.y)
		return path.applying(transform)
	}
	
}

struct BevelledCornerView: View {
	var body: some View {
		ZStack {
			Canvas { context, size in
				
				
				let shape = BevelledCorner(corner: .topLeft).path(in: CGRect(x: 100, y: 100, width: 100, height: 100))
				
				context.fill(shape, with: .color(.brown))
	
				let topLeft = BevelledCorner(corner: .topLeft).path(in: CGRect(x: 10, y: 200, width: 20, height: 20))
				context.fill(topLeft, with: .color(.yellow))
				
				let topRight = BevelledCorner(corner: .topRight).path(in: CGRect(x: 100, y: 200, width: 20, height: 20))
				context.fill(topRight, with: .color(.blue))
				
				let bottomRight = BevelledCorner(corner: .bottomRight).path(in: CGRect(x: 100, y: 250, width: 20, height: 20))
				context.fill(bottomRight, with: .color(.green))

				let bottomLeft = BevelledCorner(corner: .bottomLeft).path(in: CGRect(x: 10, y: 250, width: 20, height: 20))
				context.fill(bottomLeft, with: .color(.orange))
			}
		}
	}
}

struct BevelledCorner_Previews: PreviewProvider {
	static var previews: some View {
		BevelledCornerView()
	}
}

