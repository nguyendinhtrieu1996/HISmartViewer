//
//  TabBarICons.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/23/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

enum IconTabar: Int {
    
    case all = -1, newFeed, notice, playList
    
    static let titles = ["Đồ thị", "Kết quả", "Thống kê", "Chẩn đoán", "Đơn thuốc"]
    static let images = [#imageLiteral(resourceName: "chart_line"), #imageLiteral(resourceName: "result"), #imageLiteral(resourceName: "chart_arc"), #imageLiteral(resourceName: "diagnostic"), #imageLiteral(resourceName: "medical")]
    
    static func getIcons()->[Icon] {
        return IconTabar.titles.enumerated().map({ (index, value) -> Icon in
            return Icon.init(value, image: images[index])
        })
    }
    
}

