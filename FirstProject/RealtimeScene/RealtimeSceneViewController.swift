//
//  RealtimeSceneViewController.swift
//  FirstProject
//
//  Created by Zack-Zeng on 2025/9/10.
//

import UIKit
import MyBaseExtension
import SnapKit
import SwiftSVG

class RealtimeSceneViewController: UIViewController {

    @objc var solarPower: Int = 6 {
        didSet {
            solarValueLab.attributedText = getFormatAttr(value: solarPower)
        }
    }
    
    @objc var gridPower: Int = 3 {
        didSet {
            gridValueLab.attributedText = getFormatAttr(value: gridPower)
        }
    }
    
    @objc var batteryPower: Int = 0 {
        didSet {
            batteryValeuLab.attributedText = getFormatAttr(value: batteryPower)
        }
    }
    
    @objc var vehiclePower: Int = 0 {
        didSet {
            vehicleChargingValueLab.attributedText = getFormatAttr(value: vehiclePower)
        }
    }
    
    @objc var usageExtraPower: Int = 0 {
        didSet {
            usageExtraSupplyValueLab.attributedText = getFormatAttr(value: usageExtraPower)
        }
    }
    
    var solarIncreaseTimer: Timer?
    
    var gridIncreaseTimer: Timer?
    
    var vehicleReduceTimer: Timer?
    
    var usageExtraReduceTimer: Timer?
    
    var transportTimer: Timer?
    
