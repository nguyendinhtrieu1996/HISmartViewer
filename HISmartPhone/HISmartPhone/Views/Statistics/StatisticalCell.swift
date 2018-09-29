//
//  StatisticalCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/24/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit
import Charts

class StatisticalCell: BaseCollectionViewCell {
    
    //MARK: Variable
    var BPOFromToDate = BPOFromToDateManager() {
        didSet {
            if let BPOPatient = HISMartManager.share.currentPatient.BPOPatient {
                self.defaultBPO = BPOPatient
                self.numberStatisticsLabel.text = "Tổng số kết quả đo: \(self.BPOFromToDate.BPOResults.count)"
            }
        }
    }
    
    private (set) var defaultBPO = BPOPatient() {
        didSet {
            self.maxX = max(self.defaultBPO.highDiastolic, BPOFromToDate.highestDIASBPO) + 5
            self.maxY = max(self.defaultBPO.highSystolic, BPOFromToDate.highestSYSTBPO) + 5
            
            self.chartView.leftAxis.axisMaximum = Double(maxY)
            self.chartView.leftAxis.axisMinimum = 0
            self.chartView.xAxis.axisMaximum = Double(maxX)
            self.chartView.xAxis.axisMinimum = 0
            
            self.setDataCount()
            
            if (self.maxX <= 5) { return }
            if (self.maxY <= 5) { return }
            
            self.setupViewHighBPOView()
            self.setupViewPreHighBPOView()
            self.setupViewNormalBPOView()
            self.setupViewLowBPOView()
        }
    }
    
    private var maxX: Int = 0
    private var maxY: Int = 0
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //MARK: UIControl
    private let scrollView = BaseScrollView()
    
