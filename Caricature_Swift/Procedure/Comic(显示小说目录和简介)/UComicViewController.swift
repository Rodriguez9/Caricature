//
//  UComicViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/11/16.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

protocol UComicViewWillEndDraggingDelegate: class {
    func comicWillEndDragging(_ scrollView: UIScrollView)
}
/**显示小说目录和简介*/
class UComicViewController: UBaseViewController {

    private var comicid: Int = 0
    
    private lazy var mainScrollView: UIScrollView = {
        let sw = UIScrollView()
        sw.delegate = self
        return sw
    }()
    
    //private lazy var detailVC:
    
    convenience init(comicid: Int){
        self.init()
        self.comicid = comicid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .top
    }
}

extension UComicViewController: UIScrollViewDelegate,UComicViewWillEndDraggingDelegate{

    func comicWillEndDragging(_ scrollView: UIScrollView) {
        
    }


}
