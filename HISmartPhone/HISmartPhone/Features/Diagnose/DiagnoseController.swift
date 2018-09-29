//
//  DiagnoseController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/23/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class DiagnoseController: BaseInfoPatientVC {
    
    //MARK: Variable
    public let cellId = "cellId"
    public var isSelectedAdd = true
    public var selectedIndexPaths = [IndexPath]()
    fileprivate var listDiagnose = [Diagnose]()
    fileprivate let diagnoseFacade = DiagnoseFacade()
    
    public lazy var alertDeleteVC: AlertDeleteController = {
        let alert = AlertDeleteController()
        
        alert.delegate = self
        alert.setMessage("Bạn chắc chắn muốn \n xoá chẩn đoán này")
        
        return alert
    }()
    
    //MARK: UIControl
    lazy var optionMenu: OptionMenu = {
        var menu = OptionMenu()
        
        if Authentication.share.typeUser == .doctor {
            menu.setOption(images: [#imageLiteral(resourceName: "history"),#imageLiteral(resourceName: "clear_blue")],
                           title: [                                                                                                 "Xem chẩn đoán gần nhất", "Xoá chuẩn đoán"])
        } else {
            menu.setOption(images: [#imageLiteral(resourceName: "history")],
                           title: [                                                                                                 "Xem chẩn đoán gần nhất"])
        }
        
        menu.delegate = self
        menu.backgroundColor = Theme.shared.defaultBGColor
        menu.layer.cornerRadius = Dimension.shared.normalCornerRadius
        menu.makeShadow(color: Theme.shared.backgroundColorShadow, opacity: 1.0, radius: 4)
        
        return menu
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Chẩn đoán và hướng dẫn điều trị"
        label.textColor = Theme.shared.primaryColor
        label.font = UIFont.systemFont(ofSize: 18 * Dimension.shared.heightScale)
        
        return label
    }()
    
    private let historyImage: UIImageView = {
        let image = UIImageView()
        
        image.image = UIImage(named: "history_gray")
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    private let historyTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Lịch sử"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    public let optionButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "option"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        if Authentication.share.typeUser == .patient {
            button.isHidden = true
        }
        
        return button
    }()
    
    public let cancelButton: UIButton = {
        let button = UIButton()
        
        button.isHidden = true
        button.setTitle("HUỶ", for: .normal)
        button.setTitleColor(Theme.shared.darkBlueTextColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return button
    }()
    
    public let floatButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "AddIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        if Authentication.share.typeUser == .patient {
            button.isHidden = true
        }
        
        return button
    }()
    
    public lazy var collectionViewHistory  : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Theme.shared.defaultBGColor
        collectionView.register(DiagnoseCell.self, forCellWithReuseIdentifier: self.cellId)
        
        return collectionView
    }()
    
    let emptyAnnoucementLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Không có kết quả nào"
        label.textColor = Theme.shared.darkBlueTextColor
        label.textAlignment = .center
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize)
        
        return label
    }()
    
    //MARK: Initialize
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionViewHistory.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchData()
    }
    
    override func setupView() {
        IQKeyboardManager.sharedManager().enable = true
        
        self.setupViewTitleLabel()
        self.setupViewHistoryImage()
        self.setupViewHitoryTitleLabel()
        self.setupViewOptionButton()
        self.setupViewCancelButton()
        self.setupViewHistoryCollectionViewV()
        self.setupViewFloatButton()
        self.setupViewOptionMenu()
        self.setupViewEmptyAnnoucementLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name.init(Notification.Name.updateListDiagnose), object: nil)
        
    }
    
    //MARK: Action UIControl
    @objc func handleOptionButton() {
        self.optionMenu.showOrHide()
    }
    
    @objc func handleCancelButton() {
        self.isSelectedAdd = true
        self.cancelButton.isHidden = true
        self.selectedIndexPaths.removeAll()
        self.floatButton.setImage(UIImage(named: "AddIcon"), for: .normal)
        self.collectionViewHistory.reloadData()
    }
    
    @objc func handleFloatButton() {
        if self.isSelectedAdd {
            self.chooseShowAddNewVC()
        } else {
            if self.selectedIndexPaths.count > 0 {
                self.present(self.alertDeleteVC, animated: true, completion: nil)
            }
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionViewHistory.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: Feature
    
    @objc func fetchData() {
        self.diagnoseFacade.fetchDiagnoseOfPatient {
            self.listDiagnose = self.diagnoseFacade.diagnoses
            self.collectionViewHistory.reloadData()
            
            if self.listDiagnose.count == 0 {
                self.optionButton.isHidden = true
                self.emptyAnnoucementLabel.isHidden = false
            } else {
                self.optionButton.isHidden = false
                self.emptyAnnoucementLabel.isHidden = true
            }
        }
    }
    
    public func addSelectedIndexPath(indexPath: IndexPath) {
        if !self.selectedIndexPaths.contains(indexPath) {
            self.selectedIndexPaths.append(indexPath)
        } else {
            if let index = self.selectedIndexPaths.index(where: { (i) -> Bool in
                return i.elementsEqual(indexPath)
            }) {
                self.selectedIndexPaths.remove(at: index)
            }
        }
        
        self.collectionViewHistory.reloadData()
    }
    
    public func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    public func chooseShowDetailVC() {
        let detailDiagnoseVC = DetailDiagnoseController()
        detailDiagnoseVC.diagnose = self.listDiagnose.first
        self.navigationController?.pushViewController(detailDiagnoseVC, animated: true)
    }
    
    public func chooseShowAddNewVC() {
        let addNewDiagnoseVC = AddNewDiagnoseController()
        addNewDiagnoseVC.diagnose = Diagnose()
        self.navigationController?.show(addNewDiagnoseVC, sender: nil)
    }
    
    public func selectedDelete() {
        //TO DO: Delete item in array when seleted eccept delete
        self.diagnoseFacade.deleteDiagnose(at: self.selectedIndexPaths) {
            self.fetchData()
            self.selectedIndexPaths.removeAll()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionViewHistory.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: SetupView
    private func setupViewTitleLabel() {
        self.view.addSubview(self.titleLabel)
        
        if #available(iOS 11, *) {
            self.titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.view.safeAreaInsets)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        }
    }
    
    private func setupViewHistoryImage() {
        self.view.addSubview(self.historyImage)
        
        self.historyImage.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom)
                .offset(Dimension.shared.mediumVerticalMargin)
            make.height.width.equalTo(20 * Dimension.shared.widthScale)
        }
    }
    
    private func setupViewHitoryTitleLabel() {
        self.view.addSubview(self.historyTitleLabel)
        
        self.historyTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.historyImage.snp.right)
                .offset(Dimension.shared.normalHorizontalMargin)
            make.top.equalTo(self.historyImage)
        }
    }
    
    private func setupViewOptionButton() {
        self.view.addSubview(self.optionButton)
        
        self.optionButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
            make.top.equalTo(self.titleLabel).offset(Dimension.shared.smallVerticalMargin)
            make.width.equalTo(Dimension.shared.widthOptionButton)
            make.height.equalTo(Dimension.shared.heightOptionButton)
        }
        
        self.optionButton.addTarget(self, action: #selector(handleOptionButton), for: .touchUpInside)
    }
    
    private func setupViewCancelButton() {
        self.view.addSubview(self.cancelButton)
        
        if #available(iOS 11, *) {
            self.cancelButton.snp.makeConstraints { (make) in
                make.width.equalTo(Dimension.shared.widthCancelButton)
                make.height.equalTo(Dimension.shared.heightCancelButton)
                make.right.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(-Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.optionButton.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.cancelButton.snp.makeConstraints { (make) in
                make.width.equalTo(Dimension.shared.widthCancelButton)
                make.height.equalTo(Dimension.shared.heightCancelButton)
                make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.optionButton.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        }
        
        self.cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
    }
    
    private func setupViewHistoryCollectionViewV() {
        self.view.addSubview(self.collectionViewHistory)
        
        if #available(iOS 11, *) {
            self.collectionViewHistory.snp.remakeConstraints { (make) in
                make.centerX.width.equalToSuperview()
                make.top.equalTo(self.cancelButton.snp.bottom)
                make.bottom.equalTo(self.view.safeAreaInsets)
                    .offset(-Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.collectionViewHistory.snp.remakeConstraints { (make) in
                make.centerX.width.equalToSuperview()
                make.top.equalTo(self.cancelButton.snp.bottom)
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                    .offset(-Dimension.shared.normalVerticalMargin)
            }
        }
    }
    
    func setupViewOptionMenu() {
        self.view.addSubview(self.optionMenu)
        
        if #available(iOS 11, *) {
            self.optionMenu.snp.remakeConstraints { (make) in
                make.right.equalTo(self.view.safeAreaLayoutGuide)
                make.top.equalTo(self.historyTitleLabel.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
                make.width.equalTo(Dimension.shared.widthOptionMenu)
                make.height.equalTo(0)
            }
        } else {
            self.optionMenu.snp.remakeConstraints { (make) in
                make.right.equalToSuperview()
                make.top.equalTo(self.historyTitleLabel.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
                make.width.equalTo(Dimension.shared.widthOptionMenu)
                make.height.equalTo(0)
            }
        }
    }
    
    private func setupViewFloatButton() {
        self.view.addSubview(self.floatButton)
        
        if #available(iOS 11, *) {
            self.floatButton.snp.makeConstraints { (make) in
                make.width.height.equalTo(Dimension.shared.widthFloatButton)
                make.right.equalToSuperview().offset(-23 * Dimension.shared.widthScale)
                make.bottom.equalTo(self.view.safeAreaInsets)
                    .offset(-Dimension.shared.largeVerticalMargin_56)
            }
        } else {
            self.floatButton.snp.makeConstraints { (make) in
                make.width.height.equalTo(Dimension.shared.widthFloatButton)
                make.right.equalToSuperview().offset(-23 * Dimension.shared.widthScale)
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                    .offset(-Dimension.shared.largeVerticalMargin)
            }
        }
        
        self.floatButton.addTarget(self, action: #selector(handleFloatButton), for: .touchUpInside)
    }
    
    private func setupViewEmptyAnnoucementLabel() {
        self.view.addSubview(self.emptyAnnoucementLabel)
        
        self.emptyAnnoucementLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DiagnoseController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listDiagnose.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as? DiagnoseCell else { return UICollectionViewCell() }
        
        cell.set(indexPath: indexPath)
        cell.delegate = self
        cell.diagnose = self.listDiagnose[indexPath.item]
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: Dimension.shared.heightPatientInfoResult)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.optionMenu.hide()
        
        if self.isSelectedAdd {
            let detailDiagnoseVC = DetailDiagnoseController()
            detailDiagnoseVC.diagnose = self.listDiagnose[indexPath.item]
            self.navigationController?.pushViewController(detailDiagnoseVC, animated: true)
        } else {
            self.addSelectedIndexPath(indexPath: indexPath)
        }
    }
    
}

//MARK: - OptionMenuDelegate
extension DiagnoseController: OptionMenuDelegate {
    
    func didSelectItem(_ optionMenu: OptionMenu, at indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            self.chooseShowDetailVC()
            break
        case 1:
            self.isSelectedAdd = false
            self.collectionViewHistory.reloadData()
            self.cancelButton.isHidden = false
            self.floatButton.setImage(UIImage(named: "trash_bin"), for: .normal)
            
            break
        default:
            break
        }
        
        self.optionMenu.hide()
    }
}


//MARK: - DiagnoseCellDelegate
extension DiagnoseController: DiagnoseCellDelegate {
    
    func didSelectItem(at indexPath: IndexPath) {
        self.addSelectedIndexPath(indexPath: indexPath)
    }
    
}

//MARK: - AlertDeleteControllerDelegate
extension DiagnoseController: AlertDeleteControllerDelegate {
    
    func didSelectDelete() {
        self.selectedDelete()
        self.resetUIWhenDelete()
    }
    
    func didSelectCancel() {
        self.selectedIndexPaths.removeAll()
        self.resetUIWhenDelete()
    }
    
    fileprivate func resetUIWhenDelete() {
        self.isSelectedAdd = true
        self.cancelButton.isHidden = true
        self.selectedIndexPaths.removeAll()
        self.floatButton.setImage(UIImage(named: "AddIcon"), for: .normal)
        self.collectionViewHistory.reloadData()
    }
    
}









