//
//  ResultBloodPressureController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/23/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class ResultBloodPressureController: BaseInfoPatientVC {
    
    //MARK: Variable
    fileprivate let cellId = "cellId"
    fileprivate var isShowDelete = false
    fileprivate var selectedIndexPaths = [IndexPath]()
    fileprivate var listBPOResult = [BPOResult]()
    
    fileprivate lazy var alertDeleteVC: AlertDeleteController = {
        let alert = AlertDeleteController()
        alert.delegate = self
        return alert
    }()
    
    //MARK: UIControl
    fileprivate lazy var optionMenu: OptionMenu = {
        var menu = OptionMenu()
        
        if Authentication.share.typeUser == .patient {
            menu = OptionMenu(images: [#imageLiteral(resourceName: "history")], title: ["Phân tích thống kê"])
        } else {
            menu = OptionMenu(images: [#imageLiteral(resourceName: "history"), #imageLiteral(resourceName: "clear_blue")], title: ["Phân tích thống kê", "Xoá kết quả huyết áp"])
        }
        
        menu.delegate = self
        menu.backgroundColor = Theme.shared.defaultBGColor
        menu.layer.cornerRadius = Dimension.shared.normalCornerRadius
        menu.makeShadow(color: Theme.shared.backgroundColorShadow, opacity: 1.0, radius: 4)
        
        return menu
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Kết quả huyết áp"
        label.textColor = Theme.shared.primaryColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    private let optionButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "option"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
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
    
    public let trashFloatButton: UIButton = {
        let button = UIButton()
        
        button.isHidden = true
        button.setImage(UIImage(named: "trash_bin"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        return button
    }()
    
    fileprivate lazy var collectionViewBloodPressure: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Theme.shared.darkBGColor
        collectionView.register(BloodResultPressureCell.self, forCellWithReuseIdentifier: self.cellId)
        
        return collectionView
    }()
    
    private let emptyAnnoucementLabel: UILabel = {
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
        self.collectionViewBloodPressure.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchData()
    }
    
    override func setupView() {
        self.setupViewTitleLabel()
        self.setupViewDateLabel()
        self.setupViewOptionButton()
        self.setupViewCancelButton()
        self.setupViewResultBloodPressureTBV()
        self.setupViewOptionMenu()
        self.setupViewTrashFloatButton()
        self.setupViewEmptyAnnoucementLabel()
    }
    
    //MARK: Action UIControl
    @objc func handleOptionButton() {
        self.optionMenu.showOrHide()
    }
    
    @objc func handleCancelButton() {
        self.isShowDelete = false
        self.selectedIndexPaths.removeAll()
        self.collectionViewBloodPressure.reloadData()
        self.cancelButton.isHidden = true
        self.trashFloatButton.isHidden = true
    }
    
    @objc func handleTrashFloatButton() {
        self.present(self.alertDeleteVC, animated: true, completion: nil)
    }
    
    @objc func handleRotateDevice() {
        self.setupViewOptionMenu()
    }
    
    //MARK: Feature method
    @objc private func fetchData() {
        ResultBloodPressureFacade.fetchAllBloodPressures {
            self.listBPOResult = BPOChartManager.shared.BPOResults
            self.collectionViewBloodPressure.reloadData()
            
            if self.listBPOResult.count == 0 {
                self.emptyAnnoucementLabel.isHidden = false
            } else {
                self.emptyAnnoucementLabel.isHidden = true
            }
        }
    }
    
    fileprivate func addSelectedIndexPath(indexPath: IndexPath) {
        if !self.selectedIndexPaths.contains(indexPath) {
            self.selectedIndexPaths.append(indexPath)
        } else {
            if let index = self.selectedIndexPaths.index(where: { (i) -> Bool in
                return i.elementsEqual(indexPath)
            }) {
                self.selectedIndexPaths.remove(at: index)
            }
        }
        
        if self.selectedIndexPaths.count > 0 {
            self.trashFloatButton.isHidden = false
        } else {
            self.trashFloatButton.isHidden = true
        }
        
        self.collectionViewBloodPressure.reloadData()
    }
    
    fileprivate func selectedDelete() {
        ResultBloodPressureFacade.deleteBPOResult(at: self.selectedIndexPaths) {
            self.fetchData()
            NotificationCenter.default.post(name: NSNotification.Name.init(Notification.Name.updateBPOResults), object: nil)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionViewBloodPressure.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: SetupView
    private func setupViewTitleLabel() {
        self.view.addSubview(self.titleLabel)
        
        
        if #available(iOS 11, *) {
            self.titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
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
    
    private func setupViewDateLabel() {
        self.view.addSubview(self.dateLabel)
        
        self.dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
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
                make.width.equalTo(45 * Dimension.shared.widthScale)
                make.height.equalTo(20 * Dimension.shared.heightScale)
                make.right.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(-Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.optionButton.snp.bottom)
                    .offset(Dimension.shared.smallVerticalMargin / 2)
            }
        } else {
            self.cancelButton.snp.makeConstraints { (make) in
                make.width.equalTo(45 * Dimension.shared.widthScale)
                make.height.equalTo(20 * Dimension.shared.heightScale)
                make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.optionButton.snp.bottom)
                    .offset(Dimension.shared.smallVerticalMargin / 2)
            }
        }
        
        self.cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
    }
    
    private func setupViewResultBloodPressureTBV() {
        self.view.addSubview(self.collectionViewBloodPressure)
        
        if #available(iOS 11, *) {
            self.collectionViewBloodPressure.snp.makeConstraints { (make) in
                make.centerX.width.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaInsets)
                make.top.equalTo(self.cancelButton.snp.bottom).offset(Dimension.shared.smallVerticalMargin / 2)
            }
        } else {
            self.collectionViewBloodPressure.snp.makeConstraints { (make) in
                make.centerX.width.equalToSuperview()
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                make.top.equalTo(self.cancelButton.snp.bottom).offset(Dimension.shared.smallVerticalMargin / 2)
            }
        }
    }
    
    private func setupViewOptionMenu() {
        self.view.addSubview(self.optionMenu)
        
        if #available(iOS 11, *) {
            self.optionMenu.snp.makeConstraints { (make) in
                make.right.equalTo(self.view.safeAreaLayoutGuide)
                make.top.equalTo(self.dateLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
                make.width.equalTo(Dimension.shared.widthOptionMenu)
                make.height.equalTo(0)
            }
        } else {
            self.optionMenu.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.top.equalTo(self.dateLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
                make.width.equalTo(Dimension.shared.widthOptionMenu)
                make.height.equalTo(0)
            }
        }
    }
    
    private func setupViewTrashFloatButton() {
        self.view.addSubview(self.trashFloatButton)
        
        if #available(iOS 11, *) {
            self.trashFloatButton.snp.makeConstraints { (make) in
                make.width.height.equalTo(Dimension.shared.widthFloatButton)
                make.right.equalToSuperview().offset(-23 * Dimension.shared.widthScale)
                make.bottom.equalTo(self.view.safeAreaInsets)
                    .offset(-Dimension.shared.largeVerticalMargin)
            }
        } else {
            self.trashFloatButton.snp.makeConstraints { (make) in
                make.width.height.equalTo(Dimension.shared.widthFloatButton)
                make.right.equalToSuperview().offset(-23 * Dimension.shared.widthScale)
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                    .offset(-Dimension.shared.largeVerticalMargin)
            }
        }
        
        self.trashFloatButton.addTarget(self, action: #selector(handleTrashFloatButton), for: .touchUpInside)
    }
    
    private func setupViewEmptyAnnoucementLabel() {
        self.view.addSubview(self.emptyAnnoucementLabel)
        
        self.emptyAnnoucementLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ResultBloodPressureController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listBPOResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as? BloodResultPressureCell else { return UICollectionViewCell() }
        
        cell.set(indexPath: indexPath)
        cell.delegate = self
        cell.BPOResult = self.listBPOResult[indexPath.item]
        
        if self.isShowDelete {
            if self.selectedIndexPaths.contains(indexPath) {
                cell.showImage(status: .on)
            } else {
                cell.showImage(status: .off)
            }
        } else {
            cell.showImage(status: .hide)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 77 * Dimension.shared.heightScale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isShowDelete {
            self.addSelectedIndexPath(indexPath: indexPath)
        }
    }
    
}

//MARK: - OptionMenuDelegate
extension ResultBloodPressureController: OptionMenuDelegate {
    
    func didSelectItem(_ optionMenu: OptionMenu, at indexPath: IndexPath) {
        if indexPath.item == 0 {
            let staticsAnalysisController = StatisticalAnalysisController()
            staticsAnalysisController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(staticsAnalysisController, animated: true)
        } else if indexPath.item == 1 {
            self.isShowDelete = true
            self.cancelButton.isHidden = false
            self.collectionViewBloodPressure.reloadData()
        }
        
        self.optionMenu.hide()
    }
    
}

//MARK: - BloodResultPressureCellDelegate
extension ResultBloodPressureController: BloodResultPressureCellDelegate {
    
    func selectedCheckbox(at indexPath: IndexPath) {
        self.addSelectedIndexPath(indexPath: indexPath)
    }
    
}

//MARK: - AlertDeleteControllerDelegate
extension ResultBloodPressureController: AlertDeleteControllerDelegate {
    
    func didSelectDelete() {
        self.selectedDelete()
        self.resetUIWhenDelete()
    }
    
    func didSelectCancel() {
        self.resetUIWhenDelete()
    }
    
    fileprivate func resetUIWhenDelete() {
        self.isShowDelete = false
        self.selectedIndexPaths.removeAll()
        self.collectionViewBloodPressure.reloadData()
        self.cancelButton.isHidden = true
        self.trashFloatButton.isHidden = true
    }
    
}





