//
//  PrescriptionController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/23/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class PrescriptionController: DiagnoseController {
    
    //MARK: Variable
    fileprivate var listPrescription = [Prescription]()
    fileprivate let prescriptionFacade = PrescriptionFacade()
    
    //MARK: Initialize
    override func setupView() {
        super.setupView()
        self.setTitle("Đơn thuốc")
        
        if Authentication.share.typeUser == .doctor {
            self.optionMenu.setOption(images: [#imageLiteral(resourceName: "history"), #imageLiteral(resourceName: "clear_blue")],
                                      title: [                                                                                                 "Xem đơn thuốc gần nhất", "Xoá đơn thuốc"])
        } else {
            self.optionMenu.setOption(images: [#imageLiteral(resourceName: "history")],
                                      title: [                                                                                                 "Xem đơn thuốc gần nhất"])
        }

        self.optionMenu.delegate = self
        self.collectionViewHistory.delegate = self
        self.collectionViewHistory.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name.init(Notification.Name.updateListPrescription), object: nil)
    }
    
    //MARK: Action UIControl
    
    
    //MARK: Feature
    @objc override func fetchData() {
        self.prescriptionFacade.loadAllPrescription {
            self.listPrescription = self.prescriptionFacade.prescriptions
            self.collectionViewHistory.reloadData()
            
            if self.listPrescription.count == 0 {
                self.optionButton.isHidden = true
                self.emptyAnnoucementLabel.isHidden = false
            } else {
                self.optionButton.isHidden = false
                self.emptyAnnoucementLabel.isHidden = true
            }
        }
    }
    
    override func chooseShowDetailVC() {
        let detailPrescriptionVC = DetailPrescriptionController()
        detailPrescriptionVC.prescription = self.listPrescription.first
        self.navigationController?.pushViewController(detailPrescriptionVC, animated: true)
    }
    
    override func chooseShowAddNewVC() {
        let addNewDrugVC = AddNewDrugController()
        addNewDrugVC.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(addNewDrugVC, animated: true)
    }
    
    override func selectedDelete() {
        self.prescriptionFacade.deletePrescription(at: self.selectedIndexPaths) {
            self.fetchData()
            self.selectedIndexPaths.removeAll()
        }
    }
    
}

//MARK: - UICollectionView DELEGATE, DATASOURCE
extension PrescriptionController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listPrescription.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as? DiagnoseCell else { return UICollectionViewCell() }
        
        cell.set(indexPath: indexPath)
        cell.delegate = self
        cell.prescription = self.listPrescription[indexPath.item]
        
        if self.isSelectedAdd {
            cell.showImage(status: .hide)
        } else {
            if self.selectedIndexPaths.contains(indexPath) {
                cell.showImage(status: .on)
            } else {
                cell.showImage(status: .off)
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: Dimension.shared.heightPatientInfoResult)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.optionMenu.hide()
        
        if self.isSelectedAdd {
            let detailPrescriptionVC = DetailPrescriptionController()
            detailPrescriptionVC.prescription = self.listPrescription[indexPath.item]
            self.navigationController?.pushViewController(detailPrescriptionVC, animated: true)
        } else {
            self.addSelectedIndexPath(indexPath: indexPath)
        }
    }
    
}




