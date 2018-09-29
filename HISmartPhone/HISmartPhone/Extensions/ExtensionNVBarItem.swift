//
//  ExtensionNVBarItem.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/30/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit


extension UINavigationItem {
    
    func addLeftBarItem(with image: UIImage?, target: Any?, selector: Selector, title: String?) {
        let buttonItem = UIBarButtonItem(image: image ?? UIImage(), style: .plain, target: target, action: selector)
        
        if title != nil {
            let titleItem = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
            self.leftBarButtonItems = [buttonItem, titleItem]
        } else {
            self.leftBarButtonItem = buttonItem
        }
    }
    
    func addRightBarItem(with image: UIImage?, target: Any?, selector: Selector) {
        let buttonItem = UIBarButtonItem(image: image ?? UIImage(), style: .plain, target: target, action: selector)
        
        self.rightBarButtonItem = buttonItem
    }
    
    func addRightBarItems(with titile: String, target: Any?, selector: Selector) {
        let buttonItem = UIBarButtonItem(title: titile, style: .plain, target: target, action: selector)
        self.rightBarButtonItem = buttonItem
    }
    
}
