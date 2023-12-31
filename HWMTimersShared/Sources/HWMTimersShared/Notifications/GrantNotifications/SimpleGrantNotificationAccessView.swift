//
//  SimpleGrantNotificationAccessView.swift
//  Stradale
//
//  Created by Ant Gardiner on 4/07/23.
//

import SwiftUI

public struct SimpleGrantNotificationAccessView: View {
	
	@ObservedObject var viewModel: SimpleGrantAccessViewModel
	
	var textForegroundColour = Color.white
	var textForegroundFooterColour = Color.black
	
	var fontTitle: Font = .title
	var fontBody: Font = .body
	
	public init(viewModel: SimpleGrantAccessViewModel, textForegroundColour: SwiftUI.Color = Color.white, textForegroundFooterColour: SwiftUI.Color = Color.black, fontTitle: Font = .title, fontBody: Font = .body) {
		self.viewModel = viewModel
		self.textForegroundColour = textForegroundColour
		self.textForegroundFooterColour = textForegroundFooterColour
		self.fontTitle = fontTitle
		self.fontBody = fontBody
	}

	public var body: some View {
		Section {
			if viewModel.showNoticiationState == .notEnabled {
				VStack {
					Spacer()
					Button(action: viewModel.authNotifications) {
						Text("Authorise Notications")
							.frame(maxWidth: .infinity)
							.font(fontTitle)
					}
				}
				.frame(minHeight: 50)
				.buttonStyle(.borderedProminent)
			}
			else if viewModel.showNoticiationState == .denied {
				VStack {
					HStack {
						Text("Please Enable Notifications in settings.")
							.foregroundColor(textForegroundColour)
						Spacer()
					}
					#if os(iOS) || os(macOS)
					HStack {
						Link("Open Settings", destination: URL(string: UIApplication.openSettingsURLString)!)
						Spacer()
						Button(action: viewModel.ignoreNotificationWarning) {
							Text("Ignore")
								.font(.caption)
								.foregroundColor(textForegroundColour)
						}
						.buttonStyle(.borderless)
					}
					#endif
				}
			}
		} footer: {
			if viewModel.showNoticiationState == .notEnabled || viewModel.showNoticiationState == .denied {
				Text("Timers needs access to notifications, to alert you when a timer expires or resets.")
					.foregroundColor(textForegroundFooterColour)
			}
		}
		.font(fontBody)
		#if os(iOS) || os(macOS)
		.willEnterForeground {
			viewModel.updateNotificationState()
		}
		#endif
	}
	
}

struct SimpleGrantNotificationAccessView_Previews: PreviewProvider {
	static var viewModel = SimpleGrantAccessViewModel()
	static var previews: some View {
		List {
			SimpleGrantNotificationAccessView(viewModel: viewModel)
		}
	}
}
