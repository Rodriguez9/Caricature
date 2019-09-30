//
//  UHairPowder.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/9/25.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import Foundation
import UIKit

open class UHairPowder {
    public static let instance = UHairPowder()
    
    //繪製用貝塞爾弧線繪製一個view
    private class HairPowderView: UIView{
        static let cornerRadius: CGFloat = 40
        static let cornerY: CGFloat = 35
        override func draw(_ rect: CGRect) {
            let width = frame.width > frame.height ? frame.height : frame.width
            
            let rectPath = UIBezierPath()
            rectPath.move(to: CGPoint(x: 0, y: 0))
            rectPath.addLine(to: CGPoint(x: width, y: 0))
            rectPath.addLine(to: CGPoint(x: width, y: HairPowderView.cornerY))
            rectPath.addLine(to: CGPoint(x: 0, y: HairPowderView.cornerY))
            rectPath.close()
            rectPath.fill()
            
            let leftCornerPath = UIBezierPath()
            leftCornerPath.move(to: CGPoint(x: 0, y: HairPowderView.cornerY + HairPowderView.cornerRadius))
            leftCornerPath.addLine(to: CGPoint(x: 0, y: HairPowderView.cornerY))
            leftCornerPath.addLine(to: CGPoint(x: HairPowderView.cornerRadius, y: HairPowderView.cornerY))
            leftCornerPath.addQuadCurve(to:  CGPoint(x: 0, y: HairPowderView.cornerY+HairPowderView.cornerRadius), controlPoint: CGPoint(x: 0, y: HairPowderView.cornerY))
            leftCornerPath.close()
            leftCornerPath.fill()
            
            let rightCornerPath = UIBezierPath()
            rightCornerPath.move(to: CGPoint(x: width, y: HairPowderView.cornerY+HairPowderView.cornerRadius))
            rightCornerPath.addLine(to: CGPoint(x: width, y: HairPowderView.cornerY))
            rightCornerPath.addLine(to: CGPoint(x: width-HairPowderView.cornerRadius, y: HairPowderView.cornerY))
            rightCornerPath.addQuadCurve(to:  CGPoint(x: width, y: 35+HairPowderView.cornerRadius), controlPoint: CGPoint(x: width, y: HairPowderView.cornerY))
            rightCornerPath.close()
            rightCornerPath.fill()
        }
    }
    
    private var statusWindow: UIWindow = {
        //查找当前应用程序的主window
        let width = UIApplication.shared.keyWindow?.frame.width ?? 0
        let height = UIApplication.shared.keyWindow?.frame.height ?? 0
        let statusWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        //验证系统通过UIWindow的windowLevel大小不同优先显示不同的UIWindow
        //UIWindowLevel大的在上面显示，UIWindowLevel小的在下面显示
        //UIWindowLevel优先级相等的情况下，看谁后实例化了，谁后实例化谁先显示
        statusWindow.windowLevel = UIWindow.Level.statusBar - 1
        
        let hairPowerView = HairPowderView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        hairPowerView.backgroundColor = UIColor.green
        //clipsToBounds:该值确定子视图是否限于视图的边界
        hairPowerView.clipsToBounds = true
        statusWindow.addSubview(hairPowerView)
        return statusWindow
    }()
    
    public func spread(){
        guard isIphoneX else {return}
        guard let window = UIApplication.shared.keyWindow else {return}
        if #available(iOS 11.0, *) {
            if window.safeAreaInsets.top > 0.0 {
                DispatchQueue.main.async {[weak self] in
                    //makeKeyAndVisible：消息将创建一个窗口键，并将其移到其级别上任何其他窗口的前面。
                    self?.statusWindow.makeKeyAndVisible()
                    DispatchQueue.main.async {
                    //makeKey：构成了一个主窗口，但是该窗口可能部分或完全隐藏在同一级别的另一个窗口之后
                        window.makeKey()
                    }
                }
            }
        }
    }
}
