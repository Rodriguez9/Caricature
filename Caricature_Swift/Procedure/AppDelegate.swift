//
//  AppDelegate.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/8/8.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var reachability : NetworkReachabilityManager? = {
        return NetworkReachabilityManager(host: "http://app.u17.com")
    }()
    
    var orientation : UIInterfaceOrientationMask = .portrait
    

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configBase()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = UTabBarController()
        window?.makeKeyAndVisible()
        //MARK: 修正齐刘海
        UHairPowder.instance.spread()
        return true
    }
    
    func configBase(){
        
        //MARK : 键盘处理
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        //MARK : 性别缓存
        let defaults = UserDefaults.standard
        if defaults.value(forKey: String.sexTypeKey) == nil {
            defaults.set(1, forKey: String.sexTypeKey)
            defaults.synchronize()
        }
        
        //MARK: 网络监控
        reachability?.listener = { status in
            switch status {
            case .reachable(.wwan):
                UNoticeBar(config: UNoticeBarConfig(title: "主人,检测到您正在使用移动数据")).show(duration: 2)
            default: break
            }
        }
        reachability?.startListening()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientation
    }
    
}


extension UIApplication {
    //MARK : 强制旋转屏幕
    class func changeOrientationTo(landscapeRight: Bool){
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {return}
        if landscapeRight == true {
            delegate.orientation = .landscapeRight
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }else{
            delegate.orientation = .portrait
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
    }
}
