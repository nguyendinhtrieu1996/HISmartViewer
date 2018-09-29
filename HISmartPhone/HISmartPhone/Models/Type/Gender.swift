//
//  Gender.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/8/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

enum Gender: Int {
    case male = 0, female
    
    func toString() -> String {
        switch self {
        case .male:
            return "Nam"
        case .female:
            return "Nữ"
        }
    }
}
