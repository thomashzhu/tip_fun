//
//  Operators.swift
//  TipCalculator
//
//  Created by Thomas Zhu on 12/16/16.
//  Copyright © 2016 Thomas Zhu. All rights reserved.
//

import Foundation

infix operator ~=

func ~= (a: Double, b: Double) -> Bool {
    return fabs(a - b) < Double(FLT_EPSILON)
}
