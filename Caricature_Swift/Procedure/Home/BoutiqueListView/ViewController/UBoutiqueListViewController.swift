//
//  UBoutiqueListViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/11/21.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit
//轮播图
import LLCycleScrollView

/**主頁面*/
class UBoutiqueListViewController: UBaseViewController {

    //性别
    private var sexType: Int = UserDefaults.standard.integer(forKey: String.sexTypeKey)
    private var galleyItems = [GalleryItemModel]()
    private var Textitems = [TextItemModel]()
    private var comicLists = [ComicListModel]()
    
    private lazy var bannerView: LLCycleScrollView = {
        let bw = LLCycleScrollView()
        bw.backgroundColor = UIColor.background
        bw.autoScrollTimeInterval = 6
        bw.placeHolderImage = UIImage(named: "normal_placeholder")
        bw.coverImage = UIImage()
        bw.pageControlPosition = .right
        bw.pageControlBottom = 20
        bw.titleBackgroundColor = UIColor.clear
        //回調
        bw.lldidSelectItemAtIndex = didSelectBanner(index:)
        return bw
    }()
    
    private lazy var sexTypeButton: UIButton = {
        let sn = UIButton(type: .custom)
        sn.setTitleColor(.black, for: .normal)
        sn.addTarget(self, action: #selector(changeSex), for: .touchUpInside)
        return sn
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UCollectionViewSectionBackgroundLayout()
        lt.minimumInteritemSpacing = 5
        lt.minimumLineSpacing = 10
        let cw = UICollectionView(frame: .zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor.background
        cw.delegate = self
        cw.dataSource = self
        cw.alwaysBounceVertical = true
        //定義了collectionView上面的空間用於存放bannerView
        cw.contentInset = UIEdgeInsets(top: screenWidth * 0.467, left: 0, bottom: 0, right: 0)
        cw.scrollIndicatorInsets = cw.contentInset
        cw.register(cellType: UComicCCell.self)
        cw.register(cellType: UBoardCCell.self)
        cw.register(supplementaryViewType: UComicCHead.self, ofKind: UICollectionView.elementKindSectionHeader)
        cw.register(supplementaryViewType: UComicCFoot.self, ofKind: UICollectionView.elementKindSectionFooter)
        cw.uHead = URefreshHeader{ [weak self] in self?.loadData(false) }
        cw.uempty = UEmptyView(verticalOffset: -(cw.contentInset.top), tapClosure: {
            self.loadData(false)
        })
        cw.uFoot = URefreshDiscoverFooter()
        return cw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(false)
    }
    
    @objc private func changeSex(){
        loadData(true)
    }
    
    private func didSelectBanner(index:NSInteger){
        let item = galleyItems[index]
        if item.linkType == 2 {
            //.compactMap:返回一个数组，其中包含使用该序列的每个元素调用给定转换的非零结果,compactMap:将从容器中取出一个值，使用您指定的代码对其进行转换，然后将其放回容器中，但是如果您的转换返回一个可选值，它将被解包并丢弃所有nil值
            guard let url = item.ext?.compactMap({return $0.key == "url" ? $0.val : nil}).joined() else {return}
            let vc = UWebViewController(url: url)
            navigationController?.pushViewController(vc, animated: true)
        }else{
            guard let comicIdString = item.ext?.compactMap({return $0.key == "comicId" ? $0.val : nil}).joined(),let comicId = Int(comicIdString) else {return}
            let vc = UComicViewController(comicid: comicId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func loadData(_ changeSex: Bool){
        if changeSex {
            sexType = 3 - sexType
            UserDefaults.standard.set(sexType, forKey: String.sexTypeKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: .USexTypeDidChange, object: nil)
        }
        
        ApiLoadingProvider.request(UApi.boutiqueList(sexType: sexType), model: BoutiqueListModel.self) { [weak self] (returnData) in
            self?.galleyItems = returnData?.galleryItems ?? []
            self?.Textitems = returnData?.textItems ?? []
            self?.comicLists = returnData?.comicLists ?? []
            
            self?.sexTypeButton.setImage(UIImage(named: self?.sexType == 1 ? "gender_male" : "gender_female"), for: .normal)
            
            self?.collectionView.uHead.endRefreshing()
            self?.collectionView.uempty?.allowShow = true
            
            self?.collectionView.reloadData()
            self?.bannerView.imagePaths = self?.galleyItems.filter{ $0.cover != nil}.map{ $0.cover! } ?? []
        }
    }
    
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            //.contentInset:内容视图从安全区域或滚动视图边缘插入的自定义距离
            make.height.equalTo(collectionView.contentInset.top)
        }
        
        view.addSubview(sexTypeButton)
        sexTypeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-20)
            make.right.equalToSuperview()
        }
    }
    
}

extension UBoutiqueListViewController: UCollectionViewSectionBackgroundLayoutDelegateLayout,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comicLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return .white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = comicLists[section]
        return comicList.comics?.prefix(4).count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: UComicCHead.self)
            let comicList = comicLists[indexPath.section]
            head.iconView.kf.setImage(urlString: comicList.newTitleIconUrl)
            head.titleLabel.text = comicList.itemTitle
            head.moreActionClosure { [weak self] in
                if comicList.comicType == .thematic{
                    let vc = UPageViewController(titles: ["漫畫","次元"], vcs: [USpecialViewController(argCon: 2),USpecialViewController(argCon: 4)], pageStyle: .navgationBarSegment)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else if comicList.comicType == .animation {
                    let vc = UWebViewController(url: "http://m.u17.com/wap/cartoon/list")
                    vc.title = "動畫"
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else if comicList.comicType == .update{
                    let vc = UUpdateListViewController(argCon: comicList.argCon,
                                                       argName: comicList.argName,
                                                       argValue: comicList.argValue)
                    self?.title = comicList.itemTitle
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = UComicListViewController(argCon: comicList.argCon,
                                                      argName: comicList.argName,
                                                      argValue: comicList.argValue)
                    vc.title = comicList.itemTitle
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return head
        }else{
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath, viewType: UComicCFoot.self)
            return foot
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return comicLists.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = comicLists[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UBoardCCell.self)
            cell.model = comicList.comics?[indexPath.row]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
            if comicList.comicType == .thematic {
                cell.style = .none
            }else{
                cell.style = .withTitleAndDesc
            }
            cell.model = comicList.comics?[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let width = floor((screenWidth - 15.0) / 4.0)
            return CGSize(width: width, height: 80)
        }else {
            if comicList.comicType == .thematic {
                let width = floor((screenWidth - 5.0) / 2.0)
                return CGSize(width: width, height: 120)
            }else{
                let count = comicList.comics?.takeMax(4).count ?? 0
                let warp = count % 2 + 2
                let width = floor((screenWidth - CGFloat(warp - 1) * 5.0) / CGFloat(warp))
                return CGSize(width: width, height: CGFloat(warp * 80))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicList = comicLists[indexPath.section]
        guard let item = comicList.comics?[indexPath.row] else {return}
        
        if comicList.comicType == .billboard {
            let vc = UComicListViewController(argName: item.argName, argValue: item.argValue)
            vc.title = item.name
            navigationController?.pushViewController(vc, animated: true)
        } else {
            if item.linkType == 2 {
                guard let url = item.ext?.compactMap({return $0.key == "url" ? $0.val : nil}).joined() else {return}
                let vc = UWebViewController(url: url)
                navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = UComicViewController(comicid: item.comicId)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //當滾動時觸發
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            bannerView.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(min(0, -(scrollView.contentOffset.y + scrollView.contentInset.top)))
            }
        }
    }
    
    //開始拖拽時
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            UIView.animate(withDuration: 0.5) {
                self.sexTypeButton.transform = CGAffineTransform(translationX: 50, y: 0)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == collectionView {
            UIView.animate(withDuration: 0.5) {
                self.sexTypeButton.transform = CGAffineTransform.identity
            }
        }
    }
    
}
