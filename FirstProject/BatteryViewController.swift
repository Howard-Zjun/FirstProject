//
//  BatteryViewController.swift
//  FirstProject
//
//  Created by Zack-Zeng on 2025/9/9.
//

import UIKit
import MyBaseExtension
import SnapKit

class BatteryViewController: UIViewController {

    let value = Int.random(in: 0...100)
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.text = "Battery View"
        titleLab.textColor = .init(hex: 0xFFFFFF)
        titleLab.font = .systemFont(ofSize: 16, weight: .regular)
        return titleLab
    }()
    
    lazy var equipmentCabinetImgV: UIImageView = {
        let equipmentCabinetImgV = UIImageView()
        equipmentCabinetImgV.image = .init(named: "power_equipment_cabinet")
        return equipmentCabinetImgV
    }()
    
    lazy var batteryPercentImgV: UIImageView = {
        let batteryPercentImgV = UIImageView()
        batteryPercentImgV.image = .init(named: "battery_percent")
        return batteryPercentImgV
    }()
    
    lazy var percentLab: UILabel = {
        let percentLab = UILabel()
        percentLab.font = .systemFont(ofSize: 32, weight: .bold)
        percentLab.textColor = .init(hex: 0xFAFAFA)
        let attr = NSMutableAttributedString()
        attr.append(.init(string: "\(value)", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .bold)]))
        attr.append(.init(string: " %", attributes: [.font : UIFont.systemFont(ofSize: 16, weight: .regular)]))
        percentLab.attributedText = attr
        return percentLab
    }()
    
    lazy var batteryLocaltionImgV: UIImageView = {
        let batteryLocaltionImgV = UIImageView()
        batteryLocaltionImgV.image = .init(named: "battery_location")
        return batteryLocaltionImgV
    }()
    
    lazy var batteryLocaltionHintLab: UILabel = {
        let batteryLocaltionHintLab = UILabel()
        batteryLocaltionHintLab.font = .systemFont(ofSize: 10, weight: .regular)
        batteryLocaltionHintLab.textColor = .init(hex: 0xFFFFFF, a: 0.5)
        batteryLocaltionHintLab.text = "Emergency Reserve"
        batteryLocaltionHintLab.numberOfLines = 0
        return batteryLocaltionHintLab
    }()
    
    lazy var batteryBalanceTitleLab: UILabel = {
        let batteryBalanceTitleLab = UILabel()
        batteryBalanceTitleLab.font = .systemFont(ofSize: 14, weight: .regular)
        batteryBalanceTitleLab.text = "Battery Balance"
        batteryBalanceTitleLab.textColor = .init(hex: 0xFFFFFF, a: 0.3)
        return batteryBalanceTitleLab
    }()
    
    lazy var batteryBalanceValueLab: UILabel = {
        let batteryBalanceValueLab = UILabel()
        batteryBalanceValueLab.font = .systemFont(ofSize: 28, weight: .bold)
        let attr = NSMutableAttributedString()
        attr.append(.init(string: "3.9", attributes: [.font : UIFont.systemFont(ofSize: 28, weight: .bold)]))
        attr.append(.init(string: "kWh", attributes: [.font : UIFont.systemFont(ofSize: 14, weight: .regular), .baselineOffset : 0]))
        batteryBalanceValueLab.attributedText = attr
        batteryBalanceValueLab.textColor = .init(hex: 0xFAFAFA)
        return batteryBalanceValueLab
    }()
    
    lazy var batteryLastTitleLab: UILabel = {
        let batteryLastTitleLab = UILabel()
        batteryLastTitleLab.font = .systemFont(ofSize: 14, weight: .regular)
        batteryLastTitleLab.text = "Battery Lasts for"
        batteryLastTitleLab.textColor = .init(hex: 0xFFFFFF, a: 0.3)
        return batteryLastTitleLab
    }()
    
    lazy var batteryLastValueLab: UILabel = {
        let batteryLastValueLab = UILabel()
        batteryLastValueLab.font = .systemFont(ofSize: 14, weight: .regular)
        batteryLastValueLab.text = "10h05min"
        let attr = NSMutableAttributedString()
        attr.append(.init(string: "10", attributes: [.font : UIFont.systemFont(ofSize: 28, weight: .bold)]))
        attr.append(.init(string: "h", attributes: [.font : UIFont.systemFont(ofSize: 14, weight: .regular), .baselineOffset : 0]))
        attr.append(.init(string: "05", attributes: [.font : UIFont.systemFont(ofSize: 28, weight: .bold)]))
        attr.append(.init(string: "min", attributes: [.font : UIFont.systemFont(ofSize: 14, weight: .regular), .baselineOffset : 0]))
        batteryLastValueLab.attributedText = attr
        batteryLastValueLab.textColor = .init(hex: 0xFAFAFA)
        return batteryLastValueLab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        makeConstraints()
        makeWaveAnimation()
    }
    
    func setupSubviews() {
        view.backgroundColor = .init(hex: 0x2B445E)
        view.addSubview(titleLab)
        view.addSubview(equipmentCabinetImgV)
        view.addSubview(batteryPercentImgV)
        view.addSubview(percentLab)
        view.addSubview(batteryLocaltionImgV)
        view.addSubview(batteryLocaltionHintLab)
        view.addSubview(batteryBalanceTitleLab)
        view.addSubview(batteryBalanceValueLab)
        view.addSubview(batteryLastTitleLab)
        view.addSubview(batteryLastValueLab)
    }
    
    func makeConstraints() {
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(88 + 10)
            make.height.equalTo(24)
        }
        equipmentCabinetImgV.snp.makeConstraints { make in
            make.top.equalTo(titleLab.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 166, height: 240))
        }
        percentLab.snp.makeConstraints { make in
            make.centerX.equalTo(equipmentCabinetImgV)
            make.centerY.equalTo(equipmentCabinetImgV).offset(10)
            make.height.equalTo(48)
        }
        batteryPercentImgV.snp.makeConstraints { make in
            make.left.equalTo(equipmentCabinetImgV.snp.right).offset(9.5)
            make.top.equalTo(equipmentCabinetImgV).offset(35)
            make.bottom.equalTo(equipmentCabinetImgV).offset(-10)
            make.width.equalTo(3)
        }
        batteryLocaltionImgV.snp.makeConstraints { make in
            make.left.equalTo(batteryPercentImgV.snp.right).offset(3)
            make.size.equalTo(8)
            make.bottom.equalTo(batteryPercentImgV.snp.bottom).offset(Double(value) / 100.0 * -195)
        }
        batteryLocaltionHintLab.snp.makeConstraints { make in
            make.left.equalTo(batteryLocaltionImgV.snp.right).offset(12)
            make.centerY.equalTo(batteryLocaltionImgV)
            make.right.lessThanOrEqualToSuperview()
        }
        batteryBalanceTitleLab.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.left).offset(view.mWidth * 0.25)
            make.top.equalTo(equipmentCabinetImgV.snp.bottom).offset(15)
            make.height.equalTo(21)
        }
        batteryBalanceValueLab.snp.makeConstraints { make in
            make.centerX.equalTo(batteryBalanceTitleLab)
            make.top.equalTo(batteryBalanceTitleLab.snp.bottom).offset(10)
            make.height.equalTo(24) 
        }
        batteryLastTitleLab.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.right).offset(-view.mWidth * 0.25)
            make.top.equalTo(equipmentCabinetImgV.snp.bottom).offset(15)
            make.height.equalTo(21)
        }
        batteryLastValueLab.snp.makeConstraints { make in
            make.centerX.equalTo(batteryLastTitleLab)
            make.top.equalTo(batteryLastTitleLab.snp.bottom).offset(10)
            make.height.equalTo(24)
        }
    }
    
    func makeWaveAnimation() {
        let y = Double(100 - value) / 100.0 * 195.0 + 23 + 10
        let animationRect: CGRect = .init(x: 10, y: y, width: 146, height: 240 - y)
        let waveAnimation1 = CABasicAnimation(keyPath: "path")
        waveAnimation1.fromValue = generateClosedSinePath(in: animationRect)
        waveAnimation1.toValue = generateClosedSinePath(in: animationRect, phase: 2 * Double.pi)
        waveAnimation1.duration = 4
        waveAnimation1.repeatCount = .greatestFiniteMagnitude
        let layer = CAShapeLayer()
        layer.frame = animationRect
        layer.path = generateClosedSinePath(in: animationRect).cgPath
        layer.add(waveAnimation1, forKey: "key1")
        
        equipmentCabinetImgV.layer.addSublayer(layer)
    }
}

