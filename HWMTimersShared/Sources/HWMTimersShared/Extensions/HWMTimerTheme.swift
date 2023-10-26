//
//  Font+Extensions.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 29/08/23.
//

import SwiftUI

public extension Font {
	
	struct homeworld {
		public static let titleFixed: Font = Font.custom("Michroma-Regular", fixedSize: 22)
		public static let title3Fixed: Font = Font.custom("Michroma-Regular", fixedSize: 15)
		public static let bodyFixed: Font = Font.custom("Michroma-Regular", fixedSize: 14)

		public static let title: Font = Font.custom("Michroma-Regular", size: 25, relativeTo: .title)
		public static let title2: Font = Font.custom("Michroma-Regular", size: 18, relativeTo: .title2)
		public static let title3: Font = Font.custom("Michroma-Regular", size: 15, relativeTo: .title2)
		public static let body: Font = Font.custom("Michroma-Regular", size: 13, relativeTo: .body)
		public static let subheadline: Font = Font.custom("Michroma-Regular", size: 12, relativeTo: .subheadline)
	}
	
}

public extension Color {
	struct homeworld {
		public static let blue = /*@START_MENU_TOKEN@*/Color(red: 0.378, green: 0.645, blue: 0.979)/*@END_MENU_TOKEN@*/
		public static let background = Color(red: 0.051, green: 0.090, blue: 0.157)
	}
}
