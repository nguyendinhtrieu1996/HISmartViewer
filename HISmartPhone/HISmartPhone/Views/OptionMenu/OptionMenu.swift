//
//  OptionMenu.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/25/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

protocol OptionMenuDelegate: class {
    func didSelectItem(_ optionMenu: OptionMenu, at indexPath: IndexPath)
}

class OptionMenu: UIView {
    
    //MARK: Variabel
    fileprivate var images = [UIImage]()
    fileprivate var title = [String]()
    weak var delegate: OptionMenuDelegate?
    fileprivate let cellId = "cellId"
    fileprivate let heightCell: CGFloat = 48 * Dimension.shared.heightScale
    fileprivate (set) var isShow: Bool = false
    fileprivate (set) var heightSupperView: CGFloat = 0
    
    //MARK: UIControl
    fileprivate lazy var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CellOptionMenu.self, forCellWithReuseIdentifier: self.cellId)
        
        return collectionView
    }()
    
    //MARK: Intialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewMenuCollectionview()
    }
    
    convenience init(images: [UIImage], title: [String]) {
        self.init()
        self.images = images
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Feature method
    public func setOption(images: [UIImage], title: [String]) {
        self.images = images
        self.title = title
        self.menuCollectionView.reloadData()
    }
    
    func showOrHide() {
        let heightMenuCV: CGFloat = CGFloat(self.images.count) * self.heightCell
        self.heightSupperView = heightMenuCV + 2 * Dimension.shared.normalVerticalMargin
        
        if self.isShow {
            self.hide()
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                
                if #available(iOS 11, *) {
                    self.snp.remakeConstraints({ (make) in
                        make.right.equalTo((self.superview?.safeAreaLayoutGuide) ?? 0)
                        make.width.equalTo(Dimension.shared.widthOptionMenu)
                        make.top.equalTo(self.superview?.snp.top ?? 0).offset(Dimension.shared.topMarginOptionMenu)
                        make.height.equalTo(self.heightSupperView)
                    })
                } else {
                    self.snp.remakeConstraints({ (make) in
                        make.right.equalTo((self.superview) ?? 0)
                        make.width.equalTo(Dimension.shared.widthOptionMenu)
                        make.top.equalTo(self.superview?.snp.top ?? 0).offset(Dimension.shared.topMarginOptionMenu)
                        make.height.equalTo(self.heightSupperView)
                    })
                }
                
                self.menuCollectionView.snp.remakeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
                    make.height.equalTo(heightMenuCV)
                }
            })
        }
    
        self.isShow = !self.isShow
    }
    
    func hide() {
        UIView.animate(withDuration: 0.1, animations: {
            self.snp.remakeConstraints({ (make) in
                make.right.equalTo(self.superview?.snp.right ?? 0)
                make.width.equalTo(Dimension.shared.widthOptionMenu)
                make.top.equalTo(self.superview!).offset(Dimension.shared.topMarginOptionMenu)
                make.height.equalTo(0)
            })
            self.menuCollectionView.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
                make.height.equalTo(0)
            }
        })
    }
    
    //MARK: SetupView
    private func setupViewMenuCollectionview() {
        self.addSubview(self.menuCollectionView)
        
        self.menuCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.height.equalTo(0)
        }
    }
    
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension OptionMenu: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as? CellOptionMenu else { return UICollectionViewCell() }
        
        cell.set(image: self.images[indexPath.item], title: self.title[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: self.heightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectItem(self, at: indexPath)
    }
    
}





