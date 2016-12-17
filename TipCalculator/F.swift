//
//  F.swift
//  TipCalculator
//
//  Created by Thomas Zhu on 12/13/16.
//  Copyright © 2016 Thomas Zhu. All rights reserved.
//

import Foundation

struct F {
    
    struct NumberFormat {
        
        static let currency: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale.current
            return formatter
        }()
        
        static let percentage: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            formatter.numberStyle = .percent
            return formatter
        }()
        
        static let integer: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 0
            return formatter
        }()
    }
}
