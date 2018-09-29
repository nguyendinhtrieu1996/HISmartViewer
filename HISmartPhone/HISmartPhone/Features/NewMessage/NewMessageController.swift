//
//  NewMessageController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/30/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

enum TypeNewMessage {
    case newMesagge, continueMessage
}

class NewMessageController: BaseViewController {
    
    //MARK: Variable
    var typeNewMessage: TypeNewMessage = .continueMessage {
        didSet {
            if self.typeNewMessage == .newMesagge {
                self.setTitle("Tin nhắn mới")
                self.searchBar.isHidden = false
                self.sendToLabel.isHidden = false
                self.messageCollectionView.isHidden = true
                self.searchBar.becomeFirstResponder()
                self.heightContaintView = 56 * Dimension.shared.heightScale
                self.fetchAllPartnerChatUser()
            } else {
                self.heightContaintView = 0
                self.searchBar.isHidden = true
                self.sendToLabel.isHidden = true
                self.messageCollectionView.isHidden = false
                
                //SetupView Send message view
                self.setupViewContaintMessageView()
                self.setupViewContaintViewMessageTextView()
                self.setupViewPlaceHolderLabel()
                self.setupViewMessageTextView()
                self.setupViewSendButton()
                self.setupViewInfoItem()
            }
            
            self.setupViewContaintViewSendToView()
        }
    }
    
    fileprivate let placeHolderMessage = "Nhập nội dung tin nhắn"
    fileprivate var heightContaintView: CGFloat = 0
    fileprivate let cellMessageId = "cellMessageId"
    fileprivate let cellListUserId = "cellListUserId"
    fileprivate var partnerChat = PartnerChat()
    fileprivate var messages: [Message] = [Message]()
    fileprivate var messageFacade = NewMessageFacade()
    fileprivate var listChatUser = [User]()
    fileprivate var isFirstOpen = true
    
    //MARK: UIContol
    
