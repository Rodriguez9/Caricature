//
//  UCateListViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/11/17.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit
import MJRefresh

class UCateListViewController: UBaseViewController {

    private var searchString = ""
    private var topList = [TopModel]()
    private var rankList = [RankingModel]()
    
    private lazy var searchButton: UIButton = {
        let sn = UIButton(type: .system)
        sn.frame = CGRect(x: 0, y: 0, width: screenWidth - 20, height: 30)
        sn.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        sn.layer.cornerRadius = 15
        sn.setTitleColor(.white, for: .normal)
        //.withRenderingMode:返回使用指定渲染模式配置的图像的新版本
        //.alwaysOriginal:始终绘制原始图像，而不将其视为模板
        //titleEdgeInsets:按钮标题文字周围的矩形的插入或起始边距
        sn.setImage(UIImage(named: "nav_search")?.withRenderingMode(.alwaysOriginal), for: .normal)
        sn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        sn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        sn.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        return sn
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        //同一行中的项目之间使用的最小间距。
        lt.minimumInteritemSpacing = 10
        //网格中项目行之间使用的最小间距。
        lt.minimumLineSpacing = 10
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor.white
        cw.delegate = self
        cw.dataSource = self
        cw.alwaysBounceVertical = true
        cw.register(cellType: URankCCell.self)
        cw.register(cellType: UTopCCell.self)
        //下拉时
        cw.uHead = URefreshHeader{[weak self] in self?.loadData()}
        //数据为空时
        cw.uempty = UEmptyView{[weak self] in self?.loadData()}
        return cw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData(){
        ApiLoadingProvider.request(UApi.cateList, model: CateListModel.self) { (returnData) in
            self.collectionView.uempty?.allowShow = true
            //.recommendSearch：推荐搜索
            self.searchString = returnData?.recommendSearch ?? ""
            self.topList = returnData?.topList ?? []
            self.rankList = returnData?.rankingList ?? []
            
            self.searchButton.setTitle(self.searchString, for: .normal)
            self.collectionView.reloadData()
            self.collectionView.uHead.endRefreshing()
        }
    }
    
    @objc private func searchAction(){
        navigationController?.pushViewController(USearchViewController(), animated: true)
    }
   
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.titleView = searchButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil,
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                            style: .plain,
                                                            target: nil,
                                                            action: nil)
    }
}

extension UCateListViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return topList.prefix(3).count
        }else{
            return rankList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UTopCCell.self)
            cell.model = topList[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: URankCCell.self)
            cell.model = rankList[indexPath.row]
            return cell
        }
    }
    
    //要求委托人将边距应用于指定部分中的内容。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: section == 0 ? 0 : 10, right: 10)
    }
    
    //向代表询问指定项目的单元格的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(screenWidth - 40.0) / 3.0)
        return CGSize(width: width, height: (indexPath.section == 0 ? 55 : (width * 0.75 + 30)))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let model = topList[indexPath.row]
            var titles : [String] = []
            var vcs : [UIViewController] = []
            for tab in model.extra?.tabList ?? [] {
                guard let tabTitle = tab.tabTitle else {continue}
                titles.append(tabTitle)
                vcs.append(UComicListViewController(argCon: tab.argCon,
                                                    argName: tab.argName,
                                                    argValue: tab.argValue))
            }
            let vc = UPageViewController(titles: titles, vcs: vcs, pageStyle: .topTabBar)
            vc.title = model.sortName
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if indexPath.section == 1 {
            let model = rankList[indexPath.row]
            let vc = UComicListViewController(argCon: model.argCon, argName: model.argName, argValue: model.argValue)
            vc.title = model.sortName
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
