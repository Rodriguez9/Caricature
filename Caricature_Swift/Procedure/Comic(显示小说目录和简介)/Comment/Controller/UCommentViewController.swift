//
//  UCommentViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/27.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UCommentViewController: UBaseViewController {
    
    private var listArray = [UCommentViewModel]()
    
    var detailStatic: DetailStaticModel?
    
    var commentList: CommentListModel?{
        didSet{
            guard let commentList = commentList?.commentList else { return }
            //.compactMap返回一个数组，其中包含使用该序列的每个元素调用给定转换的非零结果。
            //comment为调用该方法的对象，即commentList
            //使CommentModel模型变成UCommentViewModel
            let viewModelArray = commentList.compactMap { (comment) -> UCommentViewModel? in
                return UCommentViewModel(model: comment)
            }
            //将序列或集合的元素添加到此集合的末尾
            listArray.append(contentsOf: viewModelArray)
        }
    }
    
    weak var delegate: UComicViewWillEndDraggingDelegate?
    
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.delegate = self
        tw.dataSource = self
        tw.register(cellType: UCommentTCell.self)
        tw.uFoot = URefreshFooter { self.loadData() }
        return tw
    }()
    
    func loadData(){
        ApiProvider.request(UApi.commentList(object_id: detailStatic?.comic?.comic_id ?? 0,
                                             thread_id: detailStatic?.comic?.thread_id ?? 0,
                                             page: commentList?.serverNextPage ?? 0),
                            model: CommentListModel.self) { (returnData) in
                                if returnData?.hasMore == true{
                                    self.tableView.uFoot.endRefreshing()
                                } else {
                                    self.tableView.uFoot.endRefreshingWithNoMoreData()
                                }
                                self.commentList = returnData
                                self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadData(){
        tableView.reloadData()
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in make.edges.equalTo(view.usnp.edges)}
    }
    
}

extension UCommentViewController: UITableViewDelegate,UITableViewDataSource{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listArray[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UCommentTCell.self)
        cell.viewModel = listArray[indexPath.row]
        return cell
    }
}
