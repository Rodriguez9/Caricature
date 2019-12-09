//
//  URankTCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/2.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class URankTCell: UBaseTableViewCell {
    
    lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.clipsToBounds = true
        return iw
    }()
    
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        tl.font = UIFont.systemFont(ofSize: 18)
        return tl
    }()
    
    lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.numberOfLines = 0
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()
    
    override func configUI() {
        
        let line = UIView().then {
            $0.backgroundColor = UIColor.background
        }
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(10)
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(10)
            $0.bottom.equalTo(line.snp.top).offset(-10)
            //.multipliedBy(0.5):乘0.5
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
            $0.top.equalTo(iconView.snp.top).offset(20)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalTo(iconView.snp.bottom)
        }
    }
    
    var model:RankingModel?{
        didSet{
            guard let model = model else {return}
            iconView.kf.setImage(urlString: model.cover)
            titleLabel.text = "\(model.title ?? "")榜"
            descLabel.text = model.subTitle
        }
    }
}
