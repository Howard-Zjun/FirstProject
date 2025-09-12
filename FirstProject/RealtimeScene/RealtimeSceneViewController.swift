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

    @objc lazy var solarViewModel: PowerRquipmentViewModel = {
        let ret = PowerRquipmentViewModel(name: "solar", power: 6)
        ret.connect(label: solarValueLab)
        return ret
    }()
    
    @objc lazy var gridViewModel: PowerRquipmentViewModel = {
        let ret = PowerRquipmentViewModel(name: "grid", power: 3)
        ret.connect(label: gridValueLab)
        return ret
    }()
    
    @objc lazy var batteryViewModel: PowerRquipmentViewModel = {
        let ret = PowerRquipmentViewModel(name: "battery", power: 0)
        ret.connect(label: batteryValeuLab)
        return ret
    }()
    
    @objc lazy var vehicleViewModel: PowerRquipmentViewModel = {
        let ret = PowerRquipmentViewModel(name: "vehicle", power: 0)
        ret.connect(label: vehicleChargingValueLab)
        return ret
    }()
    
    @objc lazy var keepOnLoadViewModel: PowerRquipmentViewModel = {
        let ret = PowerRquipmentViewModel(name: "keepOn Load", power: 0)
        ret.connect(label: keepOnLoadValueLab)
        return ret
    }()
    
    @objc lazy var additionalLoadViewModel: PowerRquipmentViewModel = {
        let ret = PowerRquipmentViewModel(name: "additionalLoad", power: 0)
        ret.connect(label: additionalLoadValueLab)
        return ret
    }()
    
    var solarIncreaseTimer: Timer?
    
    var gridIncreaseTimer: Timer?
    
    var vehicleReduceTimer: Timer?
    
    var usageExtraReduceTimer: Timer?
    
    var transportTimer: Timer?
    
    let pathSetManager: PathSetManager = .init()
    
    var batteryContentHeight = 45.23
    
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
        return gridValueLab
    }()
    
    lazy var batteryImgV: UIImageView = {
        let batteryImgV = UIImageView()
        batteryImgV.image = .init(named: "icon_power_battery_background")
        return batteryImgV
    }()
    
    lazy var batteryAnimationShowArea: UIView = {
        let batteryAnimationShowArea = UIView()
        batteryAnimationShowArea.layer.cornerRadius = 3
        batteryAnimationShowArea.layer.masksToBounds = true
        return batteryAnimationShowArea
    }()
    
    lazy var waveAnimationView: WaveAnimationView = {
        let waveAnimationView = WaveAnimationView()
        return waveAnimationView
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
        return vehicleChargingValueLab
    }()
    
    lazy var keepOnLoadImgV: UIImageView = {
        let keepOnLoadImgV = UIImageView()
        keepOnLoadImgV.image = .init(named: "icon_power_usage_secure_supply")
        return keepOnLoadImgV
    }()
    
    lazy var keepOnLoadNameLab: UILabel = {
        let keepOnLoadNameLab = UILabel()
        keepOnLoadNameLab.font = .systemFont(ofSize: 13, weight: .regular)
        keepOnLoadNameLab.textColor = .init(hex: 0xFFFFFF, a: 0.3)
        keepOnLoadNameLab.text = "KeepOn Load"
        return keepOnLoadNameLab
    }()
    
    lazy var keepOnLoadValueLab: UILabel = {
        let keepOnLoadValueLab = UILabel()
        return keepOnLoadValueLab
    }()
    
    lazy var additionalLoadImgV: UIImageView = {
        let additionalLoadImgV = UIImageView()
        additionalLoadImgV.image = .init(named: "icon_power_usage_extra_supply")
        return additionalLoadImgV
    }()
    
    lazy var additionalLoadNameLab: UILabel = {
        let additionalLoadNameLab = UILabel()
        additionalLoadNameLab.font = .systemFont(ofSize: 13, weight: .regular)
        additionalLoadNameLab.textColor = .init(hex: 0xFFFFFF, a: 0.3)
        additionalLoadNameLab.text = "Additional Load"
        return additionalLoadNameLab
    }()
    
    lazy var additionalLoadValueLab: UILabel = {
        let additionalLoadValueLab = UILabel()
        return additionalLoadValueLab
    }()
    
    var batteryObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(hex: 0x2B445E)
        setupSubviews()
        makeConstraints()
        startCounter()
        configPath()
        
        batteryObservation = batteryViewModel.observe(\.power) { [weak self] viewModel, change in
            self?.updateBatteryAnimation()
        }
    }
    
    deinit {
        batteryObservation?.invalidate()
        batteryObservation = nil
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
        batteryImgV.addSubview(batteryAnimationShowArea)
        batteryAnimationShowArea.addSubview(waveAnimationView)
        view.addSubview(batteryNameLab)
        view.addSubview(batteryValeuLab)
        view.addSubview(vehicleChargingImgV)
        view.addSubview(vehicleChargingNameLab)
        view.addSubview(vehicleChargingValueLab)
        view.addSubview(keepOnLoadImgV)
        view.addSubview(keepOnLoadNameLab)
        view.addSubview(keepOnLoadValueLab)
        view.addSubview(additionalLoadImgV)
        view.addSubview(additionalLoadNameLab)
        view.addSubview(additionalLoadValueLab)
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
            make.size.equalTo(CGSize(width: 230, height: 147))
        }
        lightningModeImgV.snp.makeConstraints { make in
            make.left.equalTo(pathImgV).offset(92)
            make.top.equalTo(pathImgV).offset(54)
            make.size.equalTo(24)
        }
        solarPowerImgV.snp.makeConstraints { make in
            make.bottom.equalTo(pathImgV.snp.top)
            make.left.equalTo(pathImgV.snp.left).offset(70)
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
        batteryAnimationShowArea.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(3)
            make.bottom.equalToSuperview().inset(2.89)
            make.height.equalTo(batteryContentHeight)
        }
        waveAnimationView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(batteryContentHeight * CGFloat(batteryViewModel.power) / 100.0)
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
        keepOnLoadImgV.snp.makeConstraints { make in
            make.centerX.equalTo(solarPowerImgV)
            make.bottom.equalTo(pathImgV).offset(46.56)
            make.size.equalTo(60)
        }
        keepOnLoadNameLab.snp.makeConstraints { make in
            make.centerX.equalTo(keepOnLoadImgV)
            make.top.equalTo(keepOnLoadImgV.snp.bottom)
            make.height.equalTo(20)
        }
        keepOnLoadValueLab.snp.makeConstraints { make in
            make.centerX.equalTo(keepOnLoadNameLab)
            make.top.equalTo(keepOnLoadNameLab.snp.bottom)
            make.height.equalTo(58)
        }
        additionalLoadImgV.snp.makeConstraints { make in
            make.centerX.equalTo(gridPowerImgV)
            make.bottom.equalTo(pathImgV).offset(46.56)
            make.size.equalTo(60)
        }
        additionalLoadNameLab.snp.makeConstraints { make in
            make.centerX.equalTo(additionalLoadImgV)
            make.top.equalTo(additionalLoadImgV.snp.bottom)
            make.height.equalTo(20)
        }
        additionalLoadValueLab.snp.makeConstraints { make in
            make.centerX.equalTo(additionalLoadNameLab)
            make.top.equalTo(additionalLoadNameLab.snp.bottom)
            make.height.equalTo(60)
        }
    }
    
    func updateBatteryAnimation() {
        waveAnimationView.snp.updateConstraints { make in
            make.height.equalTo(batteryContentHeight * CGFloat(batteryViewModel.power) / 100.0)
        }
    }
}

