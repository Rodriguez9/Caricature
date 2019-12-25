//
//  UDetailViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/23.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

/**显示小说目录和简介界面详情界面部分*/
class UDetailViewController: UBaseViewController {
    
    weak var delegate: UComicViewWillEndDraggingDelegate?
    /**详情静态数据*/
    var detailStatic: DetailStaticModel?
    /**详情动态数据*/
    var detailRealtime: DetailRealtimeModel?
    
    var guessLike : GuessLikeModel?
    
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.delegate = self
        tw.dataSource = self
        tw.backgroundColor = .background
        tw.separatorStyle = .none
        tw.register(cellType: UDescriptionTCell.self)
        tw.register(cellType: UOtherWorksTCell.self)
        tw.register(cellType: UTicketTCell.self)
        tw.register(cellType: UGuessLikeTCell.self)
        return tw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadData(){
        tableView.reloadData()
    }
    
    override func configUI() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.usnp.edges)
        }
    }
}

extension UDetailViewController: UITableViewDelegate,UITableViewDataSource{
    
    //当用户滚动时调用
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return detailStatic != nil ? 4 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 1 && detailStatic?.otherWorks?.count == 0) ? 0 : 1
    }
    
    //向委托人询问要用于特定节的标题的高度,返回的自定义标题视图的高度。
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    //要求委托提供一个视图对象以显示在表视图的指定部分的标题中。
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    //要求委托人指定在指定位置行的高度。
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UDescriptionTCell.height(for: detailStatic)
        }else if indexPath.section == 3{
            return 200
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UDescriptionTCell.self)
            cell.model = detailStatic
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UOtherWorksTCell.self)
            cell.model = detailStatic
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UTicketTCell.self)
            cell.model = detailRealtime
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UGuessLikeTCell.self)
            cell.model = guessLike
            cell.didSelectClosure { [weak self] (comic) in
                let vc = UComicViewController(comicid: comic.comic_id)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UOtherWorksViewController(otherWorks: detailStatic?.otherWorks)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == 1 && detailStatic?.otherWorks?.count == 0 ) ? CGFloat.leastNormalMagnitude : 10
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
