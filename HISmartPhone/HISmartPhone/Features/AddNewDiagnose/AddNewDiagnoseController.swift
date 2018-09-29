//
//  AddNewDiagnoseController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/26/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

protocol AddNewDiagnoseControllerDelegate: class {
    func updateDiagnose(_ diagnose: Diagnose)
}

class AddNewDiagnoseController: BaseViewController {
    
    enum TypeTextField: Int {
        case sick = 0, diagnose, directionSolution, solution, advice
    }
    
    //MARK: Variable
    var diagnose = Diagnose() {
        didSet {
            self.sickTextField.text = self.diagnose.mainSick
            self.diagnoseTextField.text = self.diagnose.diagnose
            self.directionSolutionTextField.text = self.diagnose.solution
            self.solutionTextField.text = self.diagnose.solve
            self.adviceTextField.text = self.diagnose.advice
        }
    }
    
    var isEditDiagnose: Bool = false {
        didSet {
            self.diagnoseBackingValue = self.diagnose.copy() as? Diagnose ?? Diagnose()
        }
    }
    
    fileprivate var diagnoseBackingValue: Diagnose?
    fileprivate var isAllowTapSaveButton = true
    var delegate: AddNewDiagnoseControllerDelegate?
    
    //MARK: UIControl
    private var scrollView = UIScrollView()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private let contentTitleView: UIView = {
        let viewConfig = UIView()
        
        viewConfig.backgroundColor = Theme.shared.primaryColor
        viewConfig.makeShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 1.0, radius: 4.0)
        
