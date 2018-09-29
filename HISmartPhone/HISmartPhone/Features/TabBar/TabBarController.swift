//
//  TabarController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/23/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class TabBarController: ESTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBar = self.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
            tabBar.backgroundColor = Theme.shared.primaryColor
            tabBar.backgroundImage = UIImage()
        }
        
        let icons = IconTabar.getIcons()
        
        //CHART
        let chartNavigationController = UINavigationController(rootViewController: ChartController())
        chartNavigationController.tabBarItem = ESTabBarItem.init(ExampleHighlightableContentView(),
                                                                 title: icons[0].title,
                                                                 image: icons[0].image.withRenderingMode(.alwaysOriginal),
                                                                 tag: 0)
        
        //BLOOD PRESSURE
        let resultBloodPressureNV = UINavigationController(rootViewController: ResultBloodPressureController())
        resultBloodPressureNV.tabBarItem = ESTabBarItem.init(ExampleHighlightableContentView(), title: icons[1].title,
                                                             image: icons[1].image.withRenderingMode(.alwaysOriginal),
                                                             tag: 1)
        
        //STATISTICS
        
        let statisticsNV = UINavigationController(rootViewController: StatisticsController())
        statisticsNV.tabBarItem = ESTabBarItem.init(ExampleHighlightableContentView(), title: icons[2].title,
                                                    image: icons[2].image.withRenderingMode(.alwaysOriginal),
                                                    tag: 2)
        
        //DIAGNOSE
        let diagnoseNV = UINavigationController(rootViewController: DiagnoseController())
        diagnoseNV.tabBarItem = ESTabBarItem.init(ExampleHighlightableContentView(), title: icons[3].title,
                                                  image: icons[3].image.withRenderingMode(.alwaysOriginal),
                                                  tag: 3)
        
        //PRESCRIPTION
        let prescriptionNV = UINavigationController(rootViewController: PrescriptionController())
        prescriptionNV.tabBarItem = ESTabBarItem.init(ExampleHighlightableContentView(), title: icons[4].title,
                                                      image: icons[4].image.withRenderingMode(.alwaysOriginal),
                                                      tag: 4)
        
        self.viewControllers = [chartNavigationController, resultBloodPressureNV, statisticsNV, diagnoseNV, prescriptionNV]
    }
    
}


