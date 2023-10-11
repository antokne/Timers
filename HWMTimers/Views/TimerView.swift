//
//  TimerView.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 10/10/23.
//

import SwiftUI
import HWMTimersShared

struct TimerView: View {
	@EnvironmentObject private var watchSyncManager: WatchSyncManager

	@ObservedObject var timerViewModel: TimerViewModel
	
	
	var body: some View {
		HStack {
			if timerViewModel.timer.running == false {
				HStack(spacing: 0) {
					Button(action: { startTimer(timerViewModel: timerViewModel) }) {
						
						switch timerViewModel.timer.type {
						case .remoteMining:
							RemoteMiningView(forgroundColor: .white)
								.frame(width: 40, height: 40)
						case .research:
							ResearchView(forgroundColor: .white)
								.frame(width: 40, height: 40)
						}
						Text("Start " + timerViewModel.timer.title)
							.multilineTextAlignment(.leading)
					}
					.buttonStyle(.borderless)
					
					Spacer()
					Picker(selection: $timerViewModel.selectedDuration) {
						ForEach(AGHomeworldMobileTimerDuration.allCases) { duration in
							HStack {
								Text(duration.name)
									.font(.homeworld.body)
									.foregroundColor(.homeworld.blue)
									.padding(2)
							}
						}
					} label: {
//						Text("Duration")
//							.foregroundColor(.homeworld.blue)
					}
					.modify { picker in
						#if os(watchOS)
							picker
						#else
							picker
								.pickerStyle(.menu)
								.frame(width: 80, height: 40)
								.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
						#endif
					}
					.overlay {
						RoundedRectangle(cornerRadius: 4)
							.stroke(Color.homeworld.blue, lineWidth:1)
					}

				}
			}
			else {
				HStack {
					Button(action: { stopTimer(timerViewModel: timerViewModel) }) {
						HStack {
							Image(systemName: "stop.circle")
								.resizable()
								.frame(width: 40, height: 40)
								.foregroundColor(.white)
							VStack(alignment: .leading) {
								Text(timerViewModel.timer.title)
								Text(timerViewModel.timer.formatedDurationLeft)
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
	
	func startTimer(timerViewModel: TimerViewModel) {
		timerViewModel.startTimer()
		timerchanged(timer: timerViewModel.timer)
	}
	
	func stopTimer(timerViewModel: TimerViewModel) {
		timerViewModel.cancelTimer()
		timerchanged(timer: timerViewModel.timer)
	}
	
	func timerchanged(timer: AGHomeworldMobileTimer) {
		
		guard let data = timer.asData() else {
			print("NIL data. not sending")
			return
		}
		
		do {
			
			try watchSyncManager.updateApplicationContext([TimerChangedEventKey: data])
		}
		catch {
			print("updating other application failed: \(error)")
		}
	}
}

let timer = AGHomeworldMobileTimer(title: "Remote Mining", running: false, duration: [.hr4, .hr8], type: .remoteMining, percentReduction: 0)
let timer2 = AGHomeworldMobileTimer(title: "Research", running: false, duration: [.hr4, .hr8], type: .research)
let timerViewModel = TimerViewModel(timer: timer, delegate: nil)
let timerViewModel2 = TimerViewModel(timer: timer2, delegate: nil)
let watchSyncManager = WatchSyncManager()

#Preview {
	List {
		TimerView(timerViewModel: timerViewModel)
			.listRowBackground(Color.clear)
		TimerView(timerViewModel: timerViewModel2)
			.listRowBackground(Color.clear)
	}
	.scrollContentBackground(.hidden)
	.background(.black)
	.environmentObject(watchSyncManager)
}
