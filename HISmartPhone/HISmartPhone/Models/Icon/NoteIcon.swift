//
//  NoteIcon.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/3/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

enum NoteIcon: Int {
    case all = -1, systolic, diastolic, heartRate, result
    
    static let titles = ["Systolic", "Diastolic", "Heart rate"]
    static let images = [#imageLiteral(resourceName: "SystolicIcon"), #imageLiteral(resourceName: "DiastolicIcon"), #imageLiteral(resourceName: "HeartRateIcon")]
    
    static func getIcons()->[Icon] {
        return NoteIcon.titles.enumerated().map({ (index, value) -> Icon in
            return Icon.init(value, image: images[index])
        })
    }
}
