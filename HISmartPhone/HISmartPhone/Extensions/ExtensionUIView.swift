//
//  ExtensionUIView.swift
//  HISmartPhone
//
//  Created by MACOS on 12/20/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

extension UIView {
    
    func makeShadow(color: UIColor, opacity: Float, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = radius
    }
    
}
