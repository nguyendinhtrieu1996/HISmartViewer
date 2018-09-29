//
//  ExtensionString.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/1/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

extension String {
    
    func estimateFrameForText(maxWidth: CGFloat, fontSize: CGFloat) -> CGRect {
        let size = CGSize(width: maxWidth, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)],
                                                   context: nil)
    }
    
    func getDate() -> Date {
        let date = self.subStringWithFormatDate()
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formater.date(from: date) ?? Date()
    }
    
    func subStringWithFormatDate() -> String {
        guard let index = self.index(of: ".") else { return self }
        return String(self.prefix(upTo: index))
    }
    
    func appendSlashCharacter(_ string: String) -> String {
        return self + "/" + string
    }
    
}
