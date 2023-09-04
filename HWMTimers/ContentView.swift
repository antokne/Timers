//
//  ContentView.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 28/08/23.
//

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

struct ContentView: View {
	
	@StateObject private var starsGenerator = StarGenerator()
	@ObservedObject var grantAccessViewModel: SimpleGrantAccessViewModel = SimpleGrantAccessViewModel()

	@StateObject var assignmentViewModel: AGAssignmentViewModel
	
	@State var showingSettings = false

	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				
				Image("homeworldmobilelogo")
					.renderingMode(.template)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.foregroundColor(Color(white: 0.2))
					.blur(radius: 3)

				VStack {
					HStack(alignment: .center) {
						Text("TIMERS")
							.font(.homeworld.title)
							.foregroundColor(.homeworld.blue)
					}
					Spacer()
				}
				
				TimelineView(.animation) { timeline in
					Canvas { context, size in
						
						let topLeft = BevelledCorner(corner: .topLeft).path(in: CGRect(x: 22, y: geometry.safeAreaInsets.top, width: 20, height: 20))
						context.fill(topLeft, with: .color(.homeworld.blue))
						
						let topRight = BevelledCorner(corner: .topRight).path(in: CGRect(x: size.width - 42, y: geometry.safeAreaInsets.top, width: 20, height: 20))
						context.fill(topRight, with: .color(.homeworld.blue))
						
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
				
				VStack {

					
					List {

						SimpleGrantNotificationAccessView(viewModel: grantAccessViewModel, textForegroundFooterColour: .gray)
							.listRowBackground(Color.clear)

						ForEach(assignmentViewModel.assignments) { assignment in
							
							AssignmentView(assignment: assignment, foregroundColor: .white)
								.listRowBackground(Color.clear)
						}
					}
					.scrollContentBackground(.hidden)
				}
				.background(.clear)
				
				Button(action: {
					showingSettings = true
				}) {
					Image(systemName: "gearshape")
				}
				.position(x:geometry.size.width - 70, y: 20)
				.sheet(isPresented: $showingSettings) {
					NavigationStack {
						SettingsView()
					}
				}
			}
			.background(.black)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var timerNotificationService = TimerNotificationService()
	static var previews: some View {
		ContentView(assignmentViewModel: AGAssignmentViewModel(timerService: timerNotificationService))
	}
}
