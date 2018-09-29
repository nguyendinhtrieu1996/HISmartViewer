//
//  ParserHelper.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/8/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

// This protocol containt init for parse json to object
@objc protocol Mapper: class {
    init(_ data: [String: Any])
    @objc optional func setKey(_ key: String)
}

protocol TransfromData {
    func transformDictionaty() -> [String: Any]
}

class ParserHelper {
    
    static func parseObject<T>(_ respone: Data?) -> T? where T: Mapper {
        
        guard let respone = respone else { return nil }
        
        do {
            
            guard let result = try JSONSerialization.jsonObject(with: respone, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else { return nil }
            return T(result)
        } catch {
            return nil
        }
    }
    
    static func parseArrayObject<T>(_ respone: Data?) -> [T] where T: Mapper {
        var array: [T] = []
        
        guard let respone = respone else { return array }
        
        do {
            
            guard let result = try JSONSerialization.jsonObject(with: respone, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String: Any]] else { return [] }
            
            for value in result {
                array.append(T(value))
            }
            
            return array
        } catch {
            return []
        }
    }
    
    static func parseObject<T>(_ respone: DataSnapshot?) -> T? where T: Mapper {
        guard let respone = respone else { return nil }
        guard let dicData = respone.value as? [String: Any] else { return nil }
        let result = T(dicData)
        result.setKey!(respone.key)
        return result
    
    }
    
    static func parseArrayObject<T>(_ respone: DataSnapshot?) -> [T] where T: Mapper {
        var array: [T] = []
        guard let respone = respone else { return array }
        guard let arrayData = respone.value as? [DataSnapshot] else { return array }
        
        for snapshot in arrayData {
            if let dic = snapshot.value as? [String: Any] {
                let result = T(dic)
                result.setKey!(snapshot.key)
                array.append(result)
            }
        }
        
        return array
    }
    
}