    //MARK: BPO
    private let highBPOView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.veryHightStatisticColor
        return  view
    }()
    
    private let preHighBPOView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.hightStatisticColor
        return  view
    }()
    
    private let normalBPOView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.normalStatisticColor
        return  view
    }()
    private let lowBPOView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.lowStatisticColor
        return  view
    }()
    
    fileprivate let chartView = ScatterChartView()
    
    private let numberStatisticsLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    //MARK: Initialize
    override func setupView() {
        
        self.setupViewScrollView()
        self.scrollView.view.addSubview(self.highBPOView)
        self.scrollView.view.addSubview(self.preHighBPOView)
        self.scrollView.view.addSubview(self.normalBPOView)
        self.scrollView.view.addSubview(self.lowBPOView)
        self.setupViewChartView()
        self.setupViewNumberStatisticsLabel()
        
        self.setupChartView()
    }
    
    private func setupChartView() {
        chartView.setExtraOffsets(left: 5, top: 5, right: 5, bottom: 5)
        
        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.maxVisibleCount = 200
        chartView.pinchZoomEnabled = false
        chartView.drawBordersEnabled = false
        
        chartView.legend.enabled = false
        chartView.xAxis.gridLineWidth = 0
        chartView.leftAxis.gridLineWidth = 0
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.font = .systemFont(ofSize: Dimension.shared.captionFontSize, weight: .light)
        l.xOffset = 5
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: Dimension.shared.captionFontSize, weight: .light)
        leftAxis.axisMinimum = 0
        
        chartView.rightAxis.enabled = false
        
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: Dimension.shared.captionFontSize, weight: .light)
    }
    
    func setDataCount() {
        let values1 = (0..<self.BPOFromToDate.BPOResults.count).map { (i) -> ChartDataEntry in
            let val = Double(self.BPOFromToDate.BPOResults[i].SYST)
            let index = Double(self.BPOFromToDate.BPOResults[i].DIAS)
            
            print(index, val)
            
            return ChartDataEntry(x: index, y: val)
        }
        
        let set1 = ScatterChartDataSet(values: values1, label: "")
        set1.setScatterShape(.circle)
        set1.setColor(Theme.shared.defaultTextColor)
        set1.scatterShapeSize = 8
        
        let data = ScatterChartData(dataSets: [set1])
        data.setValueFont(.systemFont(ofSize: 0, weight: .light))
        
        chartView.data = data
        
        self.setupChartView()
    }
    
    //MARK: SetupView
    private func setupViewScrollView() {
        self.addSubview(self.scrollView)
        
        if #available(iOS 11, *) {
            self.scrollView.snp.makeConstraints { (make) in
                make.edges.equalTo(self.safeAreaLayoutGuide)
            }
        } else {
            self.scrollView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    private func setupViewHighBPOView() {
        let offSet = chartView.getOffsets()
        
        let w: CGFloat = Dimension.shared.widthChartView - offSet.left - offSet.right
        let h: CGFloat = Dimension.shared.widthChartView - offSet.top - offSet.bottom
        
        self.highBPOView.snp.remakeConstraints { (make) in
            make.width.equalTo(w)
            make.height.equalTo(h)
            make.left.equalTo(self.chartView).offset(offSet.left)
            make.bottom.equalTo(self.chartView).offset(-offSet.bottom)
        }
    }
    
    private func setupViewPreHighBPOView() {
        let offSet = chartView.getOffsets()
        let mH: CGFloat = CGFloat(self.defaultBPO.highSystolic) / CGFloat(self.maxY)
        let mW: CGFloat = CGFloat(self.defaultBPO.highDiastolic) /  CGFloat(self.maxX)
        let w: CGFloat = (Dimension.shared.widthChartView - offSet.left - offSet.right) * mW
        let h: CGFloat = (Dimension.shared.widthChartView - offSet.top - offSet.bottom) * mH
        
        self.preHighBPOView.snp.makeConstraints { (make) in
            make.width.equalTo(w)
            make.height.equalTo(h)
            make.left.equalTo(self.chartView).offset(offSet.left)
            make.bottom.equalTo(self.chartView).offset(-offSet.bottom)
        }
    }
    
    private func setupViewNormalBPOView() {
        let offSet = chartView.getOffsets()
        let mH: CGFloat = CGFloat(self.defaultBPO.preHighSystolic) / CGFloat(self.maxY)
        let mW: CGFloat = CGFloat(self.defaultBPO.preHighDiastolic) /  CGFloat(self.maxX)
        let w: CGFloat = (Dimension.shared.widthChartView - offSet.left - offSet.right) * mW
        let h: CGFloat = (Dimension.shared.widthChartView - offSet.top - offSet.bottom) * mH
        
        self.normalBPOView.snp.makeConstraints { (make) in
            make.width.equalTo(w)
            make.height.equalTo(h)
            make.left.equalTo(self.chartView).offset(offSet.left)
            make.bottom.equalTo(self.chartView).offset(-offSet.bottom)
        }
    }
    
    private func setupViewLowBPOView() {
        let offSet = chartView.getOffsets()
        let mH: CGFloat = CGFloat(self.defaultBPO.lowSystolic) / CGFloat(self.maxY)
        let mW: CGFloat = CGFloat(self.defaultBPO.lowDiastolic) /  CGFloat(self.maxX)
        let w: CGFloat = (Dimension.shared.widthChartView - offSet.left - offSet.right) * mW
        let h: CGFloat = (Dimension.shared.widthChartView - offSet.top - offSet.bottom) * mH
        
        self.lowBPOView.snp.makeConstraints { (make) in
            make.width.equalTo(w)
            make.height.equalTo(h)
            make.left.equalTo(self.chartView).offset(offSet.left)
            make.bottom.equalTo(self.chartView).offset(-offSet.bottom)
        }
    }
    
    private func setupViewChartView() {
        let margin: CGFloat = (UIScreen.main.bounds.width - Dimension.shared.widthChartView) / 2
        self.scrollView.view.addSubview(self.chartView)
        
        self.chartView.snp.remakeConstraints { (make) in
            make.width.height.equalTo(Dimension.shared.widthChartView)
            make.left.equalToSuperview().offset(margin)
            make.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewNumberStatisticsLabel() {
        self.scrollView.view.addSubview(self.numberStatisticsLabel)
        
        if #available(iOS 11, *) {
            self.numberStatisticsLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(self.safeAreaLayoutGuide).offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.chartView.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
                make.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
            })
        } else {
            self.numberStatisticsLabel.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.chartView.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
                make.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
            })
        }
    }
    
}






