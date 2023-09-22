//
//  ContentView.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 28/08/23.
//

import SwiftUI

struct ContentView: View {
	
	@StateObject var grantAccessViewModel: SimpleGrantAccessViewModel = SimpleGrantAccessViewModel()

	@StateObject var assignmentViewModel: AGAssignmentViewModel
	
	@State var showingSettings = false

	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				
				Image("homeworldmobilelogo")
					.renderingMode(.template)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.foregroundColor(Color(white: 0.15))
					.blur(radius: 1)

				VStack {
					HStack(alignment: .center) {
						Text("TIMERS")
							.font(.homeworld.title)
							.foregroundColor(.homeworld.blue)
					}
					Spacer()
				}
				
				TheStarsLikeDustView()
				
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
			.background(Color.homeworld.background)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var timerNotificationService = TimerNotificationService()
	static var previews: some View {
		ContentView(assignmentViewModel: AGAssignmentViewModel(timerService: timerNotificationService))
	}
}
