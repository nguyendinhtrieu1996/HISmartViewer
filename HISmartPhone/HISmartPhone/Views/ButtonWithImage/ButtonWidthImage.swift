//
//  ButtonWidthImage.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/27/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class ButtonWidthImage: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String, image: String, widthImage: CGFloat, fontSize: CGFloat) {
        self.init()
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.setImage(UIImage(named: image), for: .normal)
        let widthText = (title as NSString).size(withAttributes: [NSAttributedStringKey.font:self.titleLabel!.font!]).width
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: widthText + 3 * widthImage, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -4 * widthImage, bottom: 0, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



