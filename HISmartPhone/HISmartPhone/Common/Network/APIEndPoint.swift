//
//  ExtensionUIView.swift
//  HISmartPhone
//
//  Created by MACOS on 12/20/17.
//  Copyright © 2017 MACOS. All rights reserved.
//


import UIKit

class APIEndpoint {
    
    //MARK: - LOGIN & REGISTER
    public static let login = Constant.baseURL + "Login"
    public static let patientRegister = Constant.baseURL + "Patients"
    public static let address = Constant.baseURL + "Address"
    public static let fetchAllDoctor = Constant.baseURL + "Users"
    public static let fetchPatientByDoctor = Constant.baseURL + "GetPatientByUserID"
    public static let fetchUserByID = Constant.baseURL + "users"
    public static let logout = Constant.baseURL + "Logout"

    //MARK: - INFOMATION
    public static let infoPatient = Constant.baseURL + "Patients"
    public static let fetchAllPartnerChat = Constant.baseURL + "GetDataByID"
    public static let FetchDoctorsByPatientID = Constant.baseURL + "GetListUserShareByPIDID"
    public static let ShareDoctorsByPatientID = Constant.baseURL + "Share"
    public static let FetchPatientSharedByDoctorID = Constant.baseURL + "ListPatientShareByCurrentUser"
    public static let FetchPatientBeSharedByDoctorID = Constant.baseURL + "GetListUserPatientShared"
    public static let RemovePatientShareToDoctorID = Constant.baseURL + "Share"
    public static let getUserByPatient = Constant.baseURL + "GetUserByPatientID"
    
    //MARK: - PRESCRIPTIONS
    public static let prescriptionsAPI = Constant.baseURL + "Prescriptions"
    public static let getDrugOfPrescription = Constant.baseURL + "GetPreScriptionByPrescriptionCode"
    
    //MARK: - DIAGNOSE
    public static let diagnoseAPI = Constant.baseURL + "diagnosis"
    
    //MARK: - BLOOD PRESSURE
    public static let bloodPressureAPI = Constant.baseURL + "BPOResult"
    public static let bloodPressureContantAPI = Constant.baseURL + "GetBPOPatientByPIDID"
    public static let GETBPOPatientByDate = Constant.baseURL + "GetBPOPatientByDate"
    public static let UpdatePatientBloodPressureWarning = Constant.baseURL + "HealthRecord"
    
    //MARK: - CHAT MESSAGE
    public static let chatMessageAPI = Constant.baseURL + "ChatMessage"
    public static let getlistDoctorChat = Constant.baseURL + "GetListDoctor"
    public static let getListDoctorByPIDID = Constant.baseURL + "GetListDoctorByPIDID"
    
    //MARK: - Push Notification
    public static let sendToken = Constant.baseURL + "SaveDeviceId"
}










