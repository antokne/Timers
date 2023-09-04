//
//  Font+Extensions.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 29/08/23.
//

import SwiftUI

extension Font {
	
	struct homeworld {
		
		static var title: Font = Font.custom("Michroma-Regular", size: 25, relativeTo: .title)
		static var title2: Font = Font.custom("Michroma-Regular", size: 18, relativeTo: .title2)
		static var subheadline: Font = Font.custom("Michroma-Regular", size: 12, relativeTo: .subheadline)
	}
	
}

extension Color {
	struct homeworld {
		static var blue = /*@START_MENU_TOKEN@*/Color(red: 0.378, green: 0.645, blue: 0.979)/*@END_MENU_TOKEN@*/
	}
}
