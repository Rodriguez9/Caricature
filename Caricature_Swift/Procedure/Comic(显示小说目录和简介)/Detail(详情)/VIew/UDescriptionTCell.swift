//
//  UDescriptionTCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/23.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

/**作品介绍Cell*/
class UDescriptionTCell: UBaseTableViewCell {
    
    lazy var textView: UITextView = {
        let tw = UITextView()
        tw.isUserInteractionEnabled = false
        tw.textColor = .gray
        tw.font = UIFont.systemFont(ofSize: 15)
        return tw
    }()
    
    override func configUI() {
        let titleLabel = UILabel().then {
            $0.text = "作品介绍"
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 20))
            make.height.equalTo(20)
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.usnp.bottom)
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }
    }
    
    var model : DetailStaticModel?{
        didSet{
            guard let model = model else { return }
            textView.text = " [\(model.comic?.cate_id ?? "")] \(model.comic?.description ?? "")"
        }
    }
    
    class func height(for detailStatic: DetailStaticModel?)->CGFloat {
        var height: CGFloat = 55.0
        guard let model = detailStatic else { return height }
        let textView = UITextView().then {
            $0.font = .systemFont(ofSize: 15)
        }
        textView.text = " [\(model.comic?.cate_id ?? "")] \(model.comic?.description ?? "")"
        height += textView.sizeThatFits(CGSize(width: screenWidth - 30, height: CGFloat.infinity)).height
        return height
    }
}
