//
//  URefresh.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/10/3.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import Foundation
import MJRefresh

extension UIScrollView{
    /**下拉刷新*/
    var uHead:MJRefreshHeader{
        get {return mj_header}
        set {mj_header = newValue}
    }
    /**上拉刷新*/
    var uFoot: MJRefreshFooter{
        get {return mj_footer}
        set {mj_footer = newValue}
    }
}

/**下拉刷新,有文字刷新状态，有刷新效果*/
class URefreshHeader: MJRefreshGifHeader{
    override func prepare() {
        super.prepare()
        ////普通状态
        setImages([UIImage(named: "refresh_normal")!], for: .idle)
        ////即将刷新状态
        setImages([UIImage(named: "refresh_will_refresh")!], for: .pulling)
        //正在刷新状态
        setImages([UIImage(named: "refresh_loading_1")!,
                   UIImage(named: "refresh_loading_2")!,
                   UIImage(named: "refresh_loading_3")!], for: .refreshing)
        //隐藏更新时间文字
        lastUpdatedTimeLabel.isHidden = true
        //隐藏状态显示文字
        stateLabel.isHidden = true
    }
}

class URefreshAutoHeader: MJRefreshHeader {}

class URefreshFooter: MJRefreshBackNormalFooter {}

class URefreshAutoFooter: MJRefreshAutoFooter {}

/**上拉加载,有文字刷新状态，有刷新效果*/
class URefreshDiscoverFooter: MJRefreshBackGifFooter {
    
    override func prepare() {
        super .prepare()
        backgroundColor = UIColor.background
        setImages([UIImage(named: "refresh_discover")!], for: .idle)
        stateLabel.isHidden = true
        refreshingBlock = {self.endRefreshing()}
    }
}

/**没有任何刷新的UI，但是有刷新效果*/
class URefreshTipKissFooter: MJRefreshBackFooter {
    
    lazy var tipLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.textColor = UIColor.lightGray
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.numberOfLines = 0
        return tl
    }()
    
    lazy var imageView: UIImageView = {
        let iw = UIImageView()
        iw.image = UIImage(named: "refresh_kiss")
        return iw
    }()
    
    override func prepare() {
        super.prepare()
        backgroundColor = UIColor.background
        mj_h = 240
        addSubview(tipLabel)
        addSubview(imageView)
    }
    
    override func placeSubviews() {
        tipLabel.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 60)
        imageView.frame = CGRect(x: (bounds.width - 80) / 2, y: 110, width: 80, height: 80)
    }
    
    convenience init(with tips: String){
        self.init()
        refreshingBlock = { self.endRefreshing() }
        tipLabel.text = tips
    }
    
}
