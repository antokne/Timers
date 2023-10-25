//
//  ContentView.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 28/08/23.
//

import SwiftUI
import HWMTimersShared

struct ContentView: View {
	@EnvironmentObject private var watchSyncManager: WatchSyncManager

	@StateObject var grantAccessViewModel: SimpleGrantAccessViewModel = SimpleGrantAccessViewModel()

	@StateObject var assignmentViewModel: AGAssignmentViewModel
	@StateObject var timersViewModel: TimersViewModel

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
					.padding(5)

				VStack {
					HStack(alignment: .center) {
						Text("HOMEWORLD")
							.font(.homeworld.titleFixed)
							.foregroundColor(.homeworld.blue)
//							.offset(CGSize(width: 0.0, height: 0.0))

					}
					Text("MOBILE")
						.font(.homeworld.title3Fixed)
						.foregroundColor(.homeworld.blue)
						.offset(CGSize(width: 0.0, height: -8.0))
					Spacer()
				}
				
				TheStarsLikeDustView(fillColor: .homeworld.blue)
				
				VStack {
					List {
						
						SimpleGrantNotificationAccessView(viewModel: grantAccessViewModel,
														  textForegroundFooterColour: .gray,
														  fontTitle: .homeworld.title3,
														  fontBody: .homeworld.body)
							.listRowBackground(Color.clear)

						Text("TIMERS")
							.font(.homeworld.title2)
							.foregroundColor(.homeworld.blue)
							.listRowBackground(Color.clear)
						
						ForEach(timersViewModel.timerViewModels) { timerViewModel in
							TimerView(timerViewModel: timerViewModel)
								.listRowBackground(Color.clear)
						}
						
						Text("EVENTS")
							.font(.homeworld.title2)
							.foregroundColor(.homeworld.blue)
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
						.resizable()
						.frame(width: 25, height: 25)
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
		.task {
			await timersViewModel.checkCurrentNotifications()
			timersViewModel.listenForContextChanges(watchSyncManager: watchSyncManager)
		}
		
	}
}

struct ContentView_Previews: PreviewProvider {
	static var watchSyncManager = WatchSyncManager()
	static var timerNotificationService = TimerNotificationService()
	static var assignmentViewModel = AGAssignmentViewModel(timerService: timerNotificationService)
	static var timersViewModel = TimersViewModel()
	static var previews: some View {
		ContentView(assignmentViewModel: assignmentViewModel, timersViewModel: timersViewModel)
			.environmentObject(watchSyncManager)

	}
}