    lazy var operaQueue: OperationQueue = {
        let operaQueue = OperationQueue()
        operaQueue.maxConcurrentOperationCount = 1
        return operaQueue
    }()
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.text = "Realtime Power"
        titleLab.textColor = .init(hex: 0xFFFFFF)
        titleLab.font = .systemFont(ofSize: 16, weight: .regular)
        return titleLab
    }()
    
    lazy var pathImgV: UIImageView = {
        let pathImgV = UIImageView()
        pathImgV.image = .init(named: "topo_map")
        pathImgV.tintColor = .init(hex: 0xFFFFFF, a: 0.1)
        return pathImgV
    }()
    
    lazy var lightningModeImgV: UIImageView = {
        let lightningModeImgV = UIImageView()
        lightningModeImgV.image = .init(named: "icon_power_lightning_mode")
        return lightningModeImgV
    }()
    
    lazy var solarPowerImgV: UIImageView = {
        let solarFullPowerImgV = UIImageView()
        solarFullPowerImgV.image = .init(named: "icon_power_solar_full")
        return solarFullPowerImgV
    }()
    
    lazy var solarNameLab: UILabel = {
        let solarNameLab = UILabel()
        solarNameLab.font = .systemFont(ofSize: 13, weight: .regular)
        solarNameLab.textColor = .init(hex: 0xFFFFFF, a: 0.3)
        solarNameLab.text = "Solar"
        return solarNameLab
    }()
    
    lazy var solarValueLab: UILabel = {
        let solarValueLab = UILabel()
        solarValueLab.attributedText = getFormatAttr(value: solarPower)
        return solarValueLab
    }()
    
    lazy var gridPowerImgV: UIImageView = {
        let gridPowerImgV = UIImageView()
        gridPowerImgV.image = .init(named: "icon_power_grid")
        return gridPowerImgV
    }()
    
    lazy var gridNameLab: UILabel = {
        let gridNameLab = UILabel()
        gridNameLab.font = .systemFont(ofSize: 13, weight: .regular)
        gridNameLab.textColor = .init(hex: 0xFFFFFF, a: 0.3)
        gridNameLab.text = "Grid"
        return gridNameLab
    }()
    
    lazy var gridValueLab: UILabel = {
        let gridValueLab = UILabel()
        gridValueLab.attributedText = getFormatAttr(value: gridPower)
        return gridValueLab
    }()
    
    lazy var batteryImgV: UIImageView = {
        let batteryImgV = UIImageView()
        batteryImgV.image = .init(named: "icon_power_battery_background")
        return batteryImgV
    }()
    
    lazy var batteryNameLab: UILabel = {
        let batteryNameLab = UILabel()
        batteryNameLab.font = .systemFont(ofSize: 13, weight: .regular)
        batteryNameLab.textColor = .init(hex: 0xFFFFFF, a: 0.3)
        batteryNameLab.text = "Battery"
        return batteryNameLab
    }()
    
    lazy var batteryValeuLab: UILabel = {
        let batteryValueLab = UILabel()
        batteryValueLab.attributedText = getFormatAttr(value: batteryPower)
        return batteryValueLab
    }()
    
    lazy var vehicleChargingImgV: UIImageView = {
        let vehicleChargingImgV = UIImageView()
        vehicleChargingImgV.image = .init(named: "icon_power_vehicle_charging")
        return vehicleChargingImgV
    }()
    
    lazy var vehicleChargingNameLab: UILabel = {
        let vehicleChargingNameLab = UILabel()
        vehicleChargingNameLab.font = .systemFont(ofSize: 13, weight: .regular)
        vehicleChargingNameLab.textColor = .init(hex: 0xFFFFFF, a: 0.3)
        vehicleChargingNameLab.text = "Vehicle"
        return vehicleChargingNameLab
    }()
    
    lazy var vehicleChargingValueLab: UILabel = {
        let vehicleChargingValueLab = UILabel()
        vehicleChargingValueLab.attributedText = getFormatAttr(value: vehiclePower)
        return vehicleChargingValueLab
    }()
    
    lazy var usageSecureSupplyImgV: UIImageView = {
        let usageSecureSupplyImgV = UIImageView()
        usageSecureSupplyImgV.image = .init(named: "icon_power_usage_secure_supply")
        return usageSecureSupplyImgV
    }()
    
    lazy var usageSecureSupplyNameLab: UILabel = {
        let usageSecureSupplyNameLab = UILabel()
        usageSecureSupplyNameLab.font = .systemFont(ofSize: 13, weight: .regular)
        usageSecureSupplyNameLab.textColor = .init(hex: 0xFFFFFF, a: 0.3)
        usageSecureSupplyNameLab.text = "Additional Load"
        return usageSecureSupplyNameLab
    }()
    
    lazy var usageExtraSupplyImgV: UIImageView = {
        let usageExtraSupplyImgV = UIImageView()
        usageExtraSupplyImgV.image = .init(named: "icon_power_usage_extra_supply")
        return usageExtraSupplyImgV
    }()
    
    lazy var usageExtraSupplyNameLab: UILabel = {
        let usageExtraSupplyNameLab = UILabel()
        usageExtraSupplyNameLab.font = .systemFont(ofSize: 13, weight: .regular)
        usageExtraSupplyNameLab.textColor = .init(hex: 0xFFFFFF, a: 0.3)
        usageExtraSupplyNameLab.text = "Additional Load"
        return usageExtraSupplyNameLab
    }()
    
    lazy var usageExtraSupplyValueLab: UILabel = {
        let usageExtraSupplyValueLab = UILabel()
        usageExtraSupplyValueLab.attributedText = getFormatAttr(value: usageExtraPower)
        return usageExtraSupplyValueLab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(hex: 0x2B445E)
        setupSubviews()
        makeConstraints()
        startCounter()
    }
    
    func setupSubviews() {
        view.addSubview(titleLab)
        view.addSubview(pathImgV)
        view.addSubview(lightningModeImgV)
        view.addSubview(solarPowerImgV)
        view.addSubview(solarNameLab)
        view.addSubview(solarValueLab)
        view.addSubview(gridPowerImgV)
        view.addSubview(gridNameLab)
        view.addSubview(gridValueLab)
        view.addSubview(batteryImgV)
        view.addSubview(batteryNameLab)
        view.addSubview(batteryValeuLab)
        view.addSubview(vehicleChargingImgV)
        view.addSubview(vehicleChargingNameLab)
        view.addSubview(vehicleChargingValueLab)
        view.addSubview(usageSecureSupplyImgV)
        view.addSubview(usageSecureSupplyNameLab)
        view.addSubview(usageExtraSupplyImgV)
        view.addSubview(usageExtraSupplyNameLab)
        view.addSubview(usageExtraSupplyValueLab)
    }
    
    func makeConstraints() {
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(24)
        }
        pathImgV.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 197.02, height: 132.89))
        }
        lightningModeImgV.snp.makeConstraints { make in
            make.left.equalTo(pathImgV).offset(77.05)
            make.top.equalTo(pathImgV).offset(48.44)
            make.size.equalTo(24)
        }
        solarPowerImgV.snp.makeConstraints { make in
            make.bottom.equalTo(pathImgV.snp.top)
            make.left.equalTo(pathImgV.snp.left).offset(55)
            make.size.equalTo(60)
        }
        solarNameLab.snp.makeConstraints { make in
            make.centerX.equalTo(solarPowerImgV)
            make.bottom.equalTo(solarPowerImgV.snp.top)
            make.height.equalTo(20)
        }
        solarValueLab.snp.makeConstraints { make in
            make.centerX.equalTo(solarNameLab)
            make.bottom.equalTo(solarNameLab.snp.top)
            make.height.equalTo(48)
        }
        gridPowerImgV.snp.makeConstraints { make in
            make.bottom.equalTo(pathImgV.snp.top)
            make.right.equalTo(pathImgV).offset(30)
            make.size.equalTo(60)
        }
        gridNameLab.snp.makeConstraints { make in
            make.centerX.equalTo(gridPowerImgV)
            make.bottom.equalTo(gridPowerImgV.snp.top)
            make.height.equalTo(20)
        }
        gridValueLab.snp.makeConstraints { make in
            make.centerX.equalTo(gridNameLab)
            make.bottom.equalTo(gridNameLab.snp.top)
            make.height.equalTo(48)
        }
        batteryImgV.snp.makeConstraints { make in
            make.top.equalTo(pathImgV).offset(45.44)
            make.right.equalTo(pathImgV.snp.left).offset(-3.99)
        }
        batteryNameLab.snp.makeConstraints { make in
            make.centerX.equalTo(batteryImgV)
            make.bottom.equalTo(batteryImgV.snp.top)
            make.height.equalTo(20)
        }
        batteryValeuLab.snp.makeConstraints { make in
            make.centerX.equalTo(batteryNameLab)
            make.bottom.equalTo(batteryNameLab.snp.top)
            make.height.equalTo(48)
        }
        vehicleChargingImgV.snp.makeConstraints { make in
            make.left.equalTo(pathImgV).offset(-55.99)
            make.bottom.equalTo(pathImgV).offset(46.56)
            make.size.equalTo(60)
        }
        vehicleChargingNameLab.snp.makeConstraints { make in
            make.centerX.equalTo(vehicleChargingImgV)
            make.top.equalTo(vehicleChargingImgV.snp.bottom)
            make.height.equalTo(20)
        }
        vehicleChargingValueLab.snp.makeConstraints { make in
            make.centerX.equalTo(vehicleChargingNameLab)
            make.top.equalTo(vehicleChargingNameLab.snp.bottom)
            make.height.equalTo(58)
        }
        usageSecureSupplyImgV.snp.makeConstraints { make in
            make.centerX.equalTo(solarPowerImgV)
            make.bottom.equalTo(pathImgV).offset(46.56)
            make.size.equalTo(60)
        }
        usageSecureSupplyNameLab.snp.makeConstraints { make in
            make.centerX.equalTo(usageSecureSupplyImgV)
            make.top.equalTo(usageSecureSupplyImgV.snp.bottom)
            make.height.equalTo(20)
        }
        usageExtraSupplyImgV.snp.makeConstraints { make in
            make.centerX.equalTo(gridPowerImgV)
            make.bottom.equalTo(pathImgV).offset(46.56)
            make.size.equalTo(60)
        }
        usageExtraSupplyNameLab.snp.makeConstraints { make in
            make.centerX.equalTo(usageExtraSupplyImgV)
            make.top.equalTo(usageExtraSupplyImgV.snp.bottom)
            make.height.equalTo(20)
        }
        usageExtraSupplyValueLab.snp.makeConstraints { make in
            make.centerX.equalTo(usageExtraSupplyNameLab)
            make.top.equalTo(usageExtraSupplyNameLab.snp.bottom)
            make.height.equalTo(60)
        }
    }
}

