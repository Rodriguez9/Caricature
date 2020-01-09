//
//  UReadViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/27.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UReadViewController: UBaseViewController {
    
    var edgeInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            return .zero
        }
    }
    //是否右边旋转
    private var isLandscapeRight: Bool! {
        didSet{
            UIApplication.changeOrientationTo(landscapeRight:isLandscapeRight)
            collectionView.reloadData()
        }
    }
    //是否隐藏Bar，是topBar向上，bottomBar向下
    private var isBarHidden: Bool = false {
        didSet{
            UIView.animate(withDuration: 0.5) {
                self.topBar.snp.updateConstraints { (make) in
                    make.top.equalTo(self.backScrollView).offset(self.isBarHidden ? -(self.edgeInsets.top + 44) : 0)
                }
                self.bottomBar.snp.updateConstraints { (make) in
                    make.bottom.equalTo(self.backScrollView).offset(self.isBarHidden ? (self.edgeInsets.bottom + 120) : 0)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private var chapterList = [ChapterModel]()
    
    private var detailStatic: DetailStaticModel?
    
    private var selectIndex: Int = 0
    /**以前的索引*/
    private var previousIndex: Int = 0
    
    private var nextIndex: Int = 0
    
    lazy var backScrollView: UIScrollView = {
        let sw = UIScrollView()
        sw.delegate = self
        //一个浮点值，它指定可应用于滚动视图内容的最小比例因子。
        sw.minimumZoomScale = 1.0
        sw.maximumZoomScale = 1.5
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        //识别手势的轻击次数
        tap.numberOfTapsRequired = 1
        sw.addGestureRecognizer(tap)
        
        let doubletap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubletap.numberOfTapsRequired = 2
        sw.addGestureRecognizer(doubletap)
        //创建对象时，在接收器和另一个手势识别器之间创建依赖关系。
        tap.require(toFail: doubletap)
        return sw
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.sectionInset = .zero
        lt.minimumLineSpacing = 10
        lt.minimumInteritemSpacing = 10
        let cw = UICollectionView(frame: .zero, collectionViewLayout: lt)
        cw.backgroundColor = .background
        cw.delegate = self
        cw.dataSource = self
        cw.register(cellType: UReadCCell.self)
        //向上滑后刷新数据后索引为上一个
        cw.uHead = URefreshAutoHeader{ [weak self] in
            let previousIndex = self?.previousIndex ?? 0
            self?.loadData(with: previousIndex, isPreious: true, needClear: false, finish: { [weak self] (finish) in
                self?.previousIndex = previousIndex - 1
            })
        }
        //向下滑后刷新数据后索引为下一个
        cw.uFoot = URefreshFooter{ [weak self] in
            let nextIndex = self?.nextIndex ?? 0
            self?.loadData(with: nextIndex, isPreious: false, needClear: false, finish: { [weak self] (finish) in
                self?.nextIndex = nextIndex + 1
            })
        }
        return cw
    }()
    
    lazy var topBar: UReadTopBar = {
        let tr = UReadTopBar()
        tr.backgroundColor = .white
        tr.backButton.addTarget(self, action: #selector(pressBack), for: .touchUpInside)
        return tr
    }()
    
    lazy var bottomBar: UReadBottomBar = {
        let bt = UReadBottomBar()
        bt.backgroundColor = .white
        bt.deviceDirectionButton.addTarget(self, action: #selector(changeDeviceDirection(_:)), for: .touchUpInside)
        bt.chapterButton.addTarget(self, action: #selector(changeChapter(_:)), for: .touchUpInside)
        return bt
    }()
    
    convenience init(detailStatic: DetailStaticModel?, selectIndex: Int){
        self.init()
        self.detailStatic = detailStatic
        self.selectIndex = selectIndex
        self.previousIndex = selectIndex - 1
        self.nextIndex = selectIndex + 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .all
        loadData(with: selectIndex, isPreious: false, needClear: false)
    }
    
    func loadData(with index: Int, isPreious: Bool, needClear: Bool, finish: ((_ finished: Bool) -> Void)? = nil) {
        guard let detailStatic = detailStatic else { return }
        topBar.titlelabel.text = detailStatic.comic?.name
        
        if index <= -1 {
            collectionView.uHead.endRefreshing()
            UNoticeBar(config: UNoticeBarConfig(title: "亲,这已经是第一页了")).show(duration: 2)
        }else if index >= detailStatic.chapter_list?.count ?? 0{
            collectionView.uFoot.endRefreshingWithNoMoreData()
            UNoticeBar(config: UNoticeBarConfig(title: "亲,已经木有了")).show(duration: 2)
        }else{
            guard let chapterId = detailStatic.chapter_list?[index].chapter_id else {return}
            ApiLoadingProvider.request(UApi.chapter(chapter_id: chapterId), model: ChapterModel.self) { (returnData) in
                self.collectionView.uHead.endRefreshing()
                self.collectionView.uFoot.endRefreshing()
                guard let chapter = returnData else {return}
                if needClear{ self.chapterList.removeAll() }
                if isPreious{
                    self.chapterList.insert(chapter, at: 0)
                }else{
                    self.chapterList.append(chapter)
                }
                self.collectionView.reloadData()
//                guard let finished = finish else {return}
//                finished(true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLandscapeRight = false
    }
    
    //点击一次
    @objc func tapAction(){
        isBarHidden = !isBarHidden
    }
    
    //点击两次
    @objc func doubleTapAction(){
        //.zoomScale:一个浮点值，该值指定应用于滚动视图内容的当前比例因子。
        var zoomScale = backScrollView.zoomScale
        zoomScale = 2.5 - zoomScale
        let width = view.frame.width / zoomScale
        let height = view.frame.height / zoomScale
        let zoomRect = CGRect(x: backScrollView.center.x - width / 2, y: backScrollView.center.y - height / 2, width: width, height: height)
        //缩放到内容的特定区域，以便在接收器中可见
        backScrollView.zoom(to: zoomRect, animated: true)
    }
    //点击横屏按钮
    @objc func changeDeviceDirection(_ button: UIButton){
        isLandscapeRight = !isLandscapeRight
        if isLandscapeRight {
            button.setImage(UIImage(named: "readerMenu_changeScreen_vertical")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }else{
             button.setImage(UIImage(named: "readerMenu_changeScreen_horizontal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    @objc func changeChapter(_ button: UIButton) {
    }
    
    override func configUI() {
        view.backgroundColor = .white
        view.addSubview(backScrollView)
        backScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.usnp.edges)
        }
        backScrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.height.equalTo(backScrollView)
        }
        
        view.addSubview(topBar)
        topBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(backScrollView)
            make.height.equalTo(44)
        }
        
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(backScrollView)
            make.height.equalTo(120)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.white)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_black"), target: self, action: #selector(pressBack))
        navigationController?.disablePopGesture = true
    }
    
    override var prefersStatusBarHidden: Bool{
        return isIphoneX ? false : true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
}

extension UReadViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chapterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapterList[section].image_list?.count ?? 0
    }
    //？？？？
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let image = chapterList[indexPath.section].image_list?[indexPath.row] else {
            return CGSize.zero
        }
        let width = backScrollView.frame.width
        let height = floor(width / CGFloat(image.width) * CGFloat(image.height))
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UReadCCell.self)
        cell.model = chapterList[indexPath.section].image_list?[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isBarHidden == false {
            isBarHidden = true
        }
    }
    
    //？？？？
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == backScrollView {
            return collectionView
        }else{
            return nil
        }
    }
    //？？？？
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView == backScrollView {
            scrollView.contentSize = CGSize(width: scrollView.frame.width * scrollView.zoomScale , height: scrollView.frame.height)
        }
    }
}

