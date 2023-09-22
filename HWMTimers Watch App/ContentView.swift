//
//  ContentView.swift
//  HWMTimers Watch Watch App
//
//  Created by Ant Gardiner on 14/09/23.
//

import SwiftUI

struct ContentView: View {
	
	@StateObject var viewModel: WatchContentViewModel = WatchContentViewModel()
	@ObservedObject var grantAccessViewModel: SimpleGrantAccessViewModel = SimpleGrantAccessViewModel()

	var body: some View {
		
		NavigationStack() {
			List {
				
				SimpleGrantNotificationAccessView(viewModel: grantAccessViewModel, textForegroundFooterColour: .gray)
				
				ForEach(viewModel.timers) { timer in
					
					if timer.running == false {
						Button(action: { viewModel.startRemoteMiningTimer(timer: timer) }) {
							
							switch timer.type {
							case .remoteMining:
								RemoteMiningView(forgroundColor: .white)
									.frame(width: 50, height: 50)
							case .research:
								ResearchView(forgroundColor: .white)
									.frame(width: 50, height: 50)
							}
							Text("Start " + timer.title)
								.multilineTextAlignment(.leading)

						}
						.buttonStyle(.borderless)
					}
					else {
						HStack {
							Button(action: { viewModel.cancelRemoteMiningTimer(timer: timer) }) {
								HStack {
									Image(systemName: "stop.circle")
//										.frame(width: 50, height: 50)
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
				.font(.homeworld.title3)

				
			}
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
		.navigationTitle("TIMERS 1.0 (8)")
		.task {
			await viewModel.checkCurrentNotifications()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			ContentView()
		}
	}
}
