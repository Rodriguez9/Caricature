//
//  UUpdateTCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/21.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UUpdateTCell: UBaseTableViewCell {
    
    private lazy var coverView: UIImageView = {
        let cw = UIImageView()
        cw.contentMode = .scaleAspectFill
        cw.backgroundColor = .background
        cw.layer.cornerRadius = 5
        cw.layer.masksToBounds = true
        return cw
    }()
    
    private lazy var tipLabel: UILabel = {
        let tl = UILabel()
        tl.backgroundColor = UIColor.background.withAlphaComponent(0.5)
        tl.textColor = .white
        tl.font = .systemFont(ofSize: 9)
        return tl
    }()
    
    override func configUI() {
        
        contentView.addSubview(coverView)
        coverView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10))
        }
        
        coverView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        
        let line = UIView().then{
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
            tipLabel.text = "     \(model.description ?? "")"
            coverView.kf.setImage(urlString: model.cover)
        }
    }
}
