
//
//  RegisterFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/9/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class RegisterFacade {
    
    static func fetchAllAddress(completion: @escaping ([Address])->Void, error: @escaping ()->Void) {
        NetworkClient.request(urlRequest: APIEndpoint.address, method: .get, parameter: nil) { (data) in
            guard let data = data else {
                error()
                return
            }
            
            let listAddress: [Address] = ParserHelper.parseArrayObject(data)
            completion(listAddress)
        }
    }
    
}
