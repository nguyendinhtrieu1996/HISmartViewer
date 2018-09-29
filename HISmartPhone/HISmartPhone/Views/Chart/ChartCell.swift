//
//  ChartCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/2/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit
import Charts


class ChartCell: BaseTableViewCell {
    
    //MARK: Varible
    private var month: [String] = [] {
        didSet {
            let formmater = ChartFormatter()
            formmater.setValue(values: self.month)
            let xaxis = XAxis()
            xaxis.valueFormatter = formmater
            self.chartView.xAxis.valueFormatter = xaxis.valueFormatter
        }
    }
    
    //MARK: UIControl
    private lazy var chartView: LineChartView = {
        let chart = LineChartView()
        
        chart.delegate = self
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.gridLineWidth = 0
        chart.leftAxis.gridLineWidth = 0
        chart.chartDescription?.enabled = true
        chart.leftAxis.removeAllLimitLines()
        chart.rightAxis.enabled = false
        chart.chartDescription?.enabled = false
        chart.legend.enabled = false
        chart.scaleYEnabled = false
        
        return chart
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewChartView()
    }
    
    func drawnChart() {
        let data = LineChartData()
        let BPOManager = BPOChartManager.shared
        
        self.month = BPOChartManager.shared.getAllMonth()
        let numbers1: [Double] = BPOManager.getAllSYS()
        let numbers2: [Double] = BPOManager.getAllDIAS()
        let numbers3: [Double] = BPOManager.getAllHeartRate()
        
        //LINE Stystolic
        let lineChartStysolicDataEntry = self.getChartDataEntry(data: numbers1)
        let lineChartStystolic = LineChartDataSet(values: lineChartStysolicDataEntry, label: "Stystolic")
        lineChartStystolic.colors = [Theme.shared.systolicChartColor]
        lineChartStystolic.circleColors = [Theme.shared.systolicChartColor]
        lineChartStystolic.circleRadius = Dimension.shared.mediumCornerRadius
        lineChartStystolic.drawIconsEnabled = false
        
        //LINE Diastolic
        let lineChartDiastolicDataEntry = self.getChartDataEntry(data: numbers2)
        let lineChartDiastolic = LineChartDataSet(values: lineChartDiastolicDataEntry, label: "Diastolic")
        lineChartDiastolic.colors = [Theme.shared.diastolicChartColor]
        lineChartDiastolic.circleColors = [Theme.shared.diastolicChartColor]
        lineChartDiastolic.circleRadius = Dimension.shared.mediumCornerRadius
        
        //LINE HeartRate
        let lineChartHeartRateDataEntry = self.getChartDataEntry(data: numbers3)
        let lineChartHeartRate = LineChartDataSet(values: lineChartHeartRateDataEntry, label: "HeartRate")
        lineChartHeartRate.colors = [Theme.shared.heartRateChartColor]
        lineChartHeartRate.circleColors = [Theme.shared.heartRateChartColor]
        lineChartHeartRate.circleRadius = Dimension.shared.mediumCornerRadius
        
        
        data.addDataSet(lineChartStystolic)
        data.addDataSet(lineChartDiastolic)
        data.addDataSet(lineChartHeartRate)
        
        self.chartView.data = data
    }
    
    private func getChartDataEntry(data: [Double]) -> [ChartDataEntry] {
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0..<data.count {
            let value =  ChartDataEntry(x: Double(i), y: data[i])
            lineChartEntry.append(value)
        }
        
        return lineChartEntry
    }
    
    //MARK: SetupView
    private func setupViewChartView() {
        self.addSubview(self.chartView)
        
        self.chartView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            make.height.equalTo(Dimension.shared.widthChartView)
            make.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
            make.bottom.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
        }
    }
}

//MARK: - ChartViewDelegate
extension ChartCell: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let index = Int(entry.x)
        NotificationCenter.default.post(name: NSNotification.Name.init(Notification.Name.showInfoChartView), object: index)
        
    }
    
}











