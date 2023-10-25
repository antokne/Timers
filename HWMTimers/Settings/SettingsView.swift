//
//  SettingsView.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 31/08/23.
//

import SwiftUI
import HWMTimersShared

struct SettingsView: View {
	@Environment(\.presentationMode) var presentationMode

	@EnvironmentObject private var watchSyncManager: WatchSyncManager

	@StateObject var viewModel: SettingsViewModel = SettingsViewModel()
	
	
	var body: some View {
		NavigationStack {
			List {
				Section {
					Stepper(value: $viewModel.researchProcessSpeed, in:  0...100) {
						HStack {
							ResearchView(forgroundColor: .accentColor)
								.frame(width: 20)
							Text(String(format: "Process Speed %0.2f", Double(viewModel.researchProcessSpeed) / 100.0))
						}
					}
					.onChange(of: viewModel.researchProcessSpeed) { newValue in
						researchPercentBonusChanged()
					}
					
				} header: {
					Text("Bonuses")
				}
				
				Section {
					
					HStack {
						Image("hwm20")
							.cornerRadius(5)
						Link("Homeworld Mobile Website", destination: URL(string: "https://www.homeworldmobile.com")!)
					}
					HStack {
						Image("hwm20")
							.cornerRadius(5)
						Link("Homeworld Mobile Discord", destination: URL(string: "https://discord.gg/homeworldmobile")!)

					}
				} header: {
					Text("Homeworld")
				} footer: {
					Text("Thanks to Homeworld Mobile Team")
				}
				
				Section {
					Text("Contact @antokne on Homeworld Mobile Discord.")
				} header: {
					Text("Support")
				}
			}
			.font(.homeworld.body)
		}
		.navigationTitle("Settings")
		.toolbar {
			Button("Done") {
				presentationMode.wrappedValue.dismiss()
			}
		}
		.navigationBarTitleDisplayMode(.inline)
	}
	
	func researchPercentBonusChanged() {
		do {
			try watchSyncManager.updateApplicationContext([SettingsProcessSpeedKey: viewModel.researchProcessSpeed])
		}
		catch {
			print("updating other application failed: \(error)")
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var watchSyncManager = WatchSyncManager()
	static var previews: some View {
		NavigationStack {
			SettingsView()
				.environmentObject(watchSyncManager)
		}
	}
}
