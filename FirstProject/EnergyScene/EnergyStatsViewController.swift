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
    
    var dayIndex = 0
    
    var everyDayData: [[DataModel]] = []
    
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
        lineView.gridBackgroundColor = .init(hex: 0x1D3752)
        lineView.dragEnabled = false // 是否能拖动
        lineView.scaleXEnabled = false // x轴缩放
        lineView.scaleYEnabled = false // y轴缩放
        lineView.xAxis.labelPosition = .bottom // x坐标显示位置
        lineView.xAxis.drawGridLinesEnabled = true
        lineView.xAxis.labelFont = .systemFont(ofSize: 10, weight: .regular)
        lineView.xAxis.labelTextColor = .init(hex: 0x000000, a: 0.3)
        lineView.xAxis.gridColor = .init(hex: 0xFFFFFF, a: 0.1) // 网格线颜色
        lineView.xAxis.gridLineWidth = 0.5 // 网格线宽度
        lineView.xAxis.axisLineColor = .init(hex: 0xFFFFFF, a: 0.1) // x坐标轴颜色
        lineView.xAxis.axisLineWidth = 0.5 // x坐标轴宽度
        lineView.xAxis.axisMinimum = 0
        lineView.xAxis.axisMaximum = 24
        lineView.delegate = self
        let markerView = LineViewMarker(frame: .init(x: 0, y: 0, width: 200, height: 50))
        markerView.delegate = self
        lineView.marker = markerView
        lineView.drawMarkers = true
        return lineView
    }()
    
//    var optionBaseTag: Int {
//        1000
//    }
    
//    var optionBtns: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupSubviews()
        makeConstraints()
    }
    
    func setupData() {
        for _ in 0...3 {
            let tmp: [DataModel] = [
                .init(type: .SmartImported, powerValues: makePower()),
                .init(type: .EmergencyImported, powerValues: makePower()),
                .init(type: .PeakShavingTrggered, powerValues: makePower()),
                .init(type: .PeakPowerExceeds, powerValues: makePower())
            ]
            everyDayData.append(tmp)
        }
        dayIndex = 0
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
        checkSwitchBtnState()
        resetLineViewData()
//        for (index, data) in datas.enumerated() {
//            let btn = UIButton()
//            btn.titleLabel?.font = .systemFont(ofSize: 10, weight: .regular)
//            btn.setTitle(data.name, for: .normal)
//            btn.setTitleColor(.init(hex: 0xFFFFFF, a: 0.5), for: .normal)
//            btn.setImage(.init(named: data.imgName), for: .normal)
//            btn.addTarget(self, action: #selector(optionHandle), for: .touchUpInside)
//            btn.tag = optionBaseTag + index
//            optionBtns.append(btn)
//            view.addSubview(btn)
//        }
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
//        var offSetX: CGFloat = 18
//        var offSetY: CGFloat = 0
//        for (index, data) in datas.enumerated() {
//            guard index < optionBtns.count else { break }
//            if offSetX > view.mWidth {
//                offSetX = 18
//                offSetY += 14 + 8
//            }
//            let optionBtn = optionBtns[index]
//            optionBtn.snp.makeConstraints { make in
//                make.left.equalToSuperview().inset(offSetX)
//                make.top.equalTo(lineView.snp.bottom).offset(offSetY)
//            }
//            
//            offSetX += 20 + 14 + data.name.mTextWidth(font: .systemFont(ofSize: 10, weight: .regular))
//        }
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
        var nowValue: Double = Double(Int.random(in: 0...5))
        while tmp <= endTime {
            let isIncrease = Int.random(in: 1...10) % 2 == 0
            nowValue = nowValue + (isIncrease ? 0.5 : -0.5)
            if nowValue > maxValue {
                nowValue = maxValue
            } else if nowValue < 0 {
                nowValue = 0
            }
            ret.append((tmp, nowValue))
            tmp += unit
        }
        return ret
    }
    
}

// MARK: - view refresh
extension EnergyStatsViewController {
    
    func resetLineViewData() {
        let datas = everyDayData[dayIndex]
        
        var maxYValue = 0.0
        for data in datas {
            if let maxValue = data.powerValues.map({ $0.1 }).max() {
                maxYValue = max(maxYValue, maxValue)
            }
        }
        totalKWH.text = "\(maxYValue)"
        
        lineView.leftAxis.axisMinimum = 0
        lineView.leftAxis.axisMaximum = Double(maxYValue)
        lineView.drawGridBackgroundEnabled = true
        lineView.leftAxis.labelTextColor = .init(hex: 0x000000, a: 0.3)
        
        lineView.rightAxis.enabled = false
        
        var sets: [LineChartDataSet] = []
        for data in datas {
            let entrys: [ChartDataEntry] = data.powerValues.map({ .init(x: $0.0, y: $0.1) })
            let set: LineChartDataSet = .init(entries: entrys, label: data.type.getName())
            set.drawCirclesEnabled = false // 是否绘制数据点
            
            set.fillColor = data.type.getDrawColor() // 设置填充颜色
            set.drawFilledEnabled = true // 开启填充
            set.fillAlpha = 0.5 // 填充透明度
            
            set.lineWidth = 0.5 // 折线宽度
            set.setColor(data.type.getDrawColor()) // 连线颜色
            sets.append(set)
        }
        
        lineView.data = LineChartData(dataSets: sets)
    }
    
