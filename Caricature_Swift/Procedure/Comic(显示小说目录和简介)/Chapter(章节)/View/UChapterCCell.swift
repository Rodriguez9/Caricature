//
//  UChapterCCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/25.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UChapterCCell: UBaseCollectionViewCell {
    lazy var nameLabel: UILabel = {
        let nl = UILabel()
        nl.font = UIFont.systemFont(ofSize: 16)
        return nl
    }()
    
    override func configUI() {
        contentView.backgroundColor = .white
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
    }
    
    var chapterStatic: ChapterStaticModel?{
        didSet{
            guard let chapterStatic = chapterStatic else { return }
            nameLabel.text = chapterStatic.name
        }
    }
    
    
}
