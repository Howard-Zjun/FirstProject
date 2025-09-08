//
//  EnergyStatsViewController.swift
//  FirstProject
//
//  Created by Zack-Zeng on 2025/9/8.
//

import UIKit
import MyBaseExtension
import SnapKit
import DGCharts

class EnergyStatsViewController: UIViewController {

    var datas: [DataModel] = []
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel()
        nameLab.font = .systemFont(ofSize: 20, weight: .bold)
        nameLab.text = "Grid-Imported"
        nameLab.textColor = .init(hex: 0xFFFFFF, a: 0.5)
        return nameLab
    }()
    
    lazy var powerPeakLab: UILabel = {
        let powerPeakLab = UILabel()
        powerPeakLab.font = .systemFont(ofSize: 12, weight: .medium)
        powerPeakLab.text = "Emergency Imported"
        powerPeakLab.textColor = .init(hex: 0xFFFFFF, a: 0.3)
        return powerPeakLab
    }()
    
    lazy var powerPeakValue: UILabel = {
        let powerPeakValue = UILabel()
        powerPeakValue.text = "0"
        powerPeakValue.textColor = .init(hex: 0xFFFFFF)
        return powerPeakValue
    }()
    
    lazy var powerPeakValueSuffix: UILabel = {
        let powerPeakValeuSuffix = UILabel()
        powerPeakValeuSuffix.font = .systemFont(ofSize: 16, weight: .medium)
        powerPeakValeuSuffix.text = "kWh"
        powerPeakValeuSuffix.textColor = .init(hex: 0xFFFFFF)
        return powerPeakValeuSuffix
    }()
    
    lazy var totalKWH: UILabel = {
        let totalKWH = UILabel()
        totalKWH.font = .systemFont(ofSize: 32, weight: .bold)
        totalKWH.text = "0"
        totalKWH.textColor = .init(hex: 0xFAFAFA)
        return totalKWH
    }()
    
    lazy var totalKHWSuffix: UILabel = {
        let totalKHWSuffix = UILabel()
        totalKHWSuffix.font = .systemFont(ofSize: 20, weight: .bold)
        totalKHWSuffix.text = "kWh"
        totalKHWSuffix.textColor = .init(hex: 0xFFFFFF)
        return totalKHWSuffix
    }()
    
    lazy var lastDayBtn: UIButton = {
        let lastDayBtn = UIButton()
        lastDayBtn.setImage(.init(named: "power_state_last_day"), for: .normal)
        lastDayBtn.addTarget(self, action: #selector(lastDayHandle), for: .touchUpInside)
        return lastDayBtn
    }()
    
    lazy var nextDayBtn: UIButton = {
        let nextDayBtn = UIButton()
        nextDayBtn.setImage(.init(named: "power_state_next_day"), for: .normal)
        nextDayBtn.addTarget(self, action: #selector(nextDayHandle), for: .touchUpInside)
        return nextDayBtn
    }()
    
    lazy var lineView: LineChartView = {
        let lineView = LineChartView()
        lineView.backgroundColor = .init(hex: 0x1D3752)
        lineView.xAxis.labelPosition = .bottom // 限制
        lineView.xAxis.drawGridLinesEnabled = true
        lineView.xAxis.labelFont = .systemFont(ofSize: 10, weight: .regular)
        lineView.xAxis.labelTextColor = .init(hex: 0x000000, a: 0.3)
        lineView.xAxis.gridColor = .init(hex: 0xFFFFFF, a: 0.1) // 网格线颜色
        lineView.xAxis.gridLineWidth = 0.5 // 网格线宽度
        lineView.xAxis.axisLineColor = .init(hex: 0xFFFFFF, a: 0.1) // x坐标轴颜色
        lineView.xAxis.axisLineWidth = 0.5 // x坐标轴宽度
        lineView.xAxis.axisMinimum = 0
        lineView.xAxis.axisMaximum = 24
        
        var maxYValue = 0.0
        for data in datas {
            if let maxValue = data.powerValues.map({ $0.1 }).max() {
                maxYValue = max(maxYValue, maxValue)
            }
        }
        lineView.leftAxis.axisMinimum = 0
        lineView.leftAxis.axisMaximum = Double(maxYValue)
        lineView.drawGridBackgroundEnabled = true
        lineView.leftAxis.labelTextColor = .init(hex: 0x000000, a: 0.3)
        
        lineView.rightAxis.enabled = false
        
        var sets: [LineChartDataSet] = []
        for (index, data) in datas.enumerated() {
            let entrys: [ChartDataEntry] = data.powerValues.map({ .init(x: $0.0, y: $0.1) })
            let set: LineChartDataSet = .init(entries: entrys, label: "\(index)")
            set.fillColor = data.drawColor // 设置填充颜色
            set.drawFilledEnabled = true // 开启填充
            set.fillAlpha = 0.5 // 填充透明度
            set.lineWidth = 0.5 // 折线宽度
            set.circleRadius = 0 // 折点半径
            set.setColor(data.drawColor) // 连线颜色
            sets.append(set)
        }
        
        lineView.data = LineChartData(dataSets: sets)
        return lineView
    }()
    
    var optionBaseTag: Int {
        1000
    }
    
    var optionBtns: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupSubviews()
        makeConstraints()
    }
    
    func setupData() {
        datas = [
            .init(name: "Smart Imported", imgName: "smart_imported_btn", drawColor: .init(hex: 0xBBBBBB), powerValues: makePower()),
            .init(name: "Emergency Imported", imgName: "emergency_imported_btn", drawColor: .init(hex: 0xFF778F), powerValues: makePower()),
            .init(name: "Peak Shaving Triggered", imgName: "peak_shaving_triggered_btn", drawColor: .init(hex: 0x6FCEF4), powerValues: makePower()),
            .init(name: "Peak Power Exceeds", imgName: "peak_power_exceeds_btn", drawColor: .init(hex: 0xFF9335), powerValues: makePower())
        ]
    }
    
    func setupSubviews() {
        view.backgroundColor = .init(hex: 0x1D3752)
        view.addSubview(nameLab)
        view.addSubview(powerPeakLab)
        view.addSubview(powerPeakValue)
        view.addSubview(powerPeakValueSuffix)
        view.addSubview(totalKWH)
        view.addSubview(totalKHWSuffix)
        view.addSubview(lastDayBtn)
        view.addSubview(nextDayBtn)
        view.addSubview(lineView)
        for (index, data) in datas.enumerated() {
            let btn = UIButton()
            btn.titleLabel?.font = .systemFont(ofSize: 10, weight: .regular)
            btn.setTitle(data.name, for: .normal)
            btn.setTitleColor(.init(hex: 0xFFFFFF, a: 0.5), for: .normal)
            btn.setImage(.init(named: data.imgName), for: .normal)
            btn.addTarget(self, action: #selector(optionHandle), for: .touchUpInside)
            btn.tag = optionBaseTag + index
            optionBtns.append(btn)
            view.addSubview(btn)
        }
    }
    
    func makeConstraints() {
        nameLab.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(18)
            make.top.equalToSuperview().inset(50)
            make.height.equalTo(48)
        }
        powerPeakLab.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(18)
            make.top.equalTo(nameLab.snp.bottom).offset(14)
            make.height.equalTo(14)
        }
        powerPeakValue.snp.makeConstraints { make in
            make.left.equalTo(powerPeakLab)
            make.top.equalTo(powerPeakLab.snp.bottom).offset(4)
            make.height.equalTo(24)
        }
        powerPeakValueSuffix.snp.makeConstraints { make in
            make.left.equalTo(powerPeakValue.snp.right).offset(3)
            make.centerY.equalTo(powerPeakValue)
            make.height.equalTo(24)
        }
        totalKWH.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(18)
            make.bottom.equalTo(powerPeakValue)
            make.height.equalTo(24)
        }
        totalKHWSuffix.snp.makeConstraints { make in
            make.left.equalTo(totalKWH.snp.right).offset(3)
            make.bottom.equalTo(totalKWH)
            make.height.equalTo(24)
        }
        lastDayBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(totalKWH.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: 32, height: 24))
        }
        nextDayBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(lastDayBtn)
            make.size.equalTo(CGSize(width: 32, height: 24))
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.top.equalTo(totalKWH.snp.bottom).offset(100)
            make.height.equalTo(266)
        }
        var offSetX: CGFloat = 18
        var offSetY: CGFloat = 0
        for (index, data) in datas.enumerated() {
            guard index < optionBtns.count else { break }
            if offSetX > view.mWidth {
                offSetX = 18
                offSetY += 14 + 8
            }
            let optionBtn = optionBtns[index]
            optionBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(offSetX)
                make.top.equalTo(lineView.snp.bottom).offset(offSetY)
            }
            
            offSetX += 20 + 14 + data.name.mTextWidth(font: .systemFont(ofSize: 10, weight: .regular))
        }
    }
}

extension EnergyStatsViewController {
    
    /// 生成功率值
    /// - Parameters:
    ///   - beginTime: 开始时间（hour）
    ///   - endTime: 结束时间（hour）
    ///   - unit: 划分单位（hour）
    ///   - maxValue: 上限值（kW）
    /// - Returns: 功率数值
    func makePower(beginTime: Double = 0, endTime: Double = 24, unit: Double = 0.2, maxValue: Double = 10) -> [(Double, Double)] {
        var tmp = beginTime
        var ret: [(Double, Double)] = []
        while tmp <= endTime {
            ret.append((tmp, Double.random(in: 0...maxValue)))
            tmp += unit
        }
        return ret
    }
}

// MARK: - target
extension EnergyStatsViewController {
    
    @objc func lastDayHandle() {
        
    }
    
    @objc func nextDayHandle() {
        
    }
    
    @objc func optionHandle(_ btn: UIButton) {
        
    }
}

extension EnergyStatsViewController {

    struct DataModel {
        
        let name: String
        
        let imgName: String
        
        let drawColor: UIColor
        
        let powerValues: [(Double, Double)]
    }
}

