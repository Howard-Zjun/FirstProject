//
//  NSObject+Extension.swift
//  BaseExtension
//
//  Created by Howard-Zjun on 2024/08/21.
//

import UIKit
import Photos
import EventKit
import Contacts

public extension NSObject {
    
    /// 创建一个颜色图片
    func mCreateImage(color: UIColor, size: CGSize) -> UIImage {
        color.mRreateImage(size: size)
    }
    
    /// 绘制渐变图片
    func mCreateImage(colors: [UIColor], size: CGSize) -> UIImage {
        let cgColors = colors.map({ $0.cgColor })
        var locations: [CGFloat] = []
        for (index, _) in colors.enumerated() {
            locations.append(CGFloat(index) / CGFloat(colors.count - 1))
        }
        let gradient = CGGradient(colorsSpace: nil, colors: cgColors as CFArray, locations: locations)!
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let ret = renderer.image { context in
            let startPoint = CGPoint(x: 0, y: 0)
            let endPoint = CGPoint(x: size.width, y: size.height)
            context.cgContext.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        }
        return ret
    }
}

public extension CALayer {
    
    func mCreateImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let ret = renderer.image { [weak self] context in
            self?.render(in: context.cgContext)
        }
        return ret
    }
}

// MARK: - PermissionManager
public extension NSObject {
    
    func mToSetting(title: String, message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let toSettingAction = UIAlertAction(title: "去设置", style: .default) { action in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
        vc.addAction(cancelAction)
        vc.addAction(toSettingAction)
        if let mKeyWindow {
            mKeyWindow.rootViewController?.present(vc, animated: true)
        }
    }
    
    // MARK: - 相册权限
    /// 申请相册权限
    func mRequestPhotoPermission(_ block: @escaping ((PHAuthorizationStatus) -> Void)) {
        let status: PHAuthorizationStatus
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        
        if status == .notDetermined { // 未确定
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in
                    DispatchQueue.main.async {
                        self.mRequestPhotoPermission(block)
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization { _ in
                    DispatchQueue.main.async {
                        self.mRequestPhotoPermission(block)
                    }
                }
            }
        } else if status == .restricted { // 没有访问权限
            block(.restricted)
        } else if status == .authorized { // 已授权
            block(.authorized)
        } else if status == .denied { // 已禁止
            block(.denied)
        } else {
            if #available(iOS 14, *) {
                if status == .limited { // 有限授权
                    block(.limited)
                }
            }
        }
    }
    
    /// 申请相册权限带成功回调
    func mRequestPhotoPermissionWith(successBlock: @escaping (() -> Void)) {
        let status: PHAuthorizationStatus
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        
        let firstRequest = status == .notDetermined
        mRequestPhotoPermission { [weak self] status in
            if status == .authorized {
                successBlock()
            } else if !firstRequest {
                self?.mToSetting(title: "提示", message: "相册未授权，需要去设置进行修改")
            }
        }
    }
    
