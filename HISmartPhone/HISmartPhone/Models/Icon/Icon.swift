//
//  Icon.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/22/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

//This struct is a object icon
struct Icon {
    
    // MARK: Define Variable
    var title: String
    var image: UIImage
    var isMessageIcon: Bool
    
    // MARK: Initialization function
    init() {
        self.title = ""
        self.image = UIImage()
        self.isMessageIcon = false
    }
    
    init(_ title: String, image: UIImage) {
        self.title = title
        self.image = image
        self.isMessageIcon = false
    }
    
    mutating func setIsMessageIcon(_ value: Bool) {
        self.isMessageIcon = value
    }
}