extension RealtimeSceneViewController {
    
    func configPath() {
        pathSetManager.setSinglePathFrom(fromName: solarViewModel.name, toName: "A", toSVG: "solar——circle".toSVGURL())
        pathSetManager.setSinglePathFrom(fromName: gridViewModel.name, toName: "B", toSVG: "grid——circle".toSVGURL())
        pathSetManager.setSinglePathFrom(fromName: gridViewModel.name, toName: additionalLoadViewModel.name, toSVG: "grid——Additional Load".toSVGURL())
        pathSetManager.setSinglePathFrom(fromName: "B", toName: "A", path: createCirclePath(startAngle: 1.75 * CGFloat.pi, endAngle: 1.25 * CGFloat.pi))
        pathSetManager.setSinglePathFrom(fromName: "A", toName: "C", path: createCirclePath(startAngle: 1.25 * CGFloat.pi, endAngle: 0.80 * CGFloat.pi))
        pathSetManager.setSinglePathFrom(fromName: "C", toName: "D", path: createCirclePath(startAngle: 0.82 * CGFloat.pi, endAngle: 0.68 * CGFloat.pi))
        pathSetManager.setSinglePathFrom(fromName: "D", toName: "E", path: createCirclePath(startAngle: 0.70 * CGFloat.pi, endAngle: 0.25 * CGFloat.pi))
        pathSetManager.setSinglePathFrom(fromName: "A", toName: batteryViewModel.name, toSVG: "circle——battery".toSVGURL())
        pathSetManager.setSinglePathFrom(fromName: "C", toName: vehicleViewModel.name, toSVG: "circle——vehicle".toSVGURL())
        pathSetManager.setSinglePathFrom(fromName: "D", toName: keepOnLoadViewModel.name, toSVG: "circle——KeepON Load".toSVGURL())
        pathSetManager.setSinglePathFrom(fromName: "E", toName: additionalLoadViewModel.name, toSVG: "circle——Additional Load".toSVGURL())
    }
    
