//
//  ContentView.swift
//  HWMTimers Watch Watch App
//
//  Created by Ant Gardiner on 14/09/23.
//

import SwiftUI

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
				
				SimpleGrantNotificationAccessView(viewModel: grantAccessViewModel, textForegroundFooterColour: .gray)
				
				ForEach(viewModel.timerViewModels) { timerViewModel in
					TimerView(timerViewModel: timerViewModel)
						.listRowBackground(Color.clear)
				}
			}
			.font(.homeworld.title3)
		}
		.background {
			if #available(watchOS 15, *) {
				TheStarsLikeDustView()
					.background(Color.homeworld.background)
			}
			else {
				TheStarsLikeDustView()
			}
		}
		//.navigationTitle("TIMERS")
		.task {
			await viewModel.checkCurrentNotifications()
			
			viewModel.listenForContextChanges(watchSyncManager: watchSyncManager)
		}
		.padding(.top, 22)
	}
	
	func showConfig() {
		print("config")
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
