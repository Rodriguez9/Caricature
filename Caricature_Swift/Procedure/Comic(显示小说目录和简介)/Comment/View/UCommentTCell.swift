//
//  UCommentTCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/27.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UCommentTCell: UBaseTableViewCell {

    private lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.layer.cornerRadius = 20
        iw.layer.masksToBounds = true
        return iw
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let nl = UILabel()
        nl.textColor = .gray
        nl.font = .systemFont(ofSize: 13)
        return nl
    }()
    
    private lazy var contentTextView: UITextView = {
        let cw = UITextView()
        cw.isUserInteractionEnabled = false
        cw.font = .systemFont(ofSize: 13)
        cw.textColor = .black
        return cw
    }()

    override func configUI() {
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10)
            make.height.width.equalTo(40)
        }
        
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right)
            make.top.equalTo(iconView)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(15)
        }
        
        contentView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { (make) in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            make.left.right.equalTo(nickNameLabel)
            make.bottom.greaterThanOrEqualToSuperview().offset(-10)
        }
        
    }
    
    var viewModel:  UCommentViewModel?{
        didSet{
            guard let model = viewModel else { return }
            iconView.kf.setImage(urlString: model.model?.face)
            nickNameLabel.text = model.model?.nickname
            contentTextView.text = model.model?.content_filter
        }
    }
    
}


