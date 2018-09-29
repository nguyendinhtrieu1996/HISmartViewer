//
//  ExtensionAttributedString.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/1/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
//    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
//        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: 12)!]
//        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
//        append(boldString)
//
//        return self
//    }
    
    @discardableResult func normal(_ text: String, textColor: UIColor, fontSize: CGFloat, weight: UIFont.Weight = .regular, alpha: CGFloat = 1) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: fontSize, weight: weight), .foregroundColor: textColor.withAlphaComponent(alpha)]
        let normalString = NSMutableAttributedString(string: text, attributes: attrs)
        append(normalString)
        
        return self
    }
}
