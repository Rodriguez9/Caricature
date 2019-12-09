//
//  URankCCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/11/17.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

/**分类界面的cell*/
class URankCCell: UBaseCollectionViewCell {
    
    private lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        return iw
    }()
    
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textColor = .black
        return tl
    }()
    
    override func configUI() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
    
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints{
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(0.75)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom)
        }
    }
    
    //涉及到数据更新
    var model: RankingModel?{
        didSet{
            guard let model = model else { return }
            iconView.kf.setImage(urlString: model.cover)
            titleLabel.text = model.sortName
        }
    }
}
