//
//  Dimension.swift
//  HISmartPhone
//
//  Created by MACOS on 12/18/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class Dimension {
    class var shared: Dimension {
        struct Static {
            static var instance = Dimension()
        }
        return Static.instance
    }
    
    var widthScreen: CGFloat = 1.0
    var heightScreen: CGFloat = 1.0
    var widthScale: CGFloat = 1.0
    var heightScale: CGFloat = 1.0

    private init() {
        self.widthScale = UIScreen.main.bounds.width / 375
        self.heightScale = UIScreen.main.bounds.height / 667
        self.widthScreen = UIScreen.main.bounds.width
        self.heightScreen = UIScreen.main.bounds.height
        
        if self.widthScale >= 2.0 {
            self.widthScale /= 1.4
            self.heightScale /= 1.4
        }
        
    }
    
    //MARK: Font size
    var headlineFontSize: CGFloat {
        return 24 * self.heightScale
    }
    
    var titleFontSize: CGFloat {
        return 20 * self.heightScale
    }
    
    var bodyFontSize: CGFloat {
        return 16 * self.heightScale
    }
    
    var captionFontSize: CGFloat {
        return 14 * self.heightScale
    }
    
    var smallCaptionFontSize: CGFloat {
        return 13 * self.heightScale
    }
    
    var titleButtonFontSize: CGFloat {
        return 14 * self.heightScale
    }
    
    var messageFontSize: CGFloat {
        return 16 * self.heightScale
    }
    
    //MARK: Spacing
    var smallHorizontalMargin: CGFloat {
        return 4 * self.widthScale
    }
    
    var smallVerticalMargin: CGFloat {
        return 4 * self.widthScale
    }
    
    var mediumHorizontalMargin: CGFloat {
        return 8 * self.widthScale
    }
    
    var mediumVerticalMargin: CGFloat {
        return 8 * self.widthScale
    }
    
    var normalHorizontalMargin: CGFloat {
        return 16 * self.widthScale
    }
    
    var normalVerticalMargin: CGFloat {
        return 16 * self.widthScale
    }
    
    var largeHorizontalMargin: CGFloat {
        return 24 * self.widthScale
    }
    
    var largeVerticalMargin: CGFloat {
        return 24 * self.widthScale
    }
    
    var largeHorizontalMargin_32: CGFloat {
        return 32 * self.widthScale
    }
    
    var largeVerticalMargin_32: CGFloat {
        return 32 * self.widthScale
    }
    
    var largeVerticalMargin_38: CGFloat {
        return 42 * self.widthScale
    }
    
    var largeHorizontalMargin_42: CGFloat {
        return 42 * self.widthScale
    }
    
    var largeVerticalMargin_42: CGFloat {
        return 42 * self.widthScale
    }
    
    var largeHorizontalMargin_56: CGFloat {
        return 56 * self.widthScale
    }
    
    var largeVerticalMargin_56: CGFloat {
        return 56 * self.widthScale
    }
    
    var largeHorizontalMargin_60: CGFloat {
        return 60 * self.widthScale
    }
    
    var largeVerticalMargin_60: CGFloat {
        return 60 * self.widthScale
    }
    
    var largeHorizontalMargin_90: CGFloat {
        return 90 * self.widthScale
    }
    
    var largeVerticalMargin_90: CGFloat {
        return 90 * self.widthScale
    }
    
    var largeHorizontalMargin_120: CGFloat {
        return 120 * self.widthScale
    }
    
    var largeVerticalMargin_120: CGFloat {
        return 120 * self.widthScale
    }
    
    //MARK: Button
    var defaultHeightButton: CGFloat {
        return 42 * self.heightScale
    }
    
    var largeWidthButton: CGFloat {
        return 291 * self.widthScale
    }
    
    var mediumWidthButton: CGFloat {
        return 195 * self.widthScale
    }
    
    var heightButtonAlert: CGFloat {
        return 36 * self.heightScale
    }
    
    var widthButtonAlert: CGFloat {
        return 190 * self.widthScale
    }
    
    var floatButtonHeight: CGFloat {
        return 56 * self.heightScale
    }
    
    var widthOptionButton: CGFloat {
        return 40 * self.widthScale
    }
    
    var heightOptionButton: CGFloat {
        return 30 * self.heightScale
    }
    
    var widthCancelButton: CGFloat {
        return 45 * self.widthScale
    }
    
    var heightCancelButton: CGFloat {
        return 25 * self.heightScale
    }
    
    //MARK: Other
    var widthImageLogo: CGFloat {
        return 94 * self.widthScale
    }
    
    var heightImageLogo: CGFloat {
        return 42 * self.heightScale
    }
    
    var heightLineDivider: CGFloat {
        return 1 * self.heightScale
    }
    
    var largeHeightNVBar: CGFloat {
        return 79
    }
    
    var widthStatusCircle: CGFloat {
        return 15 * self.widthScale
    }
    
    var smallCornerRadius: CGFloat {
        return 4 * self.heightScale
    }
    
    var mediumCornerRadius: CGFloat {
        return 6 * self.heightScale
    }
    
    var normalCornerRadius: CGFloat {
        return 8 * self.heightScale
    }
    
    var superCornerRadius: CGFloat {
        return 20 * self.heightScale
    }
    
    var widthOptionMenu: CGFloat {
        return 280 * self.widthScale
    }
    
    var topMarginOptionMenu: CGFloat {
        return 53 * self.heightScale
    }
    
    var widthFloatButton: CGFloat {
        return 75 * self.heightScale
    }
    
    var heightPatientInfoResult: CGFloat {
        return 77 * self.heightScale
    }
    
    var widthAlertDeleteDiagnose: CGFloat {
        return 254 * self.widthScale
    }
    
    var largeWidthAlertAnnoucement: CGFloat {
        return 311 * self.widthScale
    }
    
    var heightAlertDeleteDiagnose: CGFloat {
        return 235 * self.heightScale
    }
    
    var heightExtendNavigationBar: CGFloat {
        return 55 * self.heightScale
    }
    
    var widthChartView: CGFloat {
        return 363 * self.widthScale
    }
    
    //MARK: Textfield
    var widthTextfieldDOB: CGFloat {
        return 100 * self.widthScale
    }
    
    var widthTextfieldCity: CGFloat {
        return 125 * self.widthScale
    }
    
    var widthFROMANDTOTextField: CGFloat {
        return 132 * self.widthScale
    }
    
    var defaultHeightTextField: CGFloat {
        return 35 * self.heightScale
    }
    
    //MARK: SIDE MENU
    var widthSideMenu: CGFloat {
        return 300 * self.widthScale
    }
    
    var widthUserImage: CGFloat {
        return 40 * self.heightScale
    }
    
    var widthIconSideMenu: CGFloat {
        return 24 * self.widthScale
    }
    
    var heightIconSideMenu: CGFloat {
        return 18 * self.heightScale
    }
    
    var heightNoticeIcon: CGFloat {
        return 16 * self.heightScale
    }
    
    //MARK: Segment
    var widthCustomSegment: CGFloat {
        return 327 * self.widthScale
    }
    
    var heightCustomSegment: CGFloat {
        return 36 * self.heightScale
    }
    
    //MARK: Message
    var widthMessage: CGFloat {
        return 265 * self.widthScale
    }
    
    var edgeInsetLabel: CGFloat {
        return 10 * self.heightScale
    }
    
    //MARK: SEARCH
    var heightContainsViewSearchBar: CGFloat {
        return 50 * self.heightScale
    }
    
    var heightSearchBar: CGFloat {
        return 45 * self.heightScale
    }
    
    //MARK: CHART
    var heightPieChart: CGFloat {
        return 311 * self.heightScale
    }
    
}














