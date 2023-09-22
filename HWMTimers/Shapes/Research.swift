//
//  Research.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 22/09/23.
//

import SwiftUI


// Draw our star shape in a view
struct ResearchView: View {
	var forgroundColor: Color
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				Circle()
					.frame(width: geometry.size.width / 6 , height: geometry.size.width / 6)
					.position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
				
				Ellipse()
					.strokeBorder(style: StrokeStyle(lineWidth: geometry.size.width / 15))
					.frame(width: geometry.size.width, height: geometry.size.width / 2)
					.rotationEffect(Angle(degrees: 45), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
					.position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))

				Ellipse()
					.strokeBorder(style: StrokeStyle(lineWidth: geometry.size.width / 15))
					.frame(width: geometry.size.width, height: geometry.size.width / 2)
					.rotationEffect(Angle(degrees: -45), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
					.position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
			}
			.foregroundColor(forgroundColor)
//			.background(.red)
		}
	}
}

#Preview {
	ResearchView(forgroundColor: .white)
		.frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
}
