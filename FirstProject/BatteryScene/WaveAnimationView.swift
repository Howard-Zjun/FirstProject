//
//  WaveAnimationView.swift
//  FirstProject
//
//  Created by Zack-Zeng on 2025/9/12.
//

import UIKit

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
