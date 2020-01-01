//
//  UComicViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/11/16.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

//UComicView将结束拖动
protocol UComicViewWillEndDraggingDelegate: class {
    func comicWillEndDragging(_ scrollView: UIScrollView)
}
/**显示小说目录和简介,一个scrollView包含三个控制器*/
class UComicViewController: UBaseViewController {

    private var comicid: Int = 0
    private var detailStatic: DetailStaticModel?
    private var detailRealtime: DetailRealtimeModel?
    
    private lazy var mainScrollView: UIScrollView = {
        let sw = UIScrollView()
        sw.delegate = self
        return sw
    }()
    
    //详情
    private lazy var detailVC: UDetailViewController = {
        let dc = UDetailViewController()
        dc.delegate = self
        return dc
    }()
    
    //目录
    private lazy var chapterVC: UChapterViewController = {
        let cc = UChapterViewController()
        cc.delegate = self
        return cc
    }()
    
    //评论
    private lazy var comment: UCommentViewController = {
        let ct = UCommentViewController()
        ct.delegate = self
        return ct
    }()
    
    //导航栏的高度
    private lazy var navigationBarY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    
    private lazy var pageVC: UPageViewController = {
        return UPageViewController(titles: ["详情", "目录", "评论"],
                                   vcs: [detailVC,chapterVC,comment],
                                   pageStyle: .topTabBar)
    }()
    
    //最上面介绍漫画信息部分
    lazy var headView: UComicHead = {
        return UComicHead(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: navigationBarY + 150))
    }()
    
    convenience init(comicid: Int){
        self.init()
        self.comicid = comicid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //为视图控制器扩展的边缘。
        edgesForExtendedLayout = .top
    }
    
    //通知视图控制器其视图将被添加到视图层次结构中。
    //视图将会出现
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.changeOrientationTo(landscapeRight: false)
        loadData()
    }
    
    func loadData(){
        
        let group = DispatchGroup()
        
        group.enter()
        ApiLoadingProvider.request(UApi.detailStatic(comicid: comicid),
                                   model: DetailStaticModel.self) { [weak self] (detailStatic) in
                                    self?.detailStatic = detailStatic
                                    self?.headView.detailStatic = detailStatic?.comic
                                    
                                    self?.detailVC.detailStatic = detailStatic
                                    self?.chapterVC.detailStatic = detailStatic
                                    self?.comment.detailStatic = detailStatic
                                    //需要调用detailStatic的内容
                                    ApiProvider.request(UApi.commentList(object_id: detailStatic?.comic?.comic_id ?? 0,
                                                                         thread_id: detailStatic?.comic?.thread_id ?? 0,
                                                                         page: -1),
                                                        model: CommentListModel.self) { [weak self] (commentList) in
                                        self?.comment.commentList = commentList
                                        group.leave()
                                    }
        }
        
        group.enter()
        ApiProvider.request(UApi.detailRealtime(comicid: comicid),
                            model: DetailRealtimeModel.self) { [weak self] (returnData) in
            self?.detailRealtime = returnData
            self?.headView.detailRealtime = returnData?.comic
            
            self?.detailVC.detailRealtime = returnData
            self?.chapterVC.detailRealtime = returnData
            
            group.leave()
        }
        
        group.enter()
        ApiProvider.request(UApi.guessLike,
                            model: GuessLikeModel.self) { (returnData) in
            self.detailVC.guessLike = returnData
            group.leave()
        }
        
        //当group内容完成后，给主队列一个通知，并调用闭包的内容
        group.notify(queue: DispatchQueue.main) {
            self.detailVC.reloadData()
            self.chapterVC.reloadData()
            self.comment.reloadData()
        }
        
    }
    
    override func configUI() {
        
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.usnp.edges).priority(.low)
            make.top.equalToSuperview()
        }
        
        let contentView = UIView()
        mainScrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().offset(-navigationBarY)
        }
        
        //添加控制器
        addChild(pageVC)
        contentView.addSubview(pageVC.view)
        pageVC.view.snp.makeConstraints { (make) in make.edges.equalToSuperview() }
        
        mainScrollView.parallaxHeader.view = headView
        mainScrollView.parallaxHeader.height = navigationBarY + 150
        mainScrollView.parallaxHeader.minimumHeight = navigationBarY
        mainScrollView.parallaxHeader.mode = .fill
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.clear)
        mainScrollView.contentOffset = CGPoint(x: 0, y: -mainScrollView.parallaxHeader.height)
    }
    
}

extension UComicViewController: UIScrollViewDelegate,UComicViewWillEndDraggingDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if  scrollView.contentOffset.y >= -scrollView.parallaxHeader.minimumHeight {
            navigationController?.barStyle(.theme)
            navigationItem.title = detailStatic?.comic?.name
        }else{
            navigationController?.barStyle(.clear)
            navigationItem.title = ""
        }
    }
    
    func comicWillEndDragging(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 0 {
            //向下拉
            mainScrollView.setContentOffset(CGPoint(x: 0, y: -self.mainScrollView.parallaxHeader.minimumHeight),
                                            animated: true)
        }else if scrollView.contentOffset.y < 0 {
            //向上拉
            mainScrollView.setContentOffset(CGPoint(x: 0, y: -self.mainScrollView.parallaxHeader.height),
                                            animated: true)
        }
    }


}
