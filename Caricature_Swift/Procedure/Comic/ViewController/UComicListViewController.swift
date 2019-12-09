//
//  UComicListViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/11/18.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

/**搜索结果或打开分类后显示的界面*/
class UComicListViewController: UBaseViewController {
    
    /**分类的参数*/
    private var argCon: Int = 0
    private var argName: String?
    private var argValue: Int = 0
    /**页数*/
    private var page: Int = 1
    /** 存储小说信息模型的数组 */
    private var comicList = [ComicModel]()
    
    private var spinnerName: String?
    
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.backgroundColor = UIColor.background
        tw.tableFooterView = UIView()
        tw.delegate = self
        tw.dataSource = self
        tw.register(cellType: UComicTCell.self)
        //下拉刷新时更新数据
        tw.uHead = URefreshHeader{ [weak self] in self?.loadData(more: false) }
        //上拉拉刷新时更新数据
        tw.uFoot = URefreshFooter{ [weak self] in self?.loadData(more: true)}
        //为空时
        tw.uempty = UEmptyView{ [weak self] in self?.loadData(more: false) }
        return tw
    }()
    
    convenience init(argCon: Int = 0, argName: String?, argValue: Int = 0) {
        self.init()
        self.argCon = argCon
        self.argName = argName
        self.argValue = argValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(more: false)
    }
    
     private func loadData(more: Bool){
        page = (more ? (page + 1) : 1)
        ApiLoadingProvider.request(UApi.comicList(argCon: argCon, argName: argName ?? "", argValue: argValue, page: page), model: ComicListModel.self) { [weak self] (returnData) in
            self?.tableView.uHead.endRefreshing()
            //判断是否还有数据
            if returnData?.hasMore == false{
                self?.tableView.uFoot.endRefreshingWithNoMoreData()
            }else{
                self?.tableView.uFoot.endRefreshing()
            }
            self?.tableView.uempty?.allowShow = true
            //如果状态发生改变，清除以存储的内容，否则会重复
            if !more{ self?.comicList.removeAll()}
            self?.comicList.append(contentsOf: returnData?.comics ?? [])
            self?.tableView.reloadData()
            
            guard let defaultParameters = returnData?.defaultParameters else {return}
            self?.argCon = defaultParameters.defaultArgCon
            self?.spinnerName = defaultParameters.defaultConTagType
        }
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {$0.edges.equalTo(self.view.snp.edges)}
    }
}

extension UComicListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UComicTCell.self)
        cell.spinnerName = spinnerName
        cell.indexPath = indexPath
        cell.model = comicList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = comicList[indexPath.row]
        let vc = UComicViewController(comicid: model.comicId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