    /// 生成部分圆路径
    /// - Parameters:
    ///   - startAngle: 角度
    ///   - endAngle: 角度
    /// - Returns: 路径
    func createCirclePath(startAngle: CGFloat, endAngle: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.addArc(withCenter: .init(x: 104, y: 66), radius: 20, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return path
    }
}

extension String {
    
    func toSVGURL() -> URL {
        if let url = Bundle.main.url(forResource: self, withExtension: "svg") {
            return url
        } else {
            fatalError()
        }
    }
}

extension RealtimeSceneViewController {
 
    func startCounter() {
        let solarIncreaseTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] timer in
            self?.solarViewModel.power += 1
        }
        RunLoop.current.add(solarIncreaseTimer, forMode: .common)
        self.solarIncreaseTimer = solarIncreaseTimer
        
        let gridIncreaseTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { [weak self] timer in
            self?.gridViewModel.power += 1
        }
        RunLoop.current.add(gridIncreaseTimer, forMode: .common)
        self.gridIncreaseTimer = gridIncreaseTimer
        
        let vehicleReduceTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] timer in
            guard let self = self, vehicleViewModel.power > 0 else { return }
            vehicleViewModel.power -= 1
        }
        RunLoop.current.add(vehicleReduceTimer, forMode: .common)
        self.vehicleReduceTimer = vehicleReduceTimer
        
        let usageExtraReduceTimer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { [weak self] timer in
            guard let self = self, additionalLoadViewModel.power > 0 else { return }
            additionalLoadViewModel.power -= 1
        }
        RunLoop.current.add(usageExtraReduceTimer, forMode: .common)
        self.usageExtraReduceTimer = usageExtraReduceTimer
        
        let transportTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            let source = [solarViewModel.name, gridViewModel.name]
            let useSourceIndex = Int.random(in: 0..<source.count)
            let to = [batteryViewModel.name, vehicleViewModel.name, keepOnLoadViewModel.name, additionalLoadViewModel.name]
            let useToIndex = Int.random(in: 0..<to.count)
            powerTransport(fromName: source[useSourceIndex], toName: to[useToIndex])
        }
        RunLoop.current.add(transportTimer, forMode: .common)
        self.transportTimer = transportTimer
    }
    
    func powerTransport(fromName: String, toName: String) {
        guard let fromViewModel = powerFrom(fromName: fromName) else {
            print("[\(String(describing: Self.self))-\(#function)-\(Thread.current):\(#line)] 没有录入出发点\(fromName)")
            return
        }
        guard let toViewModel = powerTo(toName: toName) else {
            print("[\(String(describing: Self.self))-\(#function)-\(Thread.current):\(#line)] 没有录入目的地\(toName)")
            return
        }
        guard fromViewModel.power > 0 else {
            print("[\(String(describing: Self.self))-\(#function)-\(Thread.current):\(#line)] 出发点\(fromName)电能不足")
            return
        }
        pathSetManager.getPath(fromName: fromName, toName: toName) { [weak self] path, error in
            guard let self = self, let path else {
                print("[\(String(describing: Self.self))-\(#function)-\(Thread.current):\(#line)] error: \(String(describing: error?.localizedDescription))")
                return
            }
            fromViewModel.power -= 1
            let payer = AnimationLayer()
            payer.path = path.cgPath
            payer.frame = pathImgV.bounds
            pathImgV.layer.addSublayer(payer)
            payer.startAnimation {
                payer.removeFromSuperlayer()
                toViewModel.power += 1
            }
        }
    }
    
    func powerFrom(fromName: String) -> PowerRquipmentViewModel? {
        if fromName == solarViewModel.name {
            return solarViewModel
        } else if fromName == gridViewModel.name {
            return gridViewModel
        }
        return nil
    }
    
    func powerTo(toName: String) -> PowerRquipmentViewModel? {
        if toName == batteryViewModel.name {
            return batteryViewModel
        } else if toName == vehicleViewModel.name {
            return vehicleViewModel
        } else if toName == keepOnLoadViewModel.name {
            return keepOnLoadViewModel
        } else if toName == additionalLoadViewModel.name {
            return additionalLoadViewModel
        }
        return nil
    }
}

