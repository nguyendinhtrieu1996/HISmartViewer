//
//  File.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/30/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

@IBDesignable class InsetLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    var insets: UIEdgeInsets {
        get {
            return UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset)
        }
        set {
            topInset = newValue.top
            leftInset = newValue.left
            bottomInset = newValue.bottom
            rightInset = newValue.right
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        
        let textWidth = self.frame.size.width - (self.leftInset + self.rightInset)
        let newSize = self.text?.boundingRect(with: CGSize(width: textWidth,
                                                           height: CGFloat.greatestFiniteMagnitude),
                                              
                                              options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                              attributes: [NSAttributedStringKey.font: self.font],
                                              context: nil)
        intrinsicSuperViewContentSize.height = ceil(newSize?.size.height ?? 0) + self.topInset + self.bottomInset
        
        return intrinsicSuperViewContentSize
    }
    
}

