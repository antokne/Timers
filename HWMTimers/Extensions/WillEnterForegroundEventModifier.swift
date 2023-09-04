//
//  WillEnterForegroundEventModifier.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 4/09/23.
//

import SwiftUI


public struct AGWillEnterForegroundViewModifier: ViewModifier {
	let action: () -> Void
	
	public func body(content: Content) -> some View {
		content
			.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
				action()
			}
	}
}

extension View {
	
	/// Notification sent when application will enter the foreground
	/// - Parameter action: action to call when event occurs.
	/// - Returns: A view that triggers on event
	public func willEnterForeground(perform action: @escaping () -> Void) -> some View {
		self.modifier(AGWillEnterForegroundViewModifier(action: action))
	}
}
