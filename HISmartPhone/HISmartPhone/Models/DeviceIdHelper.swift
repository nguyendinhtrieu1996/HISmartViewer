//
//  DeviceIdHelper.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 5/5/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class DeviceIDHelper {
    
    static func getParams(_ user: User, _ type: TypeUser) -> [String: Any] {
        var params = [String: Any]()
        
        if type == .patient {
            params["PID_ID"] = user.userID
            params["UserID"] = Constant.autoID
            params["DeviceID"] = HISMartManager.share.deviceToken ?? ""
        } else {
            params["PID_ID"] = Constant.autoID
            params["UserID"] = user.userID
            params["DeviceID"] = HISMartManager.share.deviceToken ?? ""
        }
        
        return params
    }
    
    static func getParamsRemoveToken() -> [String: Any] {
        var params = [String: Any]()
        
        if Authentication.share.typeUser == .patient {
            params["PID_ID"] = Authentication.share.currentUser?.userID ?? ""
            params["UserID"] = Constant.autoID
            params["DeviceID"] = ""
        } else {
            params["PID_ID"] = Constant.autoID
            params["UserID"] = Authentication.share.currentUser?.userID ?? ""
            params["DeviceID"] = ""
        }
        
        return params
    }
}






