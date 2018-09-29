//
//  ChartFormatter.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/2/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit
import Charts

public class ChartFormatter: NSObject, IAxisValueFormatter {
    var workoutDuration = [String]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if workoutDuration.isEmpty { return "" }
        return workoutDuration[Int(value)]
    }
    
    public func setValue(values: [String]) {
        self.workoutDuration = values
    }
}

