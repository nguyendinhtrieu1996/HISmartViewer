//
//  ExtensionUILabel.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/29/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

extension UILabel {
    
    internal func setMultableAttributedText(title: String, sizeTitle: CGFloat, content: String, sizeContent: CGFloat, color: UIColor = Theme.shared.darkBlueTextColor) {
        let attributedText = NSMutableAttributedString()
        
        let titleAttribute = [NSAttributedStringKey.foregroundColor: color,
                              NSAttributedStringKey.font: UIFont.systemFont(ofSize: sizeTitle,
                                                                            weight: UIFont.Weight.medium)]
        
        let contentAttribute = [NSAttributedStringKey.foregroundColor: color,
                              NSAttributedStringKey.font: UIFont.systemFont(ofSize: sizeTitle)]
        
        let titleText = NSMutableAttributedString.init(string: title, attributes: titleAttribute)
        let contentText = NSMutableAttributedString.init(string: content, attributes: contentAttribute)
        
        attributedText.append(titleText)
        attributedText.append(contentText)
        
        self.attributedText = attributedText
    }
    
    internal func setMutableTextColorWithSlash(titles: [String], colors: [UIColor], fontSize: CGFloat) {
        let attributedString = NSMutableAttributedString()
        
        for (index, title) in titles.enumerated() {
            let titleAttribute = [NSAttributedStringKey.foregroundColor: colors[index],
                                  NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)]
            
            let titleText = NSMutableAttributedString.init(string: title, attributes: titleAttribute)
            
            attributedString.append(titleText)
            
            if index != titles.count - 1 {
                let slashAttribute = [NSAttributedStringKey.foregroundColor: Theme.shared.grayTextColor,
                                      NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)]
                
                let slashText = NSMutableAttributedString.init(string: " / ", attributes: slashAttribute)
                
                attributedString.append(slashText)
            }
            
        }
        
        self.attributedText = attributedString
    }
    
}
