//
//  C.swift
//  TipCalculator
//
//  Created by Thomas Zhu on 12/13/16.
//  Copyright © 2016 Thomas Zhu. All rights reserved.
//

import Foundation

class C {
    
    enum TipIncludedPhase: String {
        case Included = "[X] tip included"
        case NotIncluded = "[ ] tip included"
    }
    
    static let maxDisplayDigits = 20
    static let tipPercentageIncrement = 0.005
    
    enum SettingKeys: String {
        case PoorServicePercentage = "poor_pct"
        case FineServicePercentage = "fine_pct"
        case GreatServicePercentage = "great_pct"
        case DefaultTipPercentage = "default_tip_pct"
    }
    
    static let dataExpirationTime: Double = 10 * 60; // in seconds
    
    enum PersistenceKeys: String {
        case ResultTime = "current_time"
        case BillAmount = "bill_amount"
    }
    
    static let viewAppeared = "view_appeared"
}
