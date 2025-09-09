//
//  LineViewMarker.swift
//  FirstProject
//
//  Created by Zack-Zeng on 2025/9/9.
//

import UIKit
import DGCharts
import SnapKit

protocol LineViewMarkerDelegate: NSObjectProtocol {
    
    func contentValue(entry: ChartDataEntry) -> NSAttributedString
}

class LineViewMarker: MarkerView {

    weak var delegate: LineViewMarkerDelegate?
    
    lazy var powerDetailContentView: UIView = {
        let powerDetailContentView = UIView()
        powerDetailContentView.backgroundColor = .init(hex: 0x2B445E)
        powerDetailContentView.layer.cornerRadius = 3
        return powerDetailContentView
    }()
    
    lazy var powerDetailLab: UILabel = {
        let powerDetailLab = UILabel()
        return powerDetailLab
    }()
    
    lazy var powerDetailPointView: UIImageView = {
        let powerDetailPointView = UIImageView()
        powerDetailPointView.image = .init(named: "point_localtion")
        return powerDetailPointView
    }()
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
//        makeConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
//        makeConstraints()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(powerDetailContentView)
        powerDetailContentView.addSubview(powerDetailLab)
        addSubview(powerDetailPointView)
    }
    
//    func makeConstraints() {
//        powerDetailContentView.snp.makeConstraints { make in
//            make.edges.equalTo(powerDetailLab)
//        }
//        powerDetailLab.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.centerX.equalTo(powerDetailPointView)
//        }
//        powerDetailPointView.snp.makeConstraints { make in
//            make.bottom.equalToSuperview()
//            make.top.equalTo(powerDetailContentView.snp.bottom)
//            make.width.equalTo(10)
//        }
//    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let attr = delegate?.contentValue(entry: entry)
        powerDetailLab.attributedText = attr
        
        super.refreshContent(entry: entry, highlight: highlight)
    }
    
    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        var offset = super.offsetForDrawing(atPoint: point)
        
        powerDetailPointView.frame = .init(x: point.x, y: self.chartView?.chartYMin ?? 0, width: 10, height: 50)
        return offset
    }
}
