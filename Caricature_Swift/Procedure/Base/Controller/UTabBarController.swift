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
        
        //一个布尔值，指示标签栏是否为半透明。
        tabBar.isTranslucent = false
        
        ///首页
        let onePageVC = UHomeViewController(titles: ["推荐","VIP","订阅","排行"],
                                            vcs: [UBoutiqueListViewController(),
                                                  UVIPListViewController(),
                                                  USubscibeListViewController(),
                                                  URankListViewController()],
                                            pageStyle: .navgationBarSegment)
        addChildViewController(onePageVC, title: "首页",
                               image: UIImage(named: "tab_home"),
                               selectedImage: UIImage(named: "tab_home_S"))
        
        
        ///书架
        let bookVC = UBookViewController(titles: ["收藏","书单","下载"],
                                         vcs: [UCollectListViewController(),
                                               UDocumentListViewController(),
                                               UDownloadListViewController()],
                                         pageStyle: .navgationBarSegment)
        addChildViewController(bookVC, title: "书架",
                               image: UIImage(named: "tab_book"),
                               selectedImage: UIImage(named: "tab_book_S"))
        
        ///分类
        let classVC = UCateListViewController()
        addChildViewController(classVC,
                               title: "分类",
                               image: UIImage(named: "tab_class"),
                               selectedImage: UIImage(named: "tab_class_S"))
        
        ///我的
        let mineVC = UMineViewController()
        addChildViewController(mineVC,
                               title: "我的",
                               image: UIImage(named: "tab_mine"),
                               selectedImage: UIImage(named: "tab_mine_S"))

    }
    
     func addChildViewController(_ childController: UIViewController, title:String?, image:UIImage? ,selectedImage:UIImage?) {
          
          childController.title = title
          childController.tabBarItem = UITabBarItem(title: nil,
                                                    image: image?.withRenderingMode(.alwaysOriginal),
                                                    selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
          
          if UIDevice.current.userInterfaceIdiom == .phone {
              childController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
          }
          addChild(UNavigationController(rootViewController: childController))
      }
}

extension UTabBarController{
    //状态栏的风格
    override var preferredStatusBarStyle: UIStatusBarStyle{
        guard let select = selectedViewController else {return .lightContent}
        return select.preferredStatusBarStyle
    }
}

