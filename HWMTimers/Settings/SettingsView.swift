//
//  SettingsView.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 31/08/23.
//

import SwiftUI

struct SettingsView: View {
	@Environment(\.presentationMode) var presentationMode

	var body: some View {
		NavigationStack {
			List {
				Text("Thanks to Homeworld Mobile Team")
				HStack {
					
					Image("hwm20")
//						.renderingMode(.template)
//						.foregroundColor(.accentColor)
//						.frame(width: 50, height: 50)
//						.overlay(
//							RoundedRectangle(cornerRadius: 2)
//								.background(.clear)
//						)
					Link("Homeworld Mobile", destination: URL(string: "https://www.homeworldmobile.com")!)
				}
			}
		}
		.navigationTitle("Settings")
		.toolbar {
			Button("Done") {
				presentationMode.wrappedValue.dismiss()
			}
		}
		.navigationBarTitleDisplayMode(.inline)
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			SettingsView()
		}
	}
}
