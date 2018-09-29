//
//  MessageBoxController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/29/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class MessageBoxController: BaseViewController {
    
    fileprivate let cellId = "cellId"
    fileprivate var listPartner = [PartnerChat]()
    fileprivate var listPartnerNewMessage = [PartnerChat]()
    fileprivate let messageBoxFacade = MessageBoxFacade()
    
    //MARK: UIControl
    fileprivate let betterSegment: BetterSegmentedControl = {
        let titles = ["Inbox", "Unread Box"]
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
    
    private let containtViewSearchBar: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.defaultBGColor
        return view
    }()
    
    fileprivate lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.placeholder = "Tìm kiếm tin nhắn"
        searchBar.backgroundImage = UIImage()
        
        return searchBar
    }()
    
    fileprivate lazy var listMessageTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Theme.shared.defaultBGColor
        tableView.separatorStyle = .none
        tableView.register(ListMessageCell.self, forCellReuseIdentifier: self.cellId)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        return tableView
    }()
    
    fileprivate lazy var listNewMessageTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.backgroundColor = Theme.shared.defaultBGColor
        tableView.separatorStyle = .none
        tableView.register(ListMessageCell.self, forCellReuseIdentifier: self.cellId)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        return tableView
    }()
    
    public let floatButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "AddIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        return button
    }()
    
    private let noneMessageImage: UIImageView = {
        let image = UIImageView.init(image: UIImage.init(named: "non-message"))
        
        image.contentMode = .scaleAspectFill
        image.isHidden = true
        
        return image
    }()
    
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
    
    override func setupView() {
        self.setupViewNavigationBar()
        self.setTitle(with: 0)
        self.setupViewCustomSegment()
        self.setupViewContaintSearchView()
        self.setupViewSearchBar()
        self.setupViewListMessageTableView()
        self.setupViewListNewMessageTableView()
        self.setupViewFloatButton()
        self.setupViewNoneMessageImage()
        
        self.fetchData()
    }
    
    //MARK: Handle Action
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSegmentControl(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            self.listMessageTableView.isHidden = false
            self.listNewMessageTableView.isHidden = true
            self.noneMessageImage.isHidden = !self.listPartner.isEmpty
        } else {
            self.listMessageTableView.isHidden = true
            self.listNewMessageTableView.isHidden = false
            self.noneMessageImage.isHidden = !self.listPartnerNewMessage.isEmpty
        }
    }
    
    @objc func handleFloatButton() {
        let newMessageController = NewMessageController()
        newMessageController.typeNewMessage = .newMesagge
        self.navigationController?.pushViewController(newMessageController, animated: true)
    }
    
    //MARK: Feature
    private func fetchData() {
        self.messageBoxFacade.fetchAllPartner(completionHandler: {
            self.listPartner = self.messageBoxFacade.listAllPartner
            self.listPartnerNewMessage = self.messageBoxFacade.listNewPartner
            
            if self.betterSegment.index == 0 {
                self.listMessageTableView.isHidden = false
                self.listNewMessageTableView.isHidden = true
                self.noneMessageImage.isHidden = !self.listPartner.isEmpty
            } else {
                self.listMessageTableView.isHidden = true
                self.listNewMessageTableView.isHidden = true
                self.noneMessageImage.isHidden = !self.listPartnerNewMessage.isEmpty
            }
            
            self.setTitle(with: self.messageBoxFacade.listNewPartner.count)
            self.listMessageTableView.reloadData()
            self.listNewMessageTableView.reloadData()
        }) {
            self.noneMessageImage.isHidden = false
        }
    }
    
    fileprivate func searchIsEmpty() -> Bool {
        return self.searchBar.text?.isEmpty ?? true
    }
    
    fileprivate func filterContentForSearchText(_ searchText: String, scrop: String = "All") {
        if self.searchIsEmpty() {
            self.listPartner = self.messageBoxFacade.listAllPartner
            self.listPartnerNewMessage = self.messageBoxFacade.listNewPartner
            self.listMessageTableView.reloadData()
            self.listNewMessageTableView.reloadData()
            
            return
        }
        
        if self.betterSegment.index == 0 {
            self.listPartner = self.messageBoxFacade.listAllPartner.filter {
                $0.user.fullName.lowercased().contains(searchText.lowercased())
            }
        } else {
            self.listPartnerNewMessage = self.messageBoxFacade.listNewPartner.filter {
                $0.user.fullName.lowercased().contains(searchText.lowercased())
            }
        }
        
        self.listMessageTableView.reloadData()
        self.listNewMessageTableView.reloadData()
    }
    
    fileprivate func isFiltering() -> Bool {
        return !self.searchIsEmpty()
    }
    
    //MARK: SetupView
    private func setupViewNavigationBar() {
        //BACK ITEM
        self.navigationItem.addLeftBarItem(with: UIImage(named: "back_white"),
                                           target: self,
                                           selector: #selector(handleBackButton),
                                           title: nil)
    }
    
    private func setTitle(with number: Int) {
        let nameLabel = UILabel()
        nameLabel.text = "Hộp thư tin nhắn (\(number))"
        nameLabel.textColor = Theme.shared.defaultTextColor
        nameLabel.frame = CGRect(x: 0, y: 0, width: 130, height: 30)
        nameLabel.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize,
                                           weight: UIFont.Weight.medium)
        
        self.navigationItem.titleView = nameLabel
    }
    
    private func setupViewCustomSegment() {
        self.view.addSubview(self.betterSegment)
        
        if #available(iOS 11, *) {
            self.betterSegment.snp.makeConstraints { (make) in
                make.width.equalTo(Dimension.shared.widthCustomSegment)
                make.height.equalTo(Dimension.shared.heightCustomSegment)
                make.centerX.equalToSuperview()
                make.top.equalTo(self.view.safeAreaInsets)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.betterSegment.snp.makeConstraints { (make) in
                make.width.equalTo(Dimension.shared.widthCustomSegment)
                make.height.equalTo(Dimension.shared.heightCustomSegment)
                make.centerX.equalToSuperview()
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        }
        
        
    }
    
    private func setupViewContaintSearchView() {
        self.view.addSubview(self.containtViewSearchBar)
        
        self.containtViewSearchBar.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(Dimension.shared.heightContainsViewSearchBar)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.betterSegment.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupViewSearchBar() {
        self.containtViewSearchBar.addSubview(self.searchBar)
        
        self.searchBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.mediumHorizontalMargin)
            make.centerY.equalToSuperview()
            make.height.equalTo(Dimension.shared.heightSearchBar)
            make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupViewListMessageTableView() {
        self.view.addSubview(self.listMessageTableView)
        
        self.listMessageTableView.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalToSuperview()
            make.top.equalTo(self.containtViewSearchBar.snp.bottom)
                .offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewListNewMessageTableView() {
        self.view.addSubview(self.listNewMessageTableView)
        
        self.listNewMessageTableView.snp.makeConstraints { (make) in
            make.width.height.centerX.centerY.equalTo(self.listMessageTableView)
        }
    }
    
    private func setupViewFloatButton() {
        self.view.addSubview(self.floatButton)
        
        self.floatButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(Dimension.shared.widthFloatButton)
            make.right.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
            make.bottom.equalToSuperview()
                .offset(-Dimension.shared.largeVerticalMargin)
        }
        
        self.floatButton.addTarget(self, action: #selector(handleFloatButton), for: .touchUpInside)
    }
    
    private func setupViewNoneMessageImage() {
        self.view.addSubview(self.noneMessageImage)
        
        self.noneMessageImage.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(100 * Dimension.shared.widthScale)
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MessageBoxController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.listMessageTableView {
            return self.listPartner.count
        } else {
            return self.listPartnerNewMessage.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? ListMessageCell else { return UITableViewCell() }
        
        if tableView == self.listMessageTableView {
            cell.partner = self.listPartner[indexPath.item]
        } else {
            cell.partner = self.listPartnerNewMessage[indexPath.item]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        var idPartner: String = ""
//
//        if editingStyle == .delete {
//            if tableView == self.listMessageTableView {
//                idPartner = self.listPartner[indexPath.item].idPartner
//            } else {
//                idPartner = self.listPartnerNewMessage[indexPath.item].idPartner
//            }
//
//            self.messageBoxFacade.deleteUserMessage(with: idPartner, completionHandler: {
//                if self.betterSegment.index == 0 {
//                    self.listMessageTableView.isHidden = false
//                    self.listNewMessageTableView.isHidden = true
//                    self.noneMessageImage.isHidden = !self.listPartner.isEmpty
//                } else {
//                    self.listMessageTableView.isHidden = true
//                    self.listNewMessageTableView.isHidden = true
//                    self.noneMessageImage.isHidden = !self.listPartnerNewMessage.isEmpty
//                }
//
//                self.setTitle(with: self.messageBoxFacade.listNewPartner.count)
//                self.listMessageTableView.reloadData()
//                self.listNewMessageTableView.reloadData()
//            }, errorHandler: {
//                //Error
//            })
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newMessageController = NewMessageController()
        newMessageController.typeNewMessage = .continueMessage
        newMessageController.setPartner(self.listPartner[indexPath.item])
        self.navigationController?.pushViewController(newMessageController, animated: true)
        
        if self.betterSegment.index == 1 { //New Message
            self.messageBoxFacade.updateStatusUserMessage(with: self.listPartner[indexPath.item].idPartner)
        }
    }
    
}

//MARK: - UISearchBarDelegate
extension MessageBoxController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterContentForSearchText(searchText)
        self.listMessageTableView.reloadData()
    }
}



