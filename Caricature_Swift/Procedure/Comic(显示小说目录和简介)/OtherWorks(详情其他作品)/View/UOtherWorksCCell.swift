//
//  UOtherWorksCCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/25.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UOtherWorksCCell: UBaseCollectionViewCell {
    
    private lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.clipsToBounds = true
        return iw
    }()
    
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = .black
        tl.font = .systemFont(ofSize: 14)
        return tl
    }()
    
    private lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = .gray
        dl.font = .systemFont(ofSize: 12)
        return dl
    }()
    
    override func configUI() {
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.height.equalTo(20)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.height.equalTo(25)
            make.bottom.equalTo(descLabel.snp.top)
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top)
        }
        
    }
    
    var model: OtherWorkModel?{
        didSet{
            guard let model = model else { return }
            iconView.kf.setImage(urlString: model.coverUrl,
                                 placeholder: (bounds.width > bounds.height) ?
                                    UIImage(named: "normal_placeholder_h") :
                                    UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name
            descLabel.text = "更新至\(model.passChapterNum)话"
        }
    }
    
    
}
