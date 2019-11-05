//
//  USearchViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/10/22.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit
import Moya

class USearchViewController: UBaseViewController {
    
    //Cancellable：定义从请求返回的不透明类型的协议。
    private var currentRequest:Cancellable?
    
    private var hotItems: [SearchItemModel]?
    
    private var relative: [SearchItemModel]?
    
    private var comics: [ComicModel]?
    
    private lazy var searchHistory: [String]! = {
        //[String]  字符串数组类型，[String]()对字符串数组类型的初始化
        return UserDefaults.standard.value(forKey: String.searchHistoryKey) as? [String] ?? [String]()
    }()
    
    private lazy var searchBar: UITextField = {
        let sr = UITextField()
        sr.backgroundColor = UIColor.white
        sr.textColor = UIColor.gray
        sr.tintColor = UIColor.darkGray
        sr.font = UIFont.systemFont(ofSize: 15)
        sr.placeholder = "输入漫画名称/作者"
        sr.layer.cornerRadius = 15
        //.leftView:叠加视图显示在文本字段的左侧
        sr.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        //.always:如果文本字段包含文本，则始终显示覆盖视图
        //.leftViewMode控制左叠加视图何时出现在文本字段中
        sr.leftViewMode = .always
        //clearsOnBeginEditing指示开始编辑时文本字段是否删除旧文本
        sr.clearsOnBeginEditing = true
        //.clearButtonMode:控制标准清除按钮何时出现在文本字段中
        //.whileEditing:仅当在文本字段中编辑文本时才显示覆盖视图
        sr.clearButtonMode = .whileEditing
        //returnKeyType:Return键的可见标题
        sr.returnKeyType = .search
        sr.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFiledTextDidChange(noti:)), name: UITextField.textDidChangeNotification, object: sr)
        return sr
    }()
    
    //一開始看到的
    private lazy var historyTableView: UITableView = {
        //.grouped:表格视图滚动时，节的页眉和页脚不会浮动
        let tw = UITableView(frame: CGRect.zero, style: .grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.register(headerFooterViewType: USearchTHead.self)
        tw.register(cellType: UBaseTableViewCell.self)
        tw.register(headerFooterViewType: USearchTFoot.self)
        return tw
    }()
    
    //點擊輸入欄時候看到的
    lazy var searchTableView: UITableView = {
        let sw = UITableView(frame: CGRect.zero, style: .grouped)
        sw.delegate = self
        sw.dataSource = self
        sw.register(headerFooterViewType: USearchTHead.self)
        sw.register(cellType: UBaseTableViewCell.self)
        return sw
    }()
    
    //搜索結果，點擊搜索內容後顯示
    lazy var resultTableView: UITableView = {
        let rw = UITableView(frame: CGRect.zero, style: .grouped)
        rw.delegate = self
        rw.dataSource = self
        rw.register(cellType: UComicTCell.self)
        return rw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHistory()
    }
    
    //当对象结束其生命周期时，系统自动执行析构函数
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadHistory(){
        historyTableView.isHidden = false
        searchTableView.isHidden = true
        resultTableView.isHidden = true
        //訪問接口，搜索热门
        ApiLoadingProvider.request(UApi.searchHot, model: HotItemsModel.self) { (returnData) in
            self.hotItems = returnData?.hotItems
            self.historyTableView.reloadData()
        }
    }
    
    //相关搜索
    private func searchRelative(_ text: String){
        if text.count > 0 {
            historyTableView.isHidden = true
            searchTableView.isHidden = false
            resultTableView.isHidden = true
            //取消所代表的请求
            currentRequest?.cancel()
            currentRequest = ApiProvider.request(UApi.searchRelative(inputText: text),
                                model: [SearchItemModel].self) { (returnData) in
                                    self.relative = returnData
                                    self.searchTableView.reloadData()
                                }
        }else {
            historyTableView.isHidden = false
            searchTableView.isHidden = true
            resultTableView.isHidden = true
        }
    }
    
    //搜索结果
    private func searchResult(_ text: String){
        if text.count > 0 {
            historyTableView.isHidden = true
            searchTableView.isHidden = true
            resultTableView.isHidden = false
            searchBar.text = text
            ApiLoadingProvider.request(UApi.searchResult(argCon: 0, q: text),
                                       model: SearchResultModel.self) { (returnData) in
                                            self.comics = returnData?.comics
                                            self.resultTableView.reloadData()
                                        }
            let defaults = UserDefaults.standard
            var history = defaults.value(forKey: String.searchHistoryKey) as? [String] ?? [String]()
            //移除所有與text相同的
            history.removeAll([text])
            history.insertFirst(text)
            searchHistory = history
            historyTableView.reloadData()
            defaults.set(searchHistory, forKey: String.searchHistoryKey)
            defaults.synchronize()
        }else{
            historyTableView.isHidden = false
            searchTableView.isHidden = true
            resultTableView.isHidden = true
        }
    }
    
    override func configUI() {
        view.addSubview(historyTableView)
        historyTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.usnp.edges)
        }
        view.addSubview(searchTableView)
        searchTableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.titleView = searchBar
        searchBar.frame = CGRect(x: 0, y: 0, width: screenWidth - 50, height: 30)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil,
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消",
                                                            target: self,
                                                            action: #selector(cancelAction))
    }
    
    @objc private func cancelAction(){
        //.resignFirstResponder：默认实现返回YES，从而退出第一响应者状态
        searchBar.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
}

