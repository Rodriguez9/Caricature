//
//  UMineViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/10/18.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UMineViewController: UBaseViewController {

    private lazy var myArray: Array = {
        return [[["icon":"mine_vip", "title": "我的VIP"],
                 ["icon":"mine_coin", "title": "充值妖气币"]],
                
                [["icon":"mine_accout", "title": "消费记录"],
                 ["icon":"mine_subscript", "title": "我的订阅"],
                 ["icon":"mine_seal", "title": "我的封印图"]],
                
                [["icon":"mine_message", "title": "我的消息/优惠券"],
                 ["icon":"mine_cashew", "title": "妖果商城"],
                 ["icon":"mine_freed", "title": "在线阅读免流量"]],
                
                [["icon":"mine_feedBack", "title": "帮助中心"],
                 ["icon":"mine_mail", "title": "我要反馈"],
                 ["icon":"mine_judge", "title": "给我们评分"],
                 ["icon":"mine_author", "title": "成为作者"],
                 ["icon":"mine_setting", "title": "设置"]]]
    }()
    
    private lazy var head: UMineHead = {
        return UMineHead(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
    }()
    
    private lazy var navigationBatY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    
    lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .grouped)
        tw.backgroundColor = UIColor.background
        tw.delegate = self
        tw.dataSource = self
        tw.register(cellType: UBaseTableViewCell.self)
        return tw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //为视图控制器扩展的边缘
        edgesForExtendedLayout = .top
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            //priority 优先级用法
            make.edges.equalTo(self.view.usnp.edges).priority(.low)
            make.top.equalToSuperview()
        }
        tableView.parallaxHeader.view = head
        tableView.parallaxHeader.height = 200
        tableView.parallaxHeader.minimumHeight = navigationBatY
        tableView.parallaxHeader.mode = .fill
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.clear)
        //contentOffset:内容视图的原点与滚动视图的原点偏移的点
        //tableView初始的偏移位置
        tableView.contentOffset = CGPoint(x: 0, y: -tableView.parallaxHeader.height)
    }
    
}

extension UMineViewController: UITableViewDelegate, UITableViewDataSource{
    
    //UITableViewDelegate实现了UIScrollViewDelegate代理
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= -(scrollView.parallaxHeader.minimumHeight) {
            navigationController?.barStyle(.theme)
            navigationController?.title = "我的"
        }else{
            navigationController?.barStyle(.clear)
            navigationController?.title = ""
        }
    }
    
    //组别
    func numberOfSections(in tableView: UITableView) -> Int {
        return myArray.count
    }
    
    //每组个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArray = myArray[section]
        return sectionArray.count
    }
    
    //特定节的标题的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //leastNormalMagnitude：最小正数
        return CGFloat.leastNormalMagnitude
    }
    
    //标头的自定义视图。 将调整为默认或指定的标题高度
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UBaseTableViewCell.self)
        //accessoryType：单元使用的标准附件控件的类型
        //disclosureIndicator：将附件视图本身连接到推送按钮以显示该内容。
        cell.accessoryType = .disclosureIndicator
        //selectionStyle：单元格的选择样式
        cell.selectionStyle = .default
        let sectionArray = myArray[indexPath.section]
        let dict:[String:String] = sectionArray[indexPath.row]
        cell.imageView?.image = UIImage(named: dict["icon"] ?? "")
        cell.textLabel?.text = dict["title"]
        return cell
    }
    
    //现在已选择指定的行
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //如果已选择，则取消选择指定索引处的行
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
   
    

    
}
