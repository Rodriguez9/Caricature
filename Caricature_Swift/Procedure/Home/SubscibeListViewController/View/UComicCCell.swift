//
//  UComicCCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/3.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

enum UComicCCellStyle{
    case none
    case withTitle
    case withTitleAndDesc
}

/**图片和小说名的cell*/
class UComicCCell: UBaseCollectionViewCell {
    
    private lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.clipsToBounds = true
        return iw
    }()
    
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    private lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.font = UIFont.systemFont(ofSize: 12)
        return dl
    }()
    
    override func configUI() {
        clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.height.equalTo(25)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.height.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    var style : UComicCCellStyle = .withTitle{
        didSet{
            switch style {
            case .none:
                titleLabel.snp.updateConstraints { (make) in
                    make.bottom.equalToSuperview().offset(25)
                }
                titleLabel.isHidden = true
                descLabel.isHidden = true
            
            case .withTitle:
                titleLabel.snp.updateConstraints { (make) in
                    make.bottom.equalToSuperview().offset(-10)
                }
                titleLabel.isHidden = false
                descLabel.isHidden = true
                
            case .withTitleAndDesc:
                titleLabel.snp.updateConstraints { (make) in
                    make.bottom.equalToSuperview().offset(-25)
                }
                titleLabel.isHidden = false
                descLabel.isHidden = false
            }
        }
    }
    
    var model : ComicModel?{
        didSet{
            guard let model = model else {return}
            iconView.kf.setImage(urlString: model.cover,
                                 placeholder: (bounds.width > bounds.height) ? UIImage(named: "normal_placeholder_h") : UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name ?? model.title
            descLabel.text = model.subTitle ?? "更新至\(model.content ?? "0")"
        }
    }
    
    
    
}