        return viewConfig
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Chẩn đoán và Hướng dẫn điều trị"
        label.textColor = Theme.shared.defaultTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    //SICK
    private let sickLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Tên bệnh:"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private lazy var sickTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.placeholder = "Nhập tên bệnh"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        
        return textfieldConfig
    }()
    
    private let sickLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    //DIAGNOSE
    private let diagnoseLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Chẩn đoán:"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private lazy var diagnoseTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.placeholder = "Nhập chẩn đoán"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        
        return textfieldConfig
    }()
    
    private let diagnoseLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    //DIRECTION SOLUTION
    private let directionSolutionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Hướng xử lý:"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private lazy var directionSolutionTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.placeholder = "Nhập hướng xử lí"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        
        return textfieldConfig
    }()
    
    private let directionSolutionLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    //SOLUTION
    private let solutionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Xử lý:"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private lazy var solutionTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.placeholder = "Nhập xử lí"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        
        return textfieldConfig
    }()
    
    private let solutionLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    //ADVICE
    private let adviceLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Lời dặn:"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private lazy var adviceTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.placeholder = "Nhập lời dặn"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        
        return textfieldConfig
    }()
    
    private let adviceLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    //MARK: Initialize
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    override func setupView() {
        self.setupViewNavigationBar()
        self.setupViewContaintTitleView()
        self.setupViewTitleLabel()
        self.adTargetForTextField()
        self.setupViewContainerView()
        self.setupViewScrollView()
        
        //SICK
        self.setupViewSickTitle()
        self.setupViewSickLineDivider()
        self.setupViewSickTextField()
        
        //DIAGNOSE
        self.setupViewDiagnoseTitle()
        self.setupViewDiagnoseLineDivider()
        self.setupViewDiagnoseTextField()
        
        //DIRECTION SOLUTION
        self.setupViewDriectionSolutionTitle()
        self.setupViewDirectionLineDivider()
        self.setupViewDirectionSolutionTextField()
        
        //SOLUTION
        self.setupViewSolutionTitleLabel()
        self.setupViewSolutionLineDivider()
        self.setupViewSolutionTextField()
        
        //ADVICE
        self.setupViewAdviceTitleLabel()
        self.setupViewAdviceLineDivider()
        self.setupViewAdviceTextField()
    }
    
    //MARK: Handle UIControl
    @objc func handleCloseButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSaveButton() {
        if self.isAllowTapSaveButton {
            self.addHideSaveItem()
            self.view.endEditing(true)
            self.isAllowTapSaveButton = false
            
            self.sickTextField.isUserInteractionEnabled = false
            self.diagnoseTextField.isUserInteractionEnabled = false
            self.directionSolutionTextField.isUserInteractionEnabled = false
            self.solutionTextField.isUserInteractionEnabled = false
            self.adviceTextField.isUserInteractionEnabled = false
            
            AddNewDiagnoseFacade.updateNewValue(diagnose: self.diagnose, completionHandler: {
                NotificationCenter.default.post(name: NSNotification.Name.init(Notification.Name.updateListDiagnose), object: nil)
                
                self.delegate?.updateDiagnose(self.diagnose)
                self.navigationController?.popViewController(animated: true)
            }, errorHandler: {
                self.addShowSaveItem()
                
                self.isAllowTapSaveButton = true
                self.sickTextField.isUserInteractionEnabled = true
                self.diagnoseTextField.isUserInteractionEnabled = true
                self.directionSolutionTextField.isUserInteractionEnabled = true
                self.solutionTextField.isUserInteractionEnabled = true
                self.adviceTextField.isUserInteractionEnabled = true
            })
            
        } else {
            //Do not fill all data
        }
    }
    
    @objc func handleBeginEditTextField(_ textField: UITextField) {
        let typeTextField: TypeTextField = TypeTextField.init(rawValue: textField.tag) ?? TypeTextField.sick
        
        switch typeTextField {
        case .sick:
            self.sickLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case .diagnose:
            self.diagnoseLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case .directionSolution:
            self.directionSolutionLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case .solution:
            self.solutionLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case .advice:
            self.adviceLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        }
    }
    
    @objc func handleEditingValueTextField(_ textField: UITextField) {
        let typeTextField: TypeTextField = TypeTextField.init(rawValue: textField.tag) ?? TypeTextField.sick
        guard let text = textField.text else { return }
        
        switch typeTextField {
        case .sick:
            self.diagnose.setMainSick(text)
            break
        case .diagnose:
            self.diagnose.setDiagnose(text)
            break
        case .directionSolution:
            self.diagnose.setSolution(text)
            break
        case .solution:
            self.diagnose.setSolve(text)
            break
        case .advice:
            self.diagnose.setAdvice(text)
            break
        }
        
        self.checkAllowTapSaveButton()
    }
    
    @objc func handleEndEditTextField(_ textField: UITextField) {
        let typeTextField: TypeTextField = TypeTextField.init(rawValue: textField.tag) ?? TypeTextField.sick
        
        switch typeTextField {
        case .sick:
            self.sickLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case .diagnose:
            self.diagnoseLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case .directionSolution:
            self.directionSolutionLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case .solution:
            self.solutionLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case .advice:
            self.adviceLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        }
    }
    
    //MARK: Featute
    private func checkAllowTapSaveButton() {
//        if self.diagnose.isFillAllData() {
//            if self.isEditDiagnose {
//                if self.diagnose.equal(with: self.diagnoseBackingValue ?? Diagnose()) {
//                    self.addHideSaveItem()
//                    self.isAllowTapSaveButton = false
//                } else {
//                    self.addShowSaveItem()
//                    self.isAllowTapSaveButton = true
//                }
//            } else {
//                self.addShowSaveItem()
//                self.isAllowTapSaveButton = true
//            }
//        } else {
//            self.addHideSaveItem()
//            self.isAllowTapSaveButton = false
//        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.setupViewScrollView()
    }
    
    private func adTargetForTextField() {
        //TAG
        self.sickTextField.tag = 0
        self.diagnoseTextField.tag = 1
        self.directionSolutionTextField.tag = 2
        self.solutionTextField.tag = 3
        self.adviceTextField.tag = 4
        
        //ADD TARGET BEGIN EDIT TEXTFIELD
        self.sickTextField.addTarget(self, action: #selector(handleBeginEditTextField(_:)), for: .editingDidBegin)
        self.diagnoseTextField.addTarget(self, action: #selector(handleBeginEditTextField(_:)), for: .editingDidBegin)
        self.directionSolutionTextField.addTarget(self, action: #selector(handleBeginEditTextField(_:)), for: .editingDidBegin)
        self.solutionTextField.addTarget(self, action: #selector(handleBeginEditTextField(_:)), for: .editingDidBegin)
        self.adviceTextField.addTarget(self, action: #selector(handleBeginEditTextField(_:)), for: .editingDidBegin)
        
        //ADD TARGET EDIT VALUE TEXTFIELD
        self.sickTextField.addTarget(self, action: #selector(handleEditingValueTextField(_:)), for: .editingChanged)
        self.diagnoseTextField.addTarget(self, action: #selector(handleEditingValueTextField(_:)), for: .editingChanged)
        self.directionSolutionTextField.addTarget(self, action: #selector(handleEditingValueTextField(_:)), for: .editingChanged)
        self.solutionTextField.addTarget(self, action: #selector(handleEditingValueTextField(_:)), for: .editingChanged)
        self.adviceTextField.addTarget(self, action: #selector(handleEditingValueTextField(_:)), for: .editingChanged)
        
        //ADD TARGET END EDIT TEXTFIELD
        self.sickTextField.addTarget(self, action: #selector(handleEndEditTextField(_:)), for: .editingDidEnd)
        self.diagnoseTextField.addTarget(self, action: #selector(handleEndEditTextField(_:)), for: .editingDidEnd)
        self.directionSolutionTextField.addTarget(self, action: #selector(handleEndEditTextField(_:)), for: .editingDidEnd)
        self.solutionTextField.addTarget(self, action: #selector(handleEndEditTextField(_:)), for: .editingDidEnd)
        self.adviceTextField.addTarget(self, action: #selector(handleEndEditTextField(_:)), for: .editingDidEnd)
    }
    
    //MARK: SetupView
    private func setupViewNavigationBar() {
        //CLOSE
        self.navigationItem.addLeftBarItem(with: UIImage(named: "clear_white"), target: self, selector: #selector(handleCloseButton), title: nil)
        
       self.addShowSaveItem()
    }
    
    private func addHideSaveItem() {
        let image = UIImageView(image: UIImage.init(named: "SaveHideItem"))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSaveButton))
        image.addGestureRecognizer(tapGesture)
        let imageItem = UIBarButtonItem.init(customView: image)
        self.navigationItem.rightBarButtonItem = imageItem
    }
    
    private func addShowSaveItem() {
        let image = UIImageView(image: UIImage.init(named: "SaveItemShow"))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSaveButton))
        image.addGestureRecognizer(tapGesture)
        let imageItem = UIBarButtonItem.init(customView: image)
        self.navigationItem.rightBarButtonItem = imageItem
    }
    
    private func setupViewContainerView() {
        self.view.addSubview(self.containerView)
        
        self.containerView.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalToSuperview()
            make.top.equalTo(self.contentTitleView.snp.bottom)
        }
    }
    
    private func setupViewScrollView() {
        self.containerView.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if UIDevice.current.orientation.isPortrait {
            self.scrollView.isScrollEnabled = false
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                                 height: UIScreen.main.bounds.height)
        } else {
            self.scrollView.isScrollEnabled = true
            let height = UIScreen.main.bounds.height
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                                 height: height)
        }
        
    }
    
    private func setupViewContaintTitleView() {
        self.view.addSubview(self.contentTitleView)
        
        if #available(iOS 11, *) {
            self.contentTitleView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.height.equalTo(55)
                make.top.equalTo(self.view.safeAreaInsets)
            }
        } else {
            self.contentTitleView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.height.equalTo(55)
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
        }
    }
    
    private func setupViewTitleLabel() {
        self.contentTitleView.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    //SICK
    private func setupViewSickTitle() {
        self.scrollView.addSubview(self.sickLabel)
        
        if #available(iOS 11, *) {
            self.sickLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.normalHorizontalMargin)
                
                make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_32)
            }
        } else {
            self.sickLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_32)
            }
        }
    }
    
    private func setupViewSickLineDivider() {
        self.scrollView.addSubview(self.sickLineDivider)
        
        if #available(iOS 11, *) {
            self.sickLineDivider.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(123 * Dimension.shared.widthScale)
                make.right.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(-Dimension.shared.mediumHorizontalMargin)
                make.bottom.equalTo(self.sickLabel)
                make.height.equalTo(Dimension.shared.heightLineDivider)
            }
        } else {
            self.sickLineDivider.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(123 * Dimension.shared.widthScale)
                make.right.equalToSuperview()
                    .offset(-Dimension.shared.mediumHorizontalMargin)
                make.bottom.equalTo(self.sickLabel)
                make.height.equalTo(Dimension.shared.heightLineDivider)
            }
        }
    }
    
    private func setupViewSickTextField() {
        self.scrollView.addSubview(self.sickTextField)
        
        self.sickTextField.snp.makeConstraints { (make) in
            make.right.equalTo(self.sickLineDivider).offset(-Dimension.shared.smallHorizontalMargin)
            make.left.equalTo(self.sickLineDivider).offset(Dimension.shared.smallHorizontalMargin)
            make.bottom.equalTo(self.sickLineDivider.snp.top)
                .offset(-Dimension.shared.smallVerticalMargin)
        }
    }
    
    //DIAGNOSE
    private func setupViewDiagnoseTitle() {
        self.scrollView.addSubview(self.diagnoseLabel)
        
        self.diagnoseLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.sickLabel)
            make.top.equalTo(self.sickLabel.snp.bottom).offset(Dimension.shared.largeVerticalMargin_32)
        }
    }
    
    private func setupViewDiagnoseLineDivider() {
        self.scrollView.addSubview(self.diagnoseLineDivider)
        
        self.diagnoseLineDivider.snp.makeConstraints { (make) in
            make.right.left.equalTo(self.sickLineDivider)
            make.bottom.equalTo(self.diagnoseLabel)
            make.height.equalTo(Dimension.shared.heightLineDivider)
            
        }
    }
    
    private func setupViewDiagnoseTextField() {
        self.scrollView.addSubview(self.diagnoseTextField)
        
        self.diagnoseTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.sickTextField)
            make.bottom.equalTo(self.diagnoseLineDivider.snp.top)
                .offset(-Dimension.shared.smallVerticalMargin)
        }
    }
    
    //DIRECTION SOLUTION
    private func setupViewDriectionSolutionTitle() {
        self.scrollView.addSubview(self.directionSolutionLabel)
        
        self.directionSolutionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.sickLabel)
            make.top.equalTo(self.diagnoseLabel.snp.bottom).offset(Dimension.shared.largeVerticalMargin_42)
        }
    }
    
    private func setupViewDirectionLineDivider() {
        self.scrollView.addSubview(self.directionSolutionLineDivider)
        
        self.directionSolutionLineDivider.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.sickLineDivider)
            make.bottom.equalTo(self.directionSolutionLabel)
            make.height.equalTo(Dimension.shared.heightLineDivider)
            
        }
    }
    
    private func setupViewDirectionSolutionTextField() {
        self.scrollView.addSubview(self.directionSolutionTextField)
        
        self.directionSolutionTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.sickTextField)
            make.bottom.equalTo(self.directionSolutionLineDivider.snp.top)
                .offset(-Dimension.shared.smallVerticalMargin)
        }
    }
    
    //SOLUTION
    private func setupViewSolutionTitleLabel() {
        self.scrollView.addSubview(self.solutionLabel)
        
        self.solutionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.directionSolutionLabel)
            make.top.equalTo(self.directionSolutionLabel.snp.bottom).offset(29 * Dimension.shared.heightScale)
        }
    }
    
    private func setupViewSolutionLineDivider() {
        self.scrollView.addSubview(self.solutionLineDivider)
        
        self.solutionLineDivider.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.directionSolutionLineDivider)
            make.bottom.equalTo(self.solutionLabel)
            make.height.equalTo(Dimension.shared.heightLineDivider)
            
        }
    }
    
    private func setupViewSolutionTextField() {
        self.scrollView.addSubview(self.solutionTextField)
        
        self.solutionTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.directionSolutionTextField)
            make.bottom.equalTo(self.solutionLineDivider.snp.top)
                .offset(-Dimension.shared.smallVerticalMargin)
        }
    }
    
    //ADVICE
    private func setupViewAdviceTitleLabel() {
        self.scrollView.addSubview(self.adviceLabel)
        
        self.adviceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.directionSolutionLabel)
            make.top.equalTo(self.solutionLabel.snp.bottom).offset(29 * Dimension.shared.heightScale)
        }
    }
    
    private func setupViewAdviceLineDivider() {
        self.scrollView.addSubview(self.adviceLineDivider)
        
        self.adviceLineDivider.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.directionSolutionLineDivider)
            make.bottom.equalTo(self.adviceLabel)
            make.height.equalTo(Dimension.shared.heightLineDivider)
            
        }
    }
    
    private func setupViewAdviceTextField() {
        self.scrollView.addSubview(self.adviceTextField)
        
        self.adviceTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.directionSolutionTextField)
            make.bottom.equalTo(self.adviceLineDivider.snp.top)
                .offset(-Dimension.shared.smallVerticalMargin)
        }
    }
}






