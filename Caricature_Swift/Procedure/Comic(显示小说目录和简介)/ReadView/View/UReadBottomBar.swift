//
//  UReadBottomBar.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2020/1/3.
//  Copyright © 2020 姚智豪. All rights reserved.
//

import UIKit

class UReadBottomBar: UIView {

    lazy var menuSlider: UISlider = {
        let mr = UISlider()
        mr.thumbTintColor = .theme
        mr.minimumTrackTintColor = .theme
        //不连续
        mr.isContinuous = false
        return mr
    }()
    
    //横屏按钮
    lazy var deviceDirectionButton: UIButton = {
        let dn = UIButton(type: .system)
        dn.setImage(UIImage(named: "readerMenu_changeScreen_horizontal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return dn
    }()
    
    //亮度
    lazy var lightButton: UIButton = {
        let ln = UIButton(type: .system)
        //.alwaysOriginal:始终绘制原始图像，而不将其视为模板。
        //.withRenderingMode:返回使用指定渲染模式配置的图像的新版本。
        ln.setImage(UIImage(named: "readerMenu_luminance")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return ln
    }()
    
    //目录
    lazy var chapterButton: UIButton = {
        let cn = UIButton(type: .system)
        cn.setImage(UIImage(named: "readerMenu_catalog")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return cn
       }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(){
        addSubview(menuSlider)
        menuSlider.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 40))
            make.height.equalTo(30)
        }
        
        addSubview(deviceDirectionButton)
        addSubview(lightButton)
        addSubview(chapterButton)
        
        //三个n按钮组成一行
        let buttonAttay = [deviceDirectionButton,lightButton,chapterButton]
        buttonAttay.snp.distributeViewsAlong(axisType: .horizontal,fixedItemLength: 60,leadSpacing: 40,tailSpacing: 40)
        buttonAttay.snp.makeConstraints { (make) in
            make.top.equalTo(menuSlider.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
    
}
