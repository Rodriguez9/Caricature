//
//  UTabBarController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/8/9.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        
        //我的
        
    }
    
//    func addChildViewController(_ childController: UIViewController, title:String?, image:UIImage? ,selectedImage:UIImage?) {
//       
//        childController.title = title
//        childController.tabBarItem = UITabBarItem(title: nil, image: image?.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
//        if UIDevice.current.userInterfaceIdiom == .phone{
//            childController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        }
//        addChild(<#T##childController: UIViewController##UIViewController#>)
//        
//    }
    
    
    
}
