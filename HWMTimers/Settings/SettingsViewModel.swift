//
//  SettingsViewModel.swift
//  HWMTimers
//
//  Created by Ant Gardiner on 25/09/23.
//

import Foundation
import SwiftUI


class SettingsViewModel: ObservableObject {
	
	//@Published var researchPercentBonus: Int = 0

	@AppStorage(SettingsResearchPercentBonusKey) var researchPercentBonus: Int = 0

}
