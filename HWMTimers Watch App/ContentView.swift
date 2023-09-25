//
//  ContentView.swift
//  HWMTimers Watch Watch App
//
//  Created by Ant Gardiner on 14/09/23.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject private var watchSyncManager: WatchSyncManager

	@StateObject var viewModel: WatchContentViewModel = WatchContentViewModel()
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
				
				ForEach(viewModel.timers) { timer in
					
					if timer.running == false {
						
						HStack {
							Button(action: { viewModel.startRemoteMiningTimer(timer: timer) }) {
								
								switch timer.type {
								case .remoteMining:
									RemoteMiningView(forgroundColor: .white)
										.frame(width: 40, height: 40)
								case .research:
									ResearchView(forgroundColor: .white)
										.frame(width: 40, height: 40)
								}
								Text("Start " + timer.title)
									.multilineTextAlignment(.leading)
								

							}
							.buttonStyle(.borderless)
							
//							Spacer()
//							Button(action: { showConfig() }) {
//								Text("\(timer.formatedDurationLeft)")
//									.font(.homeworld.subheadline)
//							}
//							.buttonStyle(.automatic)
//							.padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
//							.border(.white, width: 2)
//							.cornerRadius(3)
						}
					}
					else {
						HStack {
							Button(action: { viewModel.cancelRemoteMiningTimer(timer: timer) }) {
								HStack {
									Image(systemName: "stop.circle")
										.resizable()
										.frame(width: 40, height: 40)
										.foregroundColor(.white)
									//								Spacer()
									VStack(alignment: .leading) {
										Text(timer.title)
										Text(timer.formatedDurationLeft)
									}
									Spacer()
								}
							}
							.buttonStyle(.borderless)
						}
						.frame(maxWidth: .infinity)
					}
					
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
