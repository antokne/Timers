//
//  TimerView.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 10/10/23.
//

import SwiftUI

public struct TimerView: View {
	@EnvironmentObject private var watchSyncManager: WatchSyncManager

	@ObservedObject var timerViewModel: TimerViewModel
	
	var titleFont: Font
	var bodyFont: Font
	var foregroundColor: Color
	
	public init(titleFont: Font, bodyFont: Font, foregroundColor: Color, timerViewModel: TimerViewModel) {
		self.titleFont = titleFont
		self.bodyFont = bodyFont
		self.foregroundColor = foregroundColor
		self.timerViewModel = timerViewModel
	}
	
	public var body: some View {
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
							Text(duration.name)
								.font(bodyFont)
								.foregroundColor(foregroundColor)
								.padding(2)
//							Image(systemName: "\(duration.rawValue).circle.fill")
//								.foregroundColor(.homeworld.blue)
						}
					} label: {
						#if os(iOS)
						Text("Select duration")
							.foregroundColor(foregroundColor)
						#endif
					}
					.modify { picker in
						#if os(watchOS)
							picker
//							.padding(2)
						#else
							picker
								.labelsHidden()
								.pickerStyle(.menu)
								.frame(width: 85, height: 40)
								.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
						#endif
					}
					.overlay {
						RoundedRectangle(cornerRadius: 4)
							.stroke(foregroundColor, lineWidth:1)
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
		.font(titleFont)
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
		TimerView(titleFont: .title3, bodyFont: .body, foregroundColor: .blue, timerViewModel: timerViewModel)
			.listRowBackground(Color.clear)
		TimerView(titleFont: .title3, bodyFont: .body, foregroundColor: .blue, timerViewModel: timerViewModel2)
			.listRowBackground(Color.clear)
	}
	.scrollContentBackground(.hidden)
	.background(.black)
	.environmentObject(watchSyncManager)
}
