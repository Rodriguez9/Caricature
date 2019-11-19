//
//  UTopCCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/11/17.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UTopCCell: UBaseCollectionViewCell {
    
    private lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        return iw
    }()
    
    override func configUI() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    var model: TopModel? {
        didSet{
            guard let model = model else {return}
            iconView.kf.setImage(urlString: model.cover)
        }
    }
}
