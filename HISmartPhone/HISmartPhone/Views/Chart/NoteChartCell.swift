//
//  NoteChartController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/2/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class NoteChartCell: BaseTableViewCell {
    
    fileprivate let cellNoteIconId = "cellNoteIconId"
    fileprivate let icons = NoteIcon.getIcons()
    
    //MARK: UIControl
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Chú thích"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    private let showButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "show_less"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.isHidden = true
        
        return button
    }()
    
    fileprivate lazy var noteIconCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Theme.shared.defaultBGColor
        collectionView.isScrollEnabled = false
        collectionView.register(NoteIconCell.self, forCellWithReuseIdentifier: self.cellNoteIconId)
        
        return collectionView
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewTitleLabel()
        self.setupViewShowButton()
        self.setupViewNoteIconCollectionView()
    }
    
    //MARK: Handle Action
    @objc func handleShowButton() {
        
    }
    
    //MARK: SetupView     
    private func setupViewTitleLabel() {
        self.addSubview(self.titleLabel)
        
        if #available(iOS 11, *) {
            self.titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.safeAreaLayoutGuide).offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalToSuperview()
            }
        } else {
            self.titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalToSuperview()
            }
        }
    }
    
    private func setupViewShowButton() {
        self.addSubview(self.showButton)
        
        self.showButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel)
            make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
        
        self.showButton.addTarget(self, action: #selector(handleShowButton), for: .touchUpInside)
    }
    
    private func setupViewNoteIconCollectionView() {
        self.addSubview(self.noteIconCollectionView)
        
        self.noteIconCollectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.width.equalTo(250 * Dimension.shared.widthScale)
            make.height.equalTo(60 * Dimension.shared.heightScale)
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension NoteChartCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellNoteIconId, for: indexPath) as? NoteIconCell else { return UICollectionViewCell() }
        
        cell.setIcon(self.icons[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height / 2)
    }
    
}








