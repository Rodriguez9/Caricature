//
//  USubscibeListViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/11/21.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

/**订阅界面*/
class USubscibeListViewController: UBaseViewController {
    
    private var subscribeList = [ComicListModel]()
    
    private lazy var collectionView: UICollectionView = {
        //需要实现UCollectionViewSectionBackgroundLayoutDelegateLayout这个代理
        let lt = UCollectionViewSectionBackgroundLayout()
        lt.minimumLineSpacing = 10
        lt.minimumInteritemSpacing = 5
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor.background
        cw.delegate = self
        cw.dataSource = self
        //.alwaysBounceVertical一个布尔值，它确定垂直滚动到达内容结尾时是否总是发生跳动。
        cw.alwaysBounceVertical = true
        cw.register(cellType: UComicCCell.self)
        //supplementaryViewType:将基于类的“ UICollectionReusableView”子类（符合“ Reusable”）注册为补充视图
        //.elementKindSectionHeader:标识给定节的标题的补充视图
        cw.register(supplementaryViewType: UComicCHead.self, ofKind: UICollectionView.elementKindSectionHeader)
        cw.register(supplementaryViewType: UComicCFoot.self, ofKind: UICollectionView.elementKindSectionFooter)
        cw.uHead = URefreshHeader{ [weak self] in self?.loadData()}
        cw.uFoot = URefreshTipKissFooter(with: "使用妖气币可以购买订阅漫画\nVIP会员购买还有优惠哦~")
        cw.uempty = UEmptyView{ [weak self] in self?.loadData()}
        return cw
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData(){
        ApiLoadingProvider.request(UApi.subscribeList,
                                   model: SubscribeListModel.self) { (returnData) in
            self.collectionView.uHead.endRefreshing()
            self.collectionView.uempty?.allowShow = true
            
            self.subscribeList = returnData?.newSubscribeList ?? []
            self.collectionView.reloadData()
        }
    }
    
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.usnp.edges)
        }
    }
    
}

extension USubscibeListViewController:UCollectionViewSectionBackgroundLayoutDelegateLayout,UICollectionViewDataSource{
    
    //返回4组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return subscribeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }
    
    //向您的数据源对象询问指定部分中的项目数。
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = subscribeList[section]
        return comicList.comics?.count ?? 0
    }
    
    //要求您的数据源对象提供补充视图以显示在集合视图中。
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            //注册补充头视图
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: UComicCHead.self)
            let comicList = subscribeList[indexPath.section]
            head.iconView.kf.setImage(urlString: comicList.titleIconUrl)
            head.titleLabel.text = comicList.itemTitle
            //有更多不隐藏
            head.moreButton.isHidden = !comicList.canMore
            head.moreActionClosure { [weak self] in
                let vc = UComicListViewController(argCon: comicList.argCon, argName: comicList.argName, argValue: comicList.argValue)
                vc.title = comicList.itemTitle
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return head
        }else{
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath, viewType: UComicCFoot.self)
            return foot
        }
    }
    
    //向委托人询问指定部分中标题视图的大小。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = subscribeList[section]
        //return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: screenWidth, height: 44) : CGSize.zero
        //判断itemTitle是否为空
        return comicList.itemTitle != "" ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }
    
    //向委托人询问指定部分中的页脚视图的大小。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        //是否是最后一个，不是有一段高度为10的空白部分
        return subscribeList.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }
    
    //注册cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
        cell.style = .withTitle
        let comicList = subscribeList[indexPath.section]
        cell.model = comicList.comics?[indexPath.row]
        return cell
    }
    
    //向代表询问指定项目的单元格的大小。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = floor(Double(screenWidth - 10.0) / 3.0)
        return CGSize(width: width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicList = subscribeList[indexPath.section]
        guard let model = comicList.comics?[indexPath.row] else {return}
        let vc = UComicViewController(comicid: model.comicId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
    
    