    // MARK: - 相机权限
    /// 申请相机权限
    func mRequestCameraPremission(_ block: @escaping ((AVAuthorizationStatus) -> Void)) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { _ in
                DispatchQueue.main.async {
                    self.mRequestCameraPremission(block)
                }
            }
        } else if status == .authorized {
            block(.authorized)
        } else if status == .denied {
            block(.denied)
        } else if status == .restricted {
            block(.restricted)
        }
    }
    
    /// 申请相机权限带成功回调
    func mRequestCameraPermissionWith(successBlock: @escaping (() -> Void)) {
        let firstRequest = AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined
        
        mRequestCameraPremission { [weak self] status in
            if status == .authorized {
                successBlock()
            } else if !firstRequest {
                self?.mToSetting(title: "提示", message: "相机未授权，需要去设置进行修改")
            }
        }
    }
    
    // MARK: - 日历权限
    /// 申请日历权限
    func mRequestCalendarPermission(_ block: @escaping ((EKAuthorizationStatus) -> Void)) {
        let status = EKEventStore.authorizationStatus(for: .event)
        
        if status == .notDetermined {
            if #available(iOS 17, *) {
                EKEventStore().requestFullAccessToEvents { _, error in
                    if let error {
                        print("Error \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            self.mRequestCalendarPermission(block)
                        }
                    }
                }
            } else {
                EKEventStore().requestAccess(to: .event) { result, error in
                    if let error {
                        print("Error \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            self.mRequestCalendarPermission(block)
                        }
                    }
                }
            }
        } else if status == .authorized {
            block(.authorized)
        } else if status == .denied {
            block(.denied)
        } else if status == .restricted {
            block(.restricted)
        } else {
            if #available(iOS 17, *) {
                if status == .fullAccess {
                    block(.fullAccess)
                } else if status == .writeOnly {
                    block(.writeOnly)
                }
            }
        }
    }
    
    /// 申请日历权限带成功回调
    func mRequestCalendarPermisstionWith(successBlock: @escaping (() -> Void)) {
        let firstRequest = EKEventStore.authorizationStatus(for: .event) == .notDetermined
        
        mRequestCalendarPermission { [weak self] status in
            if #available(iOS 17, *) {
                if status == .writeOnly || status == .fullAccess {
                    successBlock()
                } else if !firstRequest {
                    self?.mToSetting(title: "提示", message: "日历未授权，需要去设置进行修改")
                }
            } else {
                if status == .authorized {
                    successBlock()
                } else if !firstRequest {
                    self?.mToSetting(title: "提示", message: "日历未授权，需要去设置进行修改")
                }
            }
        }
    }
    
    
    // MARK: - 麦克风权限
    /// 申请麦克风权限
    func mRequestMicrophonePermission(_ block: @escaping ((AVAuthorizationStatus) -> Void)) {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        
        if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .audio) { _ in
                DispatchQueue.main.async {
                    self.mRequestMicrophonePermission(block)
                }
            }
        } else if status == .authorized {
            block(.authorized)
        } else if status == .denied {
            block(.denied)
        } else if status == .restricted {
            block(.restricted)
        }
    }
    
    /// 申请麦克风权限带成功回调
    func mRequestMicrophonePermisstionWith(successBlock: @escaping (() -> Void)) {
        let firstRequest = AVCaptureDevice.authorizationStatus(for: .audio) == .notDetermined
        
        mRequestMicrophonePermission { [weak self] status in
            if status == .authorized {
                successBlock()
            } else if !firstRequest {
                self?.mToSetting(title: "提示", message: "麦克风未授权，需要去设置进行修改")
            }
        }
    }
    
    /// 申请定位权限，这个比较特俗，通过委托回调，这里不写通用的
//    func requestLocationPremission(_ block: @escaping (() -> Void)) {
//        let manager = CLLocationManager()
//        manager.delegate = self
//        let status: CLAuthorizationStatus
//        if #available(iOS 14, *) {
//            status = manager.authorizationStatus
//        } else {
//            status = CLLocationManager.authorizationStatus()
//        }
//
//        if status == .notDetermined {
//            manager.requestWhenInUseAuthorization()
//        } else if status == .authorizedAlways {
//
//        } else if status == .authorizedWhenInUse {
//
//        } else if status == .denied {
//
//        } else if status == .restricted {
//
//        }
//    }
    
    // MARK: - 申请人权限
    /// 申请联系人权限
    func mRequestContactPremission(_ block: @escaping ((CNAuthorizationStatus) -> Void)) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        if status == .notDetermined {
            CNContactStore().requestAccess(for: .contacts) { _, error in
                if let error {
                    print("Error \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.mRequestContactPremission(block)
                    }
                }
            }
        } else if status == .authorized {
            block(.authorized)
        } else if status == .denied {
            block(.denied)
        } else if status == .restricted {
            block(.restricted)
        }
    }
    
    /// 申请联系人权限带成功回调
    func mRequestContactPermisstionWith(successBlock: @escaping (() -> Void)) {
        let firstRequest = CNContactStore.authorizationStatus(for: .contacts) == .notDetermined
        
        mRequestContactPremission { [weak self] status in
            if status == .authorized {
                successBlock()
            } else if !firstRequest {
                self?.mToSetting(title: "提示", message: "联系人未授权，需要去设置进行修改")
            }
        }
    }
}

