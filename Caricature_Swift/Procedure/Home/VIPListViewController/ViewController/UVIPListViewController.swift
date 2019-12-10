//
//  UVIPListViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/11/21.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UVIPListViewController: UBaseViewController {
    
    private var vipList = [ComicListModel]()
    
    private lazy var collectView: UICollectionView = {
        let lt = UCollectionViewSectionBackgroundLayout()
        lt.minimumLineSpacing = 10
        lt.minimumInteritemSpacing = 5
        let cw = UICollectionView(frame: .zero, collectionViewLayout: lt)
        cw.backgroundColor = .background
        cw.register(cellType: UComicCCell.self)
        cw.register(supplementaryViewType: UComicCHead.self, ofKind: UICollectionView.elementKindSectionHeader)
        cw.register(supplementaryViewType: UComicCFoot.self, ofKind: UICollectionView.elementKindSectionFooter)
        cw.delegate = self
        cw.dataSource = self
        cw.alwaysBounceVertical = true
        cw.uHead = URefreshHeader(refreshingBlock: {
            [weak self] in self?.loadDate()
        })
        cw.uFoot = URefreshTipKissFooter(with: "VIP用户专享\nVIP用户可以免费阅读全部漫画哦~")
        cw.uempty = UEmptyView(tapClosure: {
            [weak self] in self?.loadDate()
        })
        return cw
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDate()
    }
    
    private func loadDate(){
        ApiLoadingProvider.request(UApi.vipList, model: VipListModel.self) { (returnData) in
            self.collectView.uHead.endRefreshing()
            self.collectView.uempty?.allowShow = true
            
            self.vipList = returnData?.newVipList ?? []
            self.collectView.reloadData()
        }
    }
    
    override func configUI() {
        view.addSubview(collectView)
        collectView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.usnp.edges)
        }
    }
    
}

extension UVIPListViewController:UCollectionViewSectionBackgroundLayoutDelegateLayout,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vipList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = vipList[section]
        return comicList.comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath,viewType: UComicCHead.self)
            let comicList = vipList[indexPath.section]
            head.iconView.kf.setImage(urlString: comicList.titleIconUrl)
            head.titleLabel.text = comicList.itemTitle
            head.moreButton.isHidden = !comicList.canMore
            head.moreActionClosure {
                let vc = UComicListViewController(argCon: comicList.argCon, argName: comicList.argName, argValue: comicList.argValue)
                vc.title = comicList.itemTitle
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return head
        }else{
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath,viewType: UComicCFoot.self)
            return foot
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = vipList[section]
        return comicList.itemTitle != "" ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return vipList.count - 1 == section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
        cell.style = .withTitle
        let comicList = vipList[indexPath.section]
        cell.model = comicList.comics?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(screenWidth - 10.0) / 3.0)
        return CGSize(width: width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicList = vipList[indexPath.section]
        guard let model = comicList.comics?[indexPath.row] else {return}
        let vc = UComicViewController(comicid: model.comicId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
