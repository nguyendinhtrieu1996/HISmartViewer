//
//  ExtensionDictionary.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/12/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

extension Dictionary {
    func toString() -> String {
        return self.map { (key, value) in
            return "\(key)=\(value)"
            }.joined(separator: "&")
        
    }
}
