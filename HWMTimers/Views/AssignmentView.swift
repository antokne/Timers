//
//  AssignmentView.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 29/08/23.
//

import SwiftUI
import DateBuilder

struct AssignmentView: View {
	@EnvironmentObject private var timerNotificationService: TimerNotificationService

	@ScaledMetric(relativeTo: .body) var scaledPadding: CGFloat = 10
	@State var assignment: AGHomeworldMobileEventTimer
	
	@State private var enabled: Bool = false
	
	var foregroundColor: Color = .green
	
	var body: some View {
		VStack {
			HStack {
				Toggle(isOn: $enabled) {
					Text(assignment.name)
						.font(.homeworld.title2)
				}
				.onChange(of: enabled) { value in
					let changed = assignment.enabled != value
					assignment.enabled = value
					if changed {
						timerNotificationService.update(timer: assignment)
					}
				}
				
			}
			HStack {
				Text(assignment.type.name)
				Spacer()
				Text(assignment.type.descrpition)

			}
			.font(.homeworld.subheadline)
//			.padding(scaledPadding)
		}
		.foregroundColor(foregroundColor)
		.onAppear() {
			enabled = assignment.enabled
		}
	}
}

struct AssignmentView_Previews: PreviewProvider {
	static var dailyMarket = AGHomeworldMobileEventTimer(name: "Daily Market",
									 type: HomeworldMobileEventType.daily(start: TimeOfDay(hour: 2, minute: 0)))
	
	static var day = AGHomeworldMobileEventTimer(name: "Tanoch Liason +XP",
							 type: HomeworldMobileEventType.day(weekDay: .tuesday, start: TimeOfDay(hour: 0,
																					 minute: 0)))
	
	static var weekly = AGHomeworldMobileEventTimer(name: "Weekly",
								type: HomeworldMobileEventType.weekly(weekDay: .sunday,
													   start: TimeOfDay(hour: 2, minute: 0)))
	
	static var weekendEvent = AGHomeworldMobileEventTimer(name: "Weekend Event",
									  type: HomeworldMobileEventType.event(weekDay: .friday,
															start: TimeOfDay(hour: 11, minute: 0),
															durationDays: 3))
	
	static var previews: some View {
		List {
			AssignmentView(assignment: dailyMarket, foregroundColor: .red)
			AssignmentView(assignment: day)
			AssignmentView(assignment: weekly)
			AssignmentView(assignment: weekendEvent)
		}
	}
}