extension RealtimeSceneViewController {
    
    @objcMembers class PowerRquipmentViewModel: NSObject {
        
        let name: String
        
        @objc dynamic var power: Int = 0 {
            didSet {
                lab?.attributedText = getNowPowerAttr()
            }
        }
        
        weak var lab: UILabel?
        
        init(name: String, power: Int) {
            self.name = name
            self.power = power
        }
        
        func connect(label: UILabel) {
            lab = label
            lab?.attributedText = getNowPowerAttr()
        }
        
        func getFormatAttr(value: Int) -> NSAttributedString {
            let attr = NSMutableAttributedString()
            attr.append(.init(string: "\(value)", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .bold), .foregroundColor : UIColor(hex: 0xFFFFFF)]))
            attr.append(.init(string: "kW", attributes: [.font : UIFont.systemFont(ofSize: 14, weight: .regular), .foregroundColor : UIColor(hex: 0xFFFFFF)]))
            return attr
        }
        
        func getNowPowerAttr() -> NSAttributedString {
            getFormatAttr(value: power)
        }
    }
}

extension RealtimeSceneViewController {
 
    class AnimationLayer: CAShapeLayer {
        
        var top: CGFloat {
            0.1
        }
        
        // 0.90 是动画头部到达尽头，1是尾部到达尽头
        var progress: CGFloat = 0 {
            didSet {
                strokeStart = progress
                if progress >= 1 - top {
                    strokeEnd = 1
                } else {
                    strokeEnd = progress + top
                }
            }
        }
        
        weak var link: CADisplayLink?
        
        var endOperation: (() -> Void)?
        
        var frameRate: Int = 60
        
        override init() {
            super.init()
            setup()
        }
        
        override init(layer: Any) {
            super.init(layer: layer)
            setup()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setup() {
            strokeColor = UIColor.white.cgColor
            fillColor = UIColor.clear.cgColor
        }
        
        func startAnimation(endOperation: @escaping (() -> Void)) {
            self.endOperation = endOperation
            strokeEnd = top
            strokeStart = 0
            let link = CADisplayLink(target: self, selector: #selector(updateProgress))
            link.preferredFrameRateRange = .init(minimum: 60, maximum: 60)
            link.add(to: .main, forMode: .common)
            self.link = link
        }
        
        func stopAnimation() {
            link?.invalidate()
            link?.remove(from: .main, forMode: .common)
            link = nil
        }
        
        @objc func updateProgress() {
            guard progress < 1 else {
                stopAnimation()
                endOperation?()
                endOperation = nil
                return
            }
            
            progress += 0.005
        }
    }
}
