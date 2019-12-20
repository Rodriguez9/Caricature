//
//  USpecialTCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/18.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class USpecialTCell: UBaseTableViewCell {

    private  lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = .black
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()

    private lazy var coverView: UIImageView = {
        let cw = UIImageView()
        cw.contentMode = .scaleAspectFill
        cw.layer.cornerRadius = 5
        cw.layer.masksToBounds = true
        return cw
    }()
    
    private lazy var tipLabel: UILabel = {
        let tl = UILabel()
        tl.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        tl.textColor = .white
        tl.font = .systemFont(ofSize: 9)
        return tl
    }()
    
    override func configUI() {
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            make.height.equalTo(40)
        }
        
        contentView.addSubview(coverView)
        coverView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10))
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        coverView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        let line = UIView().then {
            $0.backgroundColor = .background
        }
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    var model : ComicModel?{
        didSet{
            guard let model = model else {return}
            titleLabel.text = model.title
            coverView.kf.setImage(urlString: model.cover)
            tipLabel.text = "    \(model.subTitle ?? "")"
        }
    }
}