    func checkSwitchBtnState() {
        if everyDayData.count == 0 {
            lastDayBtn.isEnabled = false
            nextDayBtn.isEnabled = false
        } else {
            if dayIndex == 0 {
                lastDayBtn.isEnabled = false
                nextDayBtn.isEnabled = true
            } else if dayIndex == everyDayData.count - 1 {
                lastDayBtn.isEnabled = true
                nextDayBtn.isEnabled = false
            } else {
                lastDayBtn.isEnabled = true
                nextDayBtn.isEnabled = true
            }
        }
    }
    
    func updatePowerDetail(index: Int) {
        let typeArr = everyDayData[dayIndex]
        guard let first = typeArr.first else {
            print("[\(NSStringFromClass(Self.self))-\(#function):\(#line)] 数据未初始化")
            return
        }
        guard !first.powerValues.isEmpty, index >= 0 && index < first.powerValues.count else {
            print("[\(NSStringFromClass(Self.self))-\(#function):\(#line)] index: \(index)越界")
            return
        }
        
        for typeData in typeArr {
            guard typeData.type == .EmergencyImported else {
                continue
            }
            
            powerPeakValue.text = "\(typeData.powerValues[index].1)"
        }
    }
}

// MARK: - target
extension EnergyStatsViewController {
    
    @objc func lastDayHandle() {
        guard dayIndex - 1 >= 0 else { return }
        
        dayIndex -= 1
        
        checkSwitchBtnState()
        
        resetLineViewData()
    }
    
    @objc func nextDayHandle() {
        guard dayIndex + 1 < everyDayData.count else { return }
        
        dayIndex += 1
        
        checkSwitchBtnState()
        
        resetLineViewData()
    }
    
    @objc func optionHandle(_ btn: UIButton) {
        
    }
}

// MARK: - ChartViewDelegate
extension EnergyStatsViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("[\(NSStringFromClass(Self.self))-\(#function):\(#line)] x: \(entry.x) y: \(entry.y)")
        
        let x = round(entry.x * 10) / 10.0
        let index = Int(x / 0.2)
        updatePowerDetail(index: index)
    }
}

extension EnergyStatsViewController {

    struct DataModel {
        
        let type: PowerType
        
        let powerValues: [(Double, Double)]
    }
    
    enum PowerType {
        case SmartImported
        case EmergencyImported
        case PeakShavingTrggered
        case PeakPowerExceeds
        
        func getName() -> String {
            switch self {
            case .SmartImported:
                return "Smart Imported"
            case .EmergencyImported:
                return "Emergency Imported"
            case .PeakShavingTrggered:
                return "Peak Shaving Triggered"
            case .PeakPowerExceeds:
                return "Peak Power Exceeds"
            }
        }
            
        func getImageName() -> String {
            switch self {
            case .SmartImported:
                return "smart_imported_btn"
            case .EmergencyImported:
                return "emergency_imported_btn"
            case .PeakShavingTrggered:
                return "peak_shaving_triggered_btn"
            case .PeakPowerExceeds:
                return "peak_power_exceeds_btn"
            }
        }
        
        func getDrawColor() -> UIColor {
            switch self {
            case .SmartImported:
                return .init(hex: 0xBBBBBB)
            case .EmergencyImported:
                return .init(hex: 0xFF778F)
            case .PeakShavingTrggered:
                return .init(hex: 0x6FCEF4)
            case .PeakPowerExceeds:
                return .init(hex: 0xFF9335)
            }
        }
    }
}

// MARK: - LineViewMarkerDelegate
extension EnergyStatsViewController: LineViewMarkerDelegate {
    
    func contentValue(entry: ChartDataEntry) -> NSAttributedString {
        let typeArr = everyDayData[dayIndex]
        
        let attr = NSMutableAttributedString()
        for typeData in typeArr {
            for value in typeData.powerValues {
                if value.0 == entry.x {
                    if typeData.type == .PeakShavingTrggered {
                        attr.append(.init(string: formatNumberToTime(number: value.0), attributes: [.font : UIFont.systemFont(ofSize: 10, weight: .regular), .foregroundColor : UIColor(hex: 0xFFFFFF, a: 0.5)]))
                        attr.append(.init(string: "(\(typeData.type.getName()))", attributes: [.font : UIFont.systemFont(ofSize: 10, weight: .regular), .foregroundColor : UIColor(hex: 0xFFFFFF, a: 0.3)]))
                    } else {
                        attr.append(.init(string: typeData.type.getName(), attributes: [.font : UIFont.systemFont(ofSize: 10, weight: .regular), .foregroundColor : UIColor(hex: 0xFFFFFF, a: 0.3)]))
                        attr.append(.init(string: " \(value.1)kW", attributes: [.font : UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor : UIColor(hex: 0xFFFFFF)]))
                    }
                    break
                }
            }
        }
        
        return attr
    }
    
    
    /// 数值转时间格式
    /// - Parameter number: 0～24
    /// - Returns: 12->12:00, 12.5->12:30
    func formatNumberToTime(number: Double) -> String {
        // 确保数值在 0~24 范围内
        let clamped = max(0, min(24, number))
        
        // 提取小时（整数部分）
        let hours = Int(clamped)
        
        // 提取分钟（小数部分 * 60，四舍五入）
        let minutes = Int(round((clamped - Double(hours)) * 60))
        
        // 格式化（补零确保两位数）
        return String(format: "%02d:%02d", hours, minutes)
    }
}