extension BatteryViewController {
    
    /// 生成正弦曲线路径
    /// - Parameters:
    ///   - frame: 路径所在的矩形区域
    ///   - amplitude: 振幅（波浪高度）
    ///   - frequency: 频率（波浪密集度）
    ///   - phase: 相位（水平偏移）
    ///   - offsetY: Y轴偏移量（控制曲线上下位置）
    /// - Returns: 生成的正弦曲线路径
    func generateSinePath(
        in frame: CGRect,
        amplitude: CGFloat = 50,
        frequency: CGFloat = 0.02,
        phase: CGFloat = 0,
        offsetY: CGFloat = 0
    ) -> UIBezierPath {
        let path = UIBezierPath()
        let width = frame.width
        let height = frame.height
        
        // 计算Y轴中点，作为正弦曲线的基准线
        let midY = height / 2 + offsetY
        
        // 从左侧开始绘制
        let startX: CGFloat = 0
        // 计算起始点的Y值
        let startY = amplitude * sin(frequency * startX + phase) + midY
        path.move(to: CGPoint(x: startX, y: startY))
        
        // 逐点绘制正弦曲线
        // 为了性能，可以适当调整步长，这里每1个点绘制一次
        for x in stride(from: 0, through: width, by: 1) {
            let xValue = CGFloat(x)
            // 正弦函数公式：y = A * sin(ωx + φ) + k
            let yValue = amplitude * sin(frequency * xValue + phase) + midY
            path.addLine(to: CGPoint(x: xValue, y: yValue))
        }
        
        return path
    }
    
    /// 生成闭合的正弦波浪路径（常用于填充效果）
    /// - Parameters:
    ///   - frame: 路径所在的矩形区域
    ///   - amplitude: 振幅（波浪高度）
    ///   - frequency: 频率（波浪密集度）
    ///   - phase: 相位（水平偏移）
    ///   - offsetY: Y轴偏移量（控制曲线上下位置）
    /// - Returns: 生成的闭合正弦波浪路径
    func generateClosedSinePath(
        in frame: CGRect,
        amplitude: CGFloat = 50,
        frequency: CGFloat = 0.02,
        phase: CGFloat = 0,
        offsetY: CGFloat = 0
    ) -> UIBezierPath {
        let path = generateSinePath(
            in: frame,
            amplitude: amplitude,
            frequency: frequency,
            phase: phase,
            offsetY: offsetY
        )
        
        // 闭合路径，连接到右下角和左下角
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.close()
        
        return path
    }
}
