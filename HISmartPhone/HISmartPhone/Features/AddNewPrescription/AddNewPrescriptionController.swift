//
//  AddNewPrescriptionController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/27/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class AddNewPrescriptionController: BaseViewController {
    
    //MARK: Variable
    fileprivate let cellAddNewDrug = "cellAddNewDrug"
    fileprivate let cellListDrug = "cellListDrug"
    
    //MARK: UIControl
    private let contentTitleView: UIView = {
        let viewConfig = UIView()
        
        viewConfig.backgroundColor = Theme.shared.primaryColor
        viewConfig.makeShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 1.0, radius: 4.0)
        
        return viewConfig
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Thêm đơn thuốc"
        label.textColor = Theme.shared.defaultTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.defaultTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    fileprivate lazy var drugCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(AddNewPrescriptionCell.self,
                                forCellWithReuseIdentifier: self.cellAddNewDrug)
        
        collectionView.register(ListDrugAddedCell.self,
                                forCellWithReuseIdentifier: self.cellListDrug)
        
        return collectionView
    }()
    
    //MARK: Initalize
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    override func setupView() {
        self.setupViewNavigationBar()
        self.setupViewContaintTitleView()
        self.setupViewTitleLabel()
        self.setupViewDateLabel()
        self.setupViewDrugCollectionView()
    }
    
    //MARK: Handle Action
    @objc func handleCloseButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSaveButton() {
        let appreciateVC = AppreciatePresciptionController()
        appreciateVC.delegate = self
        self.present(appreciateVC, animated: true, completion: nil)
    }
    
    //MARK: Feature
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.drugCollectionView.reloadData()
    }
    
    //MARK: SetupView
    private func setupViewNavigationBar() {
        //CLOSE
        self.navigationItem.addLeftBarItem(with: UIImage(named: "clear_white"), target: self, selector: #selector(handleCloseButton), title: nil)
        
        //SAVE
        self.navigationItem.addRightBarItems(with: "LƯU", target: self, selector: #selector(handleSaveButton))
    }
    
    private func setupViewContaintTitleView() {
        self.view.addSubview(self.contentTitleView)
        
        if #available(iOS 11, *) {
            self.contentTitleView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.height.equalTo(Dimension.shared.heightExtendNavigationBar)
                make.top.equalTo(self.view.safeAreaInsets)
            }
        } else {
            self.contentTitleView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.height.equalTo(Dimension.shared.heightExtendNavigationBar)
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
        }
    }
    
    private func setupViewTitleLabel() {
        self.contentTitleView.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            make.top.equalToSuperview()
        }
    }
    
    private func setupViewDateLabel() {
        self.contentTitleView.addSubview(self.dateLabel)
        
        self.dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewDrugCollectionView() {
        self.view.addSubview(self.drugCollectionView)
        
        if #available(iOS 11, *) {
            self.drugCollectionView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.top.equalTo(self.contentTitleView.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
                make.bottom.equalTo(self.view.safeAreaInsets)
            }
        } else {
            self.drugCollectionView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.top.equalTo(self.contentTitleView.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
            }
        }
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension AddNewPrescriptionController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellAddNewDrug, for: indexPath) as? AddNewPrescriptionCell else { return UICollectionViewCell() }
            
            cell.delegate = self
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellListDrug, for: indexPath) as? ListDrugAddedCell else { return UICollectionViewCell() }
            
            cell.delegate = self
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}

//MARK: - AddNewPrescriptionCellDelegate
extension AddNewPrescriptionController: AddNewPrescriptionCellDelegate {
    
    func didSelectListDrugButton() {
        self.drugCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0),
                                             at: UICollectionViewScrollPosition.centeredVertically,
                                             animated: false)
    }
    
}

//MARK: - ListDrugAddedCellDelegate
extension AddNewPrescriptionController: ListDrugAddedCellDelegate {
    
    func didSelectAddDrugButton() {
        self.drugCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                                             at: UICollectionViewScrollPosition.centeredVertically,
                                             animated: false)
    }
    
}

//MARK: - AppreciatePresciptionControllerDelegate
extension AddNewPrescriptionController: AppreciatePresciptionControllerDelegate {
    
    func saveAppreciate(_ message: String) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

