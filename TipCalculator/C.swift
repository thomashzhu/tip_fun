//
//  C.swift
//  TipCalculator
//
//  Created by Thomas Zhu on 12/13/16.
//  Copyright © 2016 Thomas Zhu. All rights reserved.
//

import Foundation

class C {
    
    enum TipsIncludedPhase: String {
        case Included = "[X] tips included"
        case NotIncluded = "[ ] tips included"
    }
    
    static let maxDisplayDigits = 20
    static let tipPercentageIncrement = 0.005
    
    enum SettingKeys: String {
        case PoorServicePercentage = "poor_pct"
        case FineServicePercentage = "fine_pct"
        case GreatServicePercentage = "great_pct"
        case DefaultTipPercentage = "default_tip_pct"
    }
}