extension USearchViewController: UITextFieldDelegate{
    
    @objc func textFiledTextDidChange(noti: Notification){
        guard let textField = noti.object as? UITextField,
            let text = textField.text else {return}
        searchRelative(text)
    }
    
    //每当用户点击返回按钮时，文本字段就会调用此方法
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //点击返回按钮时关闭键盘，则您的实现可以调用该方法
        return textField.resignFirstResponder()
    }
}

extension USearchViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == historyTableView {
            return 2
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTableView {
            return section == 0 ? (searchHistory?.prefix(5).count ?? 0) : 0
        }else if tableView == searchTableView{
            return relative?.count ?? 0
        }else{
            return comics?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == resultTableView {
            return 180
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UBaseTableViewCell.self)
            cell.textLabel?.text = searchHistory?[indexPath.row]
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            //距离边缘
            cell.separatorInset = .zero
            return cell
        }else if tableView == searchTableView{
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UBaseTableViewCell.self)
            cell.textLabel?.text = relative?[indexPath.row].name
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.separatorInset = .zero
            return cell
        }else if tableView == resultTableView{
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UComicTCell.self)
            cell.model = comics?[indexPath.row]
            return cell
        }else{
            let  cell = tableView.dequeueReusableCell(for: indexPath, cellType: UBaseTableViewCell.self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == historyTableView {
            searchResult(searchHistory[indexPath.row])
        }else if tableView == searchTableView{
            searchResult(relative?[indexPath.row].name ?? "")
        }else if tableView == resultTableView{
            guard let model = comics?[indexPath.row] else {return}
            //還沒定義
        }
    }
    
    //使用此方法可以指定方法返回的自定义标题视图的高度。
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == historyTableView {
            return 44
        }else if tableView == searchTableView{
            return comics?.count ?? 0 > 0 ? 44 : CGFloat.leastNormalMagnitude
        }else{
            //比较小于或等于所有正数的正数
            return CGFloat.leastNormalMagnitude
        }
    }
    
    //使用此方法可以指定方法返回的自定义标题视图。
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == historyTableView {
            let head = tableView.dequeueReusableHeaderFooterView(USearchTHead.self)
            head?.titleLabel.text = section == 0 ?  "看看你都搜过什么" : "大家都在搜"
            head?.moreButton.setImage(section == 0 ? UIImage(named: "search_history_delete") : UIImage(named: "search_keyword_refresh"), for: .normal)
            head?.moreButton.isHidden = section == 0 ? (searchHistory.count == 0) : false
            head?.moreActionClosure {[weak self] in
                if section == 0{
                    self?.searchHistory?.removeAll()
                    self?.historyTableView.reloadData()
                    UserDefaults.standard.removeObject(forKey: String.searchHistoryKey)
                    UserDefaults.standard.synchronize()
                }else{
                    self?.loadHistory()
                }
            }
            return head
        }else if tableView == searchTableView{
            let head = tableView.dequeueReusableHeaderFooterView(USearchTHead.self)
            head?.titleLabel.text = "找到相关的漫画 \(comics?.count ?? 0)本"
            head?.moreButton.isHidden = true
            return head
        }else{
            return nil
        }
    }
    
    //使用此方法可以指定方法返回的自定义标题视图的高度。
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == historyTableView {
            return section == 0 ? 10 : tableView.frame.height - 44
        }else{
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == historyTableView && section == 1 {
            let foot = tableView.dequeueReusableHeaderFooterView(USearchTFoot.self)
            foot?.data = hotItems ?? []
//            foot?.didSelectIndexClosure{ [weak self] (index, model) in
//               // let vc = UComic
//                
//            }
            return foot
        }else{
            return nil
        }
    }
    
}
