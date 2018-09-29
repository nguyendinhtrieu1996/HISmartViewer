//
//  PIECell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/24/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit
import Charts

class PIECell: BaseCollectionViewCell {
    
    //MARK: Variable
    var BPOFromToDate = BPOFromToDateManager() {
        didSet {
            self.setDataCount()
            self.numberStatisticsLabel.text = "Tổng số kết quả đo: \(self.BPOFromToDate.BPOResults.count)"
        }
    }
 
    static var identifier: String {
        return String(describing: self)
    }
    
    fileprivate let parties = ["Thấp", "Bình thường", "Cao", "Rất cao"]
    
    //MARK: UIControl
    fileprivate let scrollView = BaseScrollView()
    
    fileprivate lazy var chartView: PieChartView = {
        let chartView = PieChartView()
        
        chartView.delegate = self
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: Dimension.shared.smallCaptionFontSize,
                                               weight: .light)
        
        return chartView
    }()
    
    private let numberStatisticsLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    //MARK: Initalize
    override func setupView() {
        self.setupChartView()
        self.setupViewScrollView()
        self.setupViewChartView()
        self.setupViewNumberStatisticsLabel()
        self.setDataCount()
    }
    
    //MARK: Handle Action
    
    //MARK: Feature
    func setDataCount() {
        let valuesBPO = self.BPOFromToDate.allDataForPIEChart
        let libColor = [Theme.shared.lowStatisticColor, Theme.shared.normalStatisticColor, Theme.shared.hightStatisticColor, Theme.shared.veryHightStatisticColor]
        var colors = [UIColor]()
        var entries = [PieChartDataEntry]()
        
        for (index, value) in valuesBPO.enumerated() {
            if value > 0 {
                colors.append(libColor[index])
                let pieChartData = PieChartDataEntry(value: Double(value),
                                                     label: parties[index],
                                                     icon: nil)
                
                entries.append(pieChartData)
            }
        }
        
        let set = PieChartDataSet(values: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 0
        
        set.colors =  colors
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: Dimension.shared.smallCaptionFontSize, weight: .light))
        data.setValueTextColor(.white)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    private func setupChartView() {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.0
        chartView.transparentCircleRadiusPercent = 0.0
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        chartView.drawCenterTextEnabled = true
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = false
        chartView.highlightPerTapEnabled = false
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
    }
    
    //MARK: SetupView
    private func setupViewScrollView() {
        self.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { (make) in
            make.width.height.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setupViewChartView() {
        self.scrollView.addSubview(self.chartView)
        
        self.chartView.snp.makeConstraints { (make) in
            make.width.height.equalTo(Dimension.shared.widthChartView)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_32)
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

//MARK: - ChartViewDelegate
extension PIECell: ChartViewDelegate {
}