extension RealtimeSceneViewController {
 
    func startCounter() {
        let solarIncreaseTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] timer in
            self?.solarPower += 1
        }
        RunLoop.current.add(solarIncreaseTimer, forMode: .common)
        self.solarIncreaseTimer = solarIncreaseTimer
        
        let gridIncreaseTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { [weak self] timer in
            self?.gridPower += 1
        }
        RunLoop.current.add(gridIncreaseTimer, forMode: .common)
        self.gridIncreaseTimer = gridIncreaseTimer
        
        let vehicleReduceTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] timer in
            guard let self = self, vehiclePower > 0 else { return }
            vehiclePower -= 1
        }
        RunLoop.current.add(vehicleReduceTimer, forMode: .common)
        self.vehicleReduceTimer = vehicleReduceTimer
        
        let usageExtraReduceTimer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { [weak self] timer in
            guard let self = self, usageExtraPower > 0 else { return }
            usageExtraPower -= 1
        }
        RunLoop.current.add(usageExtraReduceTimer, forMode: .common)
        self.usageExtraReduceTimer = usageExtraReduceTimer
        
        let transportTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] timer in
            let source = [#keyPath(solarPower), #keyPath(gridPower)]
            let useSourceIndex = Int.random(in: 0..<source.count)
            let to = [#keyPath(batteryPower), #keyPath(vehiclePower), #keyPath(usageExtraPower)]
            let useToIndex = Int.random(in: 0..<to.count)
            self?.powerTransport(fromName: source[useSourceIndex], toName: to[useToIndex])
        }
        RunLoop.current.add(transportTimer, forMode: .common)
        self.transportTimer = transportTimer
    }
    
    func powerTransport(fromName: String, toName: String) {
        powerFrom(fromName: fromName)
        powerTo(toName: toName)
    }
    
    func powerFrom(fromName: String) {
        if fromName == #keyPath(solarPower) {
            guard solarPower > 0 else { return }
            solarPower -= 1
        } else if fromName == #keyPath(gridPower) {
            guard gridPower > 0 else { return }
            gridPower -= 1
        }
    }
    
    func powerTo(toName: String) {
        if toName == #keyPath(batteryPower) {
            batteryPower += 1
        } else if toName == #keyPath(vehiclePower) {
            vehiclePower += 1
        } else if toName == #keyPath(usageExtraPower) {
            usageExtraPower += 1
        }
    }
}

extension RealtimeSceneViewController {
    
    func getFormatAttr(value: Int) -> NSAttributedString {
        let attr = NSMutableAttributedString()
        attr.append(.init(string: "\(value)", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .bold), .foregroundColor : UIColor(hex: 0xFFFFFF)]))
        attr.append(.init(string: "kW", attributes: [.font : UIFont.systemFont(ofSize: 14, weight: .regular), .foregroundColor : UIColor(hex: 0xFFFFFF)]))
        return attr
    }
}
