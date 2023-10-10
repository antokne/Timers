//
//  Font+Extensions.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 29/08/23.
//

import SwiftUI

extension Font {
	
	struct homeworld {
		static var titleFixed: Font = Font.custom("Michroma-Regular", fixedSize: 22)
		static var title3Fixed: Font = Font.custom("Michroma-Regular", fixedSize: 15)

		static var title: Font = Font.custom("Michroma-Regular", size: 25, relativeTo: .title)
		static var title2: Font = Font.custom("Michroma-Regular", size: 18, relativeTo: .title2)
		static var title3: Font = Font.custom("Michroma-Regular", size: 15, relativeTo: .title2)
		static var body: Font = Font.custom("Michroma-Regular", size: 13, relativeTo: .body)
		static var subheadline: Font = Font.custom("Michroma-Regular", size: 12, relativeTo: .subheadline)
	}
	
}

extension Color {
	struct homeworld {
		static var blue = /*@START_MENU_TOKEN@*/Color(red: 0.378, green: 0.645, blue: 0.979)/*@END_MENU_TOKEN@*/
		static var background = Color(red: 0.051, green: 0.090, blue: 0.157)
	}
}
