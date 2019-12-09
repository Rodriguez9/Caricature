//
//  UComicCHead.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/4.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

typealias UComicCHeadMoreActionClosure = ()->Void

protocol UComicCHeadDelegate:class {
    func comicChead(_ comicCHead: UComicCHead,moreAction button: UIButton)
}

/**标题和更多的外壳*/
class UComicCHead: UBaseCollectionReusableView {
 
    weak var delegate: UComicCHeadDelegate?
    
    private var moreActionClosure: UComicCHeadMoreActionClosure?
    
    lazy var iconView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textColor = .black
        return tl
    }()
    
    lazy var moreButton: UIButton = {
        let mn = UIButton(type: .system)
        mn.setTitle("...", for: .normal)
        mn.setTitleColor(.lightGray, for: .normal)
        mn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        mn.addTarget(self, action: #selector(moreAction(button:)), for: .touchUpInside)
        return mn
    }()
    
    @objc func moreAction(button: UIButton){
        delegate?.comicChead(self, moreAction: button)
        guard let closure = moreActionClosure else {return}
        closure()
    }
    
    func moreActionClosure(_ closure: UComicCHeadMoreActionClosure?){
        moreActionClosure = closure
    }
    
    override func configUI() {
        
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(5)
            make.centerY.height.equalTo(iconView)
            make.width.equalTo(200)
        }
        
        addSubview(moreButton)
        moreButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        
    }
    
}
