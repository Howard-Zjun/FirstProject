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
    
    lazy var waveAnimationView: WaveAnimationView = {
        let waveAnimationView = WaveAnimationView()
        return waveAnimationView
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
    }
    
    func setupSubviews() {
        view.backgroundColor = .init(hex: 0x2B445E)
        view.addSubview(titleLab)
        view.addSubview(equipmentCabinetImgV)
        equipmentCabinetImgV.addSubview(waveAnimationView)
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
        waveAnimationView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(195 * CGFloat(value) / 100.0)
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
}

extension BatteryViewController {
    
    class WaveAnimationView: UIView {
        
        // y =Asin(ωx + φ）+ k
        
        // 振幅A
        var waveAlpha: CGFloat {
            5
        }
        
        /// 角速度ω
        var omega: CGFloat {
            CGFloat.pi * 2 / mWidth
        }
        
        /// 初相φ
        var phi1: CGFloat = 0
        
        var phi2: CGFloat = CGFloat.pi * 0.5
        
        lazy var forwardWaveLayer: CAShapeLayer = {
            let forwardWaveLayer = CAShapeLayer()
            forwardWaveLayer.fillColor = UIColor(hex: 0xE39400, a: 0.3).cgColor
            return forwardWaveLayer
        }()
        
        lazy var backWaveLayer: CAShapeLayer = {
            let backWaveLayer = CAShapeLayer()
            backWaveLayer.fillColor = UIColor(hex: 0xE39400, a: 0.5).cgColor
            return backWaveLayer
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.masksToBounds = true
            layer.addSublayer(backWaveLayer)
            layer.addSublayer(forwardWaveLayer)
            
            let link = CADisplayLink(target: self, selector: #selector(setCurrentFirstWaveLayerPath))
            link.add(to: .main, forMode: .common)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        @objc func setCurrentFirstWaveLayerPath() {
            func getPath(kappa: CGFloat, phi: CGFloat) -> CGPath {
                let path = CGMutablePath()
                path.move(to: .init(x: 0, y: mHeight))
                for x in (0...Int(mWidth)) {
                    let y = waveAlpha * CGFloat(sin(omega * CGFloat(x) + phi)) + kappa
                    path.addLine(to: .init(x: CGFloat(x), y: y))
                }
                path.addLine(to: .init(x: mWidth, y: mHeight))
                path.addLine(to: .init(x: 0, y: mHeight))
                path.closeSubpath()
                
                return path
            }
            
            forwardWaveLayer.path = getPath(kappa: -5, phi: phi1)
            
            backWaveLayer.path = getPath(kappa: 5, phi: phi2)
            
            phi1 += 0.1
            phi2 += 0.1
        }
    }
}
