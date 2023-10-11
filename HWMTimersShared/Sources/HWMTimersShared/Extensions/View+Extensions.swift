//
//  View+Extensions.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 11/10/23.
//

import SwiftUI

public extension View {
	func modify<T: View>(@ViewBuilder _ modifier: (Self) -> T) -> some View {
		return modifier(self)
	}
}