    //MARK: SEND MESSAGE
    var containtViewMessage: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9332318306, green: 0.9333917499, blue: 0.933221817, alpha: 1)
        return view
    }()
    
    private let containtViewMessageTextView: UIView = {
        let view = UIView()
        
        view.backgroundColor = Theme.shared.defaultBGColor
        view.layer.cornerRadius = Dimension.shared.normalCornerRadius
        view.layer.masksToBounds = true
        
        return view
    }()
    
    fileprivate lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        
        label.text = self.placeHolderMessage
        label.textColor = Theme.shared.placeHolderMessageColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    fileprivate lazy var messageTextView: UITextView = {
        let textViewConfig = UITextView()
        
        textViewConfig.isEditable = true
        textViewConfig.textColor = Theme.shared.darkBlueTextColor
        textViewConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textViewConfig.delegate = self
        textViewConfig.layer.cornerRadius = Dimension.shared.normalCornerRadius
        textViewConfig.layer.masksToBounds = true
        textViewConfig.backgroundColor = UIColor.clear
        textViewConfig.autocorrectionType = .no
        
        return textViewConfig
    }()
    
    private var containtViewSendToView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9332318306, green: 0.9333917499, blue: 0.933221817, alpha: 1)
        return view
    }()
    
    private var sendButton: UIButton = {
        let button = UIButton()
        
        button.isUserInteractionEnabled = false
        button.setTitle("GỬI", for: .normal)
        button.setTitleColor(Theme.shared.grayTextColor, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return button
    }()
    
    private let sendToLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Đến:"
        label.textColor = Theme.shared.grayTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    fileprivate lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        
        return searchBar
    }()
    
    fileprivate lazy var messageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Theme.shared.defaultBGColor
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: self.cellMessageId)
        
        return collectionView
    }()
    
    fileprivate lazy var listUserTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Theme.shared.darkBGColor
        tableView.separatorStyle = .none
        tableView.register(ListUserCell.self, forCellReuseIdentifier: self.cellListUserId)
        
        return tableView
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.tintColor = Theme.shared.defaultBGColor
    }
    
    override func setupView() {
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        self.setupBackButton()
        self.setupViewContaintViewSendToView()
        self.setupViewSendToLabel()
        self.setupViewSearchBar()
        self.setupViewMessageCollectionView()
        self.setupViewListUserTableView()
        self.setupViewEmptyAnnoucementLabel()
        
        self.addObserver()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchMessage), name: NSNotification.Name.init(Notification.Name.obseverMessage), object: nil)
    }
    
    //MARK: Handle Action
    @objc func handleBackButton() {
        if self.partnerChat.idPartner != "" {
            self.messageFacade.updateStatusUserMessage(with: self.partnerChat.idPartner)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleInfoBarItem() {
        let infoPatientVC = PatientInformationController()
        self.navigationController?.pushViewController(infoPatientVC, animated: true)
    }
    
    @objc func handleSendButton() {
        let message = Message(message: self.messageTextView.text, toId: self.partnerChat.idPartner)
        
        self.messageFacade.sendMessage(with: self.partnerChat.idPartner, message: message, completionHadler: {
            self.fetchMessage()
            self.messageCollectionView.reloadData()
        }) {
            //error
        }
        
        //Message
        self.messageTextView.text = nil
        self.placeHolderLabel.isHidden = false
        self.sendButton.isUserInteractionEnabled = false
        self.sendButton.setTitleColor(Theme.shared.grayTextColor, for: .normal)
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let size = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        guard let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        
        if self.typeNewMessage == .newMesagge {
            self.showListUser(heightKeyboard: size.height, duration: duration)
        } else {
            self.scrollUp(heightKeyboard: size.height, duration: duration)
        }
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        guard let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        
        if self.typeNewMessage == .newMesagge {
            self.expandListUser(duration: duration)
        } else {
            self.scrollDown(duration: duration)
        }
    }
    
    //MARK: Feature
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let flowLayout = self.messageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.invalidateLayout()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setPartner(_ partner: PartnerChat) {
        self.partnerChat = partner
        self.setTitle(self.partnerChat.user.fullName)
        self.fetchMessage()
    }
    
    @objc private func fetchMessage() {
        self.messageFacade.loadAllMessageFromDB(width: self.partnerChat.idPartner, completionHandler: {
            self.messages = self.messageFacade.listMessage
            let numberMessages = self.messages.count
            self.messageCollectionView.reloadData()
            
            if numberMessages > 0 {
                if self.isFirstOpen {
                    self.messageCollectionView.scrollToItem(at: IndexPath.init(row: numberMessages - 1, section: 0), at: .bottom, animated: false)
                } else {
                    self.messageCollectionView.scrollToItem(at: IndexPath.init(row: numberMessages - 1, section: 0), at: .bottom, animated: false)
                }
            }
            
            self.isFirstOpen = false
        }) {
            //Error
        }
    }
    
    fileprivate func checkShowTimeForMessage(_ index: Int) -> Bool {
        if index == 0 {
            return true
        }
        
        if (index != self.messages.count - 1) && (Date.distanceDay(from: messages[index - 1].timestamp, to: messages[index].timestamp) >= 1) {
            return true
        }
        
        return false
    }
    
    private func fetchAllPartnerChatUser() {
        self.messageFacade.loadAllUserCanSendMessage(completionHandler: {
            self.listChatUser = self.messageFacade.listUser
            self.listUserTableView.reloadData()
            
            if self.listChatUser.count == 0 {
                self.emptyAnnoucementLabel.isHidden = false
            } else {
                self.emptyAnnoucementLabel.isHidden = true
            }
        }) {
            //error
        }
    }
    
    fileprivate func searchIsEmpty() -> Bool {
        return self.searchBar.text?.isEmpty ?? true
    }
    
    fileprivate func filterContentForSearchText(_ searchText: String, scrop: String = "All") {
        if self.searchIsEmpty() {
            self.listChatUser = self.messageFacade.listUser
            return
        }
        
        self.listChatUser = self.messageFacade.listUser.filter {
            $0.fullName.lowercased().contains(searchText.lowercased())
        }
        
        self.listUserTableView.reloadData()
    }
    
    fileprivate func isFiltering() -> Bool {
        return !self.searchIsEmpty()
    }
    
    //MARK: Animation
    fileprivate func showListUser(heightKeyboard: CGFloat, duration: Double) {
        var heightListUser: CGFloat
        
        if #available(iOS 11, *) {
            heightListUser = self.view.frame.height - heightKeyboard - self.view.safeAreaInsets.top - self.heightContaintView - Dimension.shared.mediumVerticalMargin
        } else {
            heightListUser = self.view.frame.height - heightKeyboard - self.topLayoutGuide.length - self.heightContaintView - Dimension.shared.mediumVerticalMargin
        }
        
        UIView.animate(withDuration: duration, animations: {
            self.listUserTableView.snp.remakeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.top.equalTo(self.containtViewSendToView.snp.bottom)
                    .offset(Dimension.shared.smallVerticalMargin)
                make.height.equalTo(heightListUser)
            }
        }) { (finish) in
            
        }
    }
    
    fileprivate func expandListUser(duration: Double) {
        var heightListUser: CGFloat
        
        if #available(iOS 11, *) {
            heightListUser = self.view.frame.height - self.view.safeAreaInsets.top - self.heightContaintView - Dimension.shared.mediumVerticalMargin
        } else {
            heightListUser = self.view.frame.height - self.topLayoutGuide.length - self.heightContaintView - Dimension.shared.mediumVerticalMargin
        }
        
        UIView.animate(withDuration: duration, animations: {
            self.listUserTableView.snp.remakeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.top.equalTo(self.containtViewSendToView.snp.bottom)
                    .offset(Dimension.shared.smallVerticalMargin)
                make.height.equalTo(heightListUser)
            }
        }) { (finish) in
            
        }
    }
    
    fileprivate func scrollUp(heightKeyboard: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration) {
            
            if #available(iOS 11, *) {
                self.messageCollectionView.snp.remakeConstraints({ (make) in
                    make.width.centerX.equalToSuperview()
                    make.top.equalTo(self.containtViewSendToView.snp.bottom)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide)
                        .offset(-heightKeyboard - 56 * Dimension.shared.heightScale)
                })
                
                self.containtViewMessage.snp.remakeConstraints({ (make) in
                    make.width.centerX.equalToSuperview()
                    make.height.equalTo(56 * Dimension.shared.heightScale)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-heightKeyboard)
                })
            } else {
                self.messageCollectionView.snp.remakeConstraints({ (make) in
                    make.width.centerX.equalToSuperview()
                    make.top.equalTo(self.containtViewSendToView.snp.bottom)
                    make.bottom.equalToSuperview().offset(-heightKeyboard - 56 * Dimension.shared.heightScale)
                })
                
                self.containtViewMessage.snp.remakeConstraints({ (make) in
                    make.width.centerX.equalToSuperview()
                    make.height.equalTo(56 * Dimension.shared.heightScale)
                    make.bottom.equalToSuperview().offset(-heightKeyboard)
                })
            }
        }
    }
    
    fileprivate func scrollDown(duration: Double) {
        UIView.animate(withDuration: duration) {
            
            if #available(iOS 11, *) {
                self.messageCollectionView.snp.remakeConstraints({ (make) in
                    make.width.centerX.equalToSuperview()
                    make.top.equalTo(self.containtViewSendToView.snp.bottom)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide)
                        .offset(-56 * Dimension.shared.heightScale)
                })
                
                self.containtViewMessage.snp.remakeConstraints({ (make) in
                    make.width.centerX.equalToSuperview()
                    make.height.equalTo(56 * Dimension.shared.heightScale)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(0)
                })
            } else {
                self.messageCollectionView.snp.remakeConstraints({ (make) in
                    make.width.centerX.equalToSuperview()
                    make.top.equalTo(self.containtViewSendToView.snp.bottom)
                    make.bottom.equalToSuperview().offset(-56 * Dimension.shared.heightScale)
                })
                
                self.containtViewMessage.snp.remakeConstraints({ (make) in
                    make.width.centerX.equalToSuperview()
                    make.height.equalTo(56 * Dimension.shared.heightScale)
                    make.bottom.equalToSuperview().offset(0)
                })
            }
        }
    }
    
    //MARK: SetupView
    private func setupBackButton() {
        self.navigationItem.addLeftBarItem(with: UIImage(named: "back_white"), target: self, selector: #selector(handleBackButton), title: nil)
    }
    
    private func setTitle(_ title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.textColor = Theme.shared.defaultTextColor
        titleLabel.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize,
                                            weight: UIFont.Weight.medium)
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        
        self.navigationItem.titleView = titleLabel
    }
    
    private func setupViewInfoItem() {
        if Authentication.share.typeUser == .doctor {
            self.navigationItem.addRightBarItem(with: UIImage(named: "infor_patient"), target: self, selector: #selector(handleInfoBarItem))
        }
    }
    
    private func setupViewContaintViewSendToView() {
        self.view.addSubview(self.containtViewSendToView)
        
        if #available(iOS 11, *) {
            self.containtViewSendToView.snp.remakeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.top.equalTo(self.view.safeAreaInsets)
                make.height.equalTo(self.heightContaintView * Dimension.shared.heightScale)
            }
        } else {
            self.containtViewSendToView.snp.remakeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                make.height.equalTo(self.heightContaintView * Dimension.shared.heightScale)
            }
        }
    }
    
    private func setupViewSendToLabel() {
        self.containtViewSendToView.addSubview(self.sendToLabel)
        
        self.sendToLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.mediumHorizontalMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupViewSearchBar() {
        self.containtViewSendToView.addSubview(self.searchBar)
        
        self.searchBar.snp.makeConstraints { (make) in
            make.left.equalTo(self.sendToLabel.snp.right).offset(Dimension.shared.mediumHorizontalMargin)
            make.centerY.equalTo(self.sendToLabel)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupViewMessageCollectionView() {
        self.view.addSubview(self.messageCollectionView)
        
        self.messageCollectionView.snp.makeConstraints { (make) in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(self.containtViewSendToView.snp.bottom)
            make.bottom.equalToSuperview().offset(-56 * Dimension.shared.heightScale)
        }
    }
    
    private func setupViewListUserTableView() {
        self.view.addSubview(self.listUserTableView)
        
        self.listUserTableView.snp.makeConstraints { (make) in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(self.containtViewSendToView.snp.bottom)
                .offset(Dimension.shared.smallVerticalMargin)
            make.height.equalTo(0)
        }
    }
    
    //MARK: Containt View Send message
    private func setupViewContaintMessageView() {
        self.view.addSubview(self.containtViewMessage)
        
        if #available(iOS 11, *) {
            self.containtViewMessage.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
                make.height.equalTo(56 * Dimension.shared.heightScale)
            }
        } else {
            self.containtViewMessage.snp.makeConstraints { (make) in
                make.width.bottom.centerX.equalToSuperview()
                make.height.equalTo(56 * Dimension.shared.heightScale)
            }
        }
    }
    
    private func setupViewContaintViewMessageTextView() {
        self.containtViewMessage.addSubview(self.containtViewMessageTextView)
        
        self.containtViewMessageTextView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
            make.right.equalToSuperview().offset(-73 * Dimension.shared.widthScale)
            make.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewPlaceHolderLabel() {
        self.containtViewMessage.addSubview(self.placeHolderLabel)
        
        self.placeHolderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.containtViewMessageTextView)
                .offset(Dimension.shared.mediumHorizontalMargin)
            
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupViewMessageTextView() {
        self.containtViewMessage.addSubview(self.messageTextView)
        
        self.messageTextView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.containtViewMessageTextView)
        }
    }
    
    private func setupViewSendButton() {
        self.containtViewMessage.addSubview(self.sendButton)
        
        self.sendButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.messageTextView.snp.right).offset(Dimension.shared.smallHorizontalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.smallHorizontalMargin)
            make.centerY.height.equalTo(self.messageTextView)
        }
        
        self.sendButton.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
    }
    
    private func setupViewEmptyAnnoucementLabel() {
        self.view.addSubview(self.emptyAnnoucementLabel)
        
        self.emptyAnnoucementLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension NewMessageController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listChatUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellListUserId, for: indexPath) as? ListUserCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.user = self.listChatUser[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48 * Dimension.shared.heightScale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.listUserTableView.isHidden = true
        self.searchBar.endEditing(true)
        self.typeNewMessage = .continueMessage
        
        let partnerChat = PartnerChat.init(from: self.listChatUser[indexPath.item])
        self.setPartner(partnerChat)
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension NewMessageController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellMessageId, for: indexPath) as? MessageCell else { return UICollectionViewCell() }
        
        if self.checkShowTimeForMessage(indexPath.item) {
            cell.isShowTime = true
        } else {
            cell.isShowTime = false
        }
        
        cell.message = self.messages[indexPath.item]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = self.messages[indexPath.item].message.estimateFrameForText(maxWidth: Dimension.shared.widthMessage, fontSize: Dimension.shared.messageFontSize).height + Dimension.shared.largeVerticalMargin_32
        
        if self.checkShowTimeForMessage(indexPath.item) {
            height += 12 * Dimension.shared.heightScale + 2 * Dimension.shared.smallVerticalMargin
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Authentication.share.typeUser == .patient { return }
        
        let chartVC = ChartFromToDateController()
        chartVC.fetchData(self.messages[indexPath.item].timestamp, for: self.partnerChat.idPartner, self.partnerChat.user.fullName)
        chartVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(chartVC, animated: true)
    }
    
}

//MARK: - UISearchResultsUpdating
extension NewMessageController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

//MARK: - UISearchBarDelegate
extension NewMessageController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterContentForSearchText(searchText)
        self.listUserTableView.reloadData()
    }
    
}


//MARK: - UITextViewDelegate
extension NewMessageController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        self.placeHolderLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.placeHolderLabel.isHidden = false
            self.sendButton.isUserInteractionEnabled = false
            self.sendButton.setTitleColor(Theme.shared.grayTextColor, for: .normal)
        } else {
            self.sendButton.isUserInteractionEnabled = true
            self.placeHolderLabel.isHidden = true
            self.sendButton.setTitleColor(Theme.shared.primaryColor, for: .normal)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.sendButton.isUserInteractionEnabled = false
            self.sendButton.setTitleColor(Theme.shared.grayTextColor, for: .normal)
        } else {
            self.sendButton.isUserInteractionEnabled = true
            self.sendButton.setTitleColor(Theme.shared.primaryColor, for: .normal)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
}




















