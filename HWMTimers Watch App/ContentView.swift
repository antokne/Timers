//
//  ContentView.swift
//  HWMTimers Watch Watch App
//
//  Created by Ant Gardiner on 14/09/23.
//

import SwiftUI
import HWMTimersShared

struct ContentView: View {
	@EnvironmentObject private var watchSyncManager: WatchSyncManager

	@StateObject var viewModel: TimersViewModel = TimersViewModel()
	@ObservedObject var grantAccessViewModel: SimpleGrantAccessViewModel = SimpleGrantAccessViewModel()

	@State private var duration = 0
	
	var body: some View {
		
		NavigationStack() {
			Text("TIMERS")
				.font(.homeworld.title2)
				.background(.clear)
				.foregroundColor(.homeworld.blue)
				.padding(.top, 2)
			List {
				
				SimpleGrantNotificationAccessView(viewModel: grantAccessViewModel, 
												  textForegroundFooterColour: .gray,
												  fontTitle: .homeworld.title3,
												  fontBody: .homeworld.body)
				
				ForEach(viewModel.timerViewModels) { timerViewModel in
					TimerView(timerViewModel: timerViewModel)
						.listRowBackground(Color.clear)
						.listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
				}
			}
			.padding(0)
			.font(.homeworld.title3)
		}
		.background {
			TheStarsLikeDustView(fillColor: .homeworld.blue)
		}
		.task {
			await viewModel.checkCurrentNotifications()
			
			viewModel.listenForContextChanges(watchSyncManager: watchSyncManager)
		}
		.padding(.top, 22)
	}
	
}

struct ContentView_Previews: PreviewProvider {
	
	@StateObject static var watchSyncManager = WatchSyncManager()

	static var previews: some View {
		NavigationStack {
			ContentView()
				.environmentObject(watchSyncManager)
		}
	}
}
