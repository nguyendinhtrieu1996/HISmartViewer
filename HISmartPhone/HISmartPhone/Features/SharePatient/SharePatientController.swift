//
//  SharePatientController.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 12/31/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import Foundation
import BetterSegmentedControl

enum ShareType: UInt{
    case Shared =  0
    case BeShared = 1
}

// This view display patients shared and were shared
class SharePatientController: BaseViewController {
    
    // MARK: Variable
    private let sharePatientFacade = SharePatientFacade()
    
    var shareType: ShareType? {
        willSet {
            guard let value = newValue else {
                return
            }
            
            do {
                try self.betterSegment.setIndex(value.rawValue, animated: true)
            } catch {
                //
            }
            
            self.sharedContentView.isHidden = value == .BeShared
            self.beSharedContentView.isHidden = value == .Shared
        }
    }
    
    //MARK: UIControl
    fileprivate let betterSegment: BetterSegmentedControl = {
        let titles = ["Đã chia sẻ", "Được chia sẻ"]
        let options: [BetterSegmentedControlOption] =
            [.backgroundColor(Theme.shared.primaryColor),
             BetterSegmentedControlOption.cornerRadius(Dimension.shared.heightCustomSegment / 2),
             BetterSegmentedControlOption.indicatorViewBackgroundColor(Theme.shared.defaultBGColor),
             BetterSegmentedControlOption.titleFont(UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)),
             BetterSegmentedControlOption.titleColor(Theme.shared.defaultTextColor),
             BetterSegmentedControlOption.selectedTitleColor(Theme.shared.primaryColor)]
        
        let segment = BetterSegmentedControl(frame: .zero, titles: titles, index: 0, options: options)
        segment.addTarget(self, action: #selector(handleSegmentControl(_:)), for: .valueChanged)
        return segment
    }()
    
    fileprivate let sharedContentView: SharePatientContentView = SharePatientContentView(shareType: .Shared)
    fileprivate let beSharedContentView: SharePatientContentView = SharePatientContentView(shareType: .BeShared)
    
    //MARK: Initialize
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.tintColor = Theme.shared.defaultBGColor
        self.navigationController?.navigationBar.barTintColor = Theme.shared.primaryColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchData()
    }
    
    override func setupView() {
        self.definesPresentationContext = true
        self.extendedLayoutIncludesOpaqueBars = true
        self.setupViewNavigationBar()
        self.setTitle()
        self.setupViewCustomSegment()
        self.setupSharePatientContentView()
    }
    
    //MARK: Handle Action
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSegmentControl(_ sender: BetterSegmentedControl) {
        guard let type = ShareType.init(rawValue: sender.index) else {
            return
        }
        
        self.shareType = type
    }
    
    @objc func handleFloatButton() {
        let newMessageController = NewMessageController()
        newMessageController.typeNewMessage = .newMesagge
        self.navigationController?.pushViewController(newMessageController, animated: true)
    }
    
    //MARK: SetupView
    private func setupViewNavigationBar() {
        //BACK ITEM
        self.navigationItem.addLeftBarItem(with: UIImage(named: "back_white"),
                                           target: self,
                                           selector: #selector(handleBackButton),
                                           title: nil)
    }
    
    private func setTitle() {
        let nameLabel = UILabel()
        nameLabel.text = "Danh sách bệnh nhân chia sẻ"
        nameLabel.textColor = Theme.shared.defaultTextColor
        nameLabel.frame = CGRect(x: 0, y: 0, width: 130, height: 30)
        nameLabel.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize,
                                           weight: UIFont.Weight.medium)
        
        self.navigationItem.titleView = nameLabel
    }
    
    private func setupViewCustomSegment() {
        self.view.addSubview(self.betterSegment)
        
//        if #available(iOS 11, *) {
//            self.betterSegment.snp.makeConstraints { (make) in
//                make.width.equalTo(Dimension.shared.widthCustomSegment)
//                make.height.equalTo(Dimension.shared.heightCustomSegment)
//                make.centerX.equalToSuperview()
//                make.top.equalTo(self.view.safeAreaInsets.top)
//                    .offset(Dimension.shared.normalVerticalMargin)
//            }
//        } else {
//            self.betterSegment.snp.makeConstraints { (make) in
//                make.width.equalTo(Dimension.shared.widthCustomSegment)
//                make.height.equalTo(Dimension.shared.heightCustomSegment)
//                make.centerX.equalToSuperview()
//                make.top.equalTo(self.topLayoutGuide.snp.bottom)
//                    .offset(Dimension.shared.normalVerticalMargin)
//            }
//        }
        
        self.betterSegment.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.widthCustomSegment)
            make.height.equalTo(Dimension.shared.heightCustomSegment)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
                .offset(Dimension.shared.normalVerticalMargin)
        }
    
    }
    
    private func setupSharePatientContentView() {
        // SharedContentView
        self.view.addSubview(self.sharedContentView)
        self.sharedContentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.betterSegment.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            
        }
        self.sharedContentView.delegate = self
        
        // BeSharedContentView
        self.view.addSubview(self.beSharedContentView)
        self.beSharedContentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.betterSegment.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        self.beSharedContentView.delegate = self
    }
    
    // MARK: Fetch data
    fileprivate func fetchData() {
        self.sharePatientFacade.fetchListOfSharedPatient { (list) in
            let predicate = { (element: SharePatientByDoctor) in
                return element.patientID
            }
            let dictionary = Dictionary(grouping: list, by: predicate)
            var patients: [SharedPatient] = []
            
            for dic in dictionary {
                patients.append(SharedPatient(id: dic.key, sharePatientByDoctors: dic.value))
            }
            self.sharedContentView.sharedPatients = patients
        }
        self.sharePatientFacade.fetchListOfBeSharePatient { (list) in
            self.beSharedContentView.patients = list
        }
    }
}

//MARK: - UISearchResultsUpdating
extension SharePatientController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

//MARK: - UISearchControllerDelegate
extension SharePatientController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
    }
}

extension SharePatientController: SharePatientContentDelegate {
    
    func didSelectPatient(_ patientShare: Patient) {
        HISMartManager.share.setCurrentPatient(patientShare)
        BPOChartManager.shared.BPOResults.removeAll()
        BPOHelper.shared.BPOResults.removeAll()
        HISMartManager.share.updateIsShowTabbarFromSharedVC()
        
        let tabbarController = TabBarController()
        
        self.present(tabbarController, animated: true, completion: nil)
    }
    
    func showNoteAlert() {
        let alert = NoteAlertController()
        self.present(alert, animated: true, completion: nil)
    }
    
    func showUnSharedAlert(sharedPatient: SharedPatient?) {
        let alert = UnSharedAlertController()
        alert.sharedPatient = sharedPatient
        alert.delegate = self
        self.present(alert, animated: true, completion: nil)
    }
}

extension SharePatientController: UnSharedAlertDelegate {
    func confirmUnshare(patientID: String, doctorsID: [String]) {
        self.sharePatientFacade.removeSharePatientToDoctor(patientID, toDoctorID: doctorsID, completion: { (bool) in
            if !bool {
                return
            }
            self.fetchData()
        })
    }
}

