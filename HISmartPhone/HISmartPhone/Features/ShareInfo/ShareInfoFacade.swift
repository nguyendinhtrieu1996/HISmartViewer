//
//  ShareInfoFacade.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/21/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

class ShareInfoFacade {
    private (set) var doctors: [User]
    private var selectedDoctors: User!
    
    init() {
        self.doctors = []
    }
    
    func fetchShareDoctors(_with patientID: String, completionHandler: @escaping ([User]) -> Void) {
        let parameter = ["id": patientID]
        NetworkClient.request(urlRequest: APIEndpoint.FetchDoctorsByPatientID, method: .get, parameter: parameter) { (data) in
            self.doctors = ParserHelper.parseArrayObject(data)
            completionHandler(self.doctors)
        }
    }
    
    func setSelectedDoctor(doctor: User) {
        self.selectedDoctors = doctor
    }
    
    func SharePatientToDoctor(completion: @escaping (Bool) -> Void) {
        if selectedDoctors == nil {
            completion(false)
        }
        
        let patient = HISMartManager.share.currentPatient
        let doctor = HISMartManager.share.currentDoctor
        let parameter = [
            "PID_ID": patient.PID_ID,
            "sUserID": self.selectedDoctors.userID
        ]
        
        NetworkClient.request(urlRequest: APIEndpoint.ShareDoctorsByPatientID, method: .post, parameter: parameter) { (data) in
            if let result = String.init(data: data!, encoding: String.Encoding.utf8) {
                if result == "\"success\"" {
                    SharePatientFirebaseAPI.POST_Patient(self.selectedDoctors.userID, doctorShareName: doctor.fullName, patient: patient)
                    completion(true)
                }
            }
            
            completion(false)
        }
    }
}
