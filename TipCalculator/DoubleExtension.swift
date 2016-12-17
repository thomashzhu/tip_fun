//
//  DoubleExtension.swift
//  TipCalculator
//
//  Created by Thomas Zhu on 12/16/16.
//  Copyright © 2016 Thomas Zhu. All rights reserved.
//

import Foundation

extension Double {
    func roundedTo(toNearest: Double) -> Double {
        return (self / toNearest).rounded() * toNearest
    }
    
    func roundDown(toNearest: Double) -> Double {
        return floor(self / toNearest) * toNearest
    }
    
    func roundUp(toNearest: Double) -> Double {
        return ceil(self / toNearest) * toNearest
    }
}
