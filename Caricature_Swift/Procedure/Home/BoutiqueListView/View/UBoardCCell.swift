//
//  UBoardCCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/12.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

/**广告牌*/
class UBoardCCell: UBaseCollectionViewCell {
    
    private lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.clipsToBounds = true
        return iw
    }()
    
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = .black
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textAlignment = .center
        return tl
    }()
    
    override func configUI() {
        clipsToBounds = true
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom)
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.height.equalTo(20)
        }
    }
    
    var model: ComicModel? {
        didSet{
            guard let model = model else {return}
            iconView.kf.setImage(urlString: model.cover)
            titleLabel.text = model.name
        }
    }
}
