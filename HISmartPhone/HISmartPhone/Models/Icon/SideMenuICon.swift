//
//  SideMenuICon.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/22/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

enum ChildSideMenu: String {
    case account = "Thông tin tài khoản"
    case listPatient = "Danh sách bệnh nhân"
    case message = "Hộp thư tin nhắn"
    case shared = "Danh sách đã chia sẻ"
    case sharedToPatient = "Danh sách được chia sẻ"
    case sigout = "Đăng xuất"
}

class SideMenuIcon {
    
    private (set) var icons = Icon()
    private (set) var childMenu = ChildSideMenu.account
    
    init(icons: Icon, childMenu: ChildSideMenu) {
        self.icons = icons
        self.childMenu = childMenu
    }
    
    static func getIcon() -> [SideMenuIcon] {
        var sideMenuIcons = [SideMenuIcon]()
        
        guard let typeUser = Authentication.share.typeUser else { return sideMenuIcons }
        var titles: [String]
        var images: [UIImage]
        
        switch typeUser {
        case .doctor:
            titles = [ChildSideMenu.account.rawValue,
                      ChildSideMenu.listPatient.rawValue,
                      ChildSideMenu.message.rawValue,
                      ChildSideMenu.shared.rawValue,
                      ChildSideMenu.sharedToPatient.rawValue,
                      ChildSideMenu.sigout.rawValue]
            
            images = [#imageLiteral(resourceName: "account_details"), #imageLiteral(resourceName: "list_patient"), #imageLiteral(resourceName: "message_box"), #imageLiteral(resourceName: "list_patient_shared"), #imageLiteral(resourceName: "list_patient_shared to"), #imageLiteral(resourceName: "exit_to_app")]
            
            for i in 0..<titles.count {
                let icon = Icon.init(titles[i], image: images[i])
                let child = ChildSideMenu.init(rawValue: icon.title) ?? ChildSideMenu.account
                let sideMenuIcon = SideMenuIcon(icons: icon, childMenu: child)
                sideMenuIcons.append(sideMenuIcon)
            }
            
            if HISMartManager.share.isListPatientVC {
                sideMenuIcons.remove(at: 1)
                sideMenuIcons[1].icons.setIsMessageIcon(true)
            } else {
                sideMenuIcons[2].icons.setIsMessageIcon(true)
            }
            
            break
        case .patient:
            titles = [ChildSideMenu.account.rawValue,
                      ChildSideMenu.message.rawValue,
                      ChildSideMenu.sigout.rawValue]
            
            images = [#imageLiteral(resourceName: "account_details"), #imageLiteral(resourceName: "message_box"), #imageLiteral(resourceName: "exit_to_app")]
            
            for i in 0..<titles.count {
                let icon = Icon.init(titles[i], image: images[i])
                let child = ChildSideMenu.init(rawValue: icon.title) ?? ChildSideMenu.account
                let sideMenuIcon = SideMenuIcon(icons: icon, childMenu: child)
                sideMenuIcons.append(sideMenuIcon)
            }
            
            sideMenuIcons[1].icons.setIsMessageIcon(true)
            
            break
        }

        
        return sideMenuIcons
    }
    
}
