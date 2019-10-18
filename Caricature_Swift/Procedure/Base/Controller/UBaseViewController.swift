//
//  UBaseViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/8/20.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Reusable
import Kingfisher

class UBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.background
        if #available(iOS 11.0, *){
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }else{
            automaticallyAdjustsScrollViewInsets = false
        }
        
        configUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar()
    }
    
    func configUI(){}
    
    func configNavigationBar(){
        guard let navi = navigationController else {return}
        //visibleViewController:当前可见的视图可以属于导航堆栈顶部的视图控制器
        if navi.visibleViewController == self {
            navi.barStyle(.theme)
            navi.disablePopGesture = false
            navi.setNavigationBarHidden(false, animated: true)
            if navi.viewControllers.count > 1 {
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_white"),
                                                                   target: self,
                                                                   action: #selector(pressBack))
            }
        }
    }
    
    @objc func pressBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension UBaseViewController{
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
    

