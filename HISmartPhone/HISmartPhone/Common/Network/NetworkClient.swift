//
//  ExtensionUIView.swift
//  HISmartPhone
//
//  Created by MACOS on 12/20/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit
import Alamofire

class NetworkClient {
    
    static func request(urlRequest: String, method: HTTPMethod, parameter: [String: Any]?, completion: @escaping (Data?)->Void) {
        guard let url = URL(string: urlRequest) else {
            completion(nil)
            return
        }
        
        var endcoding: URLEncoding
        
        if method == .post || method == .delete {
            endcoding = .httpBody
        } else {
            endcoding = .default
        }
        
        Alamofire.request(url, method: method, parameters: parameter, encoding: endcoding, headers: nil).responseData { (response) in
            completion(response.data)
        }
        
    }

}















