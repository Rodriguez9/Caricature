//
//  USearchTHead.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/10/21.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

//typealias:用来为已存在的类型重新定义名称的
typealias USearchTHeadMoreActionClosure = ()->Void

protocol USearchTHeadDelagate: class {
    func searchTHead(_ searchTHead: USearchTHead, moreAction button: UIButton)
}

class USearchTHead: UBaseTableViewHeaderFooterView {
    //weak:无法确定弱引用在某一时刻是否为空时，将可能为空的实例声明为弱引用
    weak var delegate: USearchTHeadDelagate?
    
    private var moreActionClosure: USearchTHeadMoreActionClosure?
    //set
    func moreActionClosure(_ closure:@escaping USearchTHeadMoreActionClosure) {
        moreActionClosure = closure
    }
    //定义属性
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textColor = UIColor.gray
        return tl
    }()
    
    lazy var moreButton: UIButton = {
        let mn = UIButton(type: .custom)
        mn.setTitleColor(.lightGray, for: .normal)
        mn.addTarget(self, action: #selector(moreAction(button:)), for: .touchUpInside)
        return mn
    }()
    
    @objc private func moreAction(button: UIButton){
        //定义button变量给searchTHead代理参数
        delegate?.searchTHead(self, moreAction: button)
        guard let closure = moreActionClosure else {return}
        closure()
    }
    
    override func configUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(200)
        }
        
        contentView.addSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(40)
        }
        
        let line = UIView().then {$0.backgroundColor = .background}
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
    }
    
}
