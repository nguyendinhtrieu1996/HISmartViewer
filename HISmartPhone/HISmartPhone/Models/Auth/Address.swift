//
//  Address.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/9/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class Address: Mapper {
    
    private (set) var addressID: Int
    private (set) var street: String
    private (set) var otherDestination: String
    private (set) var city: String
    private (set) var province: String
    private (set) var postalCode: String
    private (set) var countryID: String
    private (set) var addressTypeID: String
    
    init() {
        self.addressID = 0
        self.street = ""
        self.otherDestination = ""
        self.city = ""
        self.province = ""
        self.postalCode = ""
        self.countryID = ""
        self.addressTypeID = ""
    }
    
    required init(_ data: [String : Any]) {
        self.addressID = data["Address_ID"] as? Int ?? 0
        self.street = data["Street"] as? String ?? ""
        self.otherDestination = data["Other_Destination"] as? String ?? ""
        self.city = data["City"] as? String ?? ""
        self.province = data["Province"] as? String ?? ""
        self.postalCode = data["Postal_Code"] as? String ?? ""
        self.countryID = data["Country_ID"] as? String ?? ""
        self.addressTypeID = data["Address_Type_ID"] as? String ?? ""
    }
    
    func getDescription() -> String {
        return "\(self.street) - \(self.otherDestination) - \(self.city)"
    }
}
