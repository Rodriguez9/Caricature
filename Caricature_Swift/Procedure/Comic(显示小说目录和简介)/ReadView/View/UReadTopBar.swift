//
//  UReadTopBar.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2020/1/3.
//  Copyright © 2020 姚智豪. All rights reserved.
//

import UIKit

class UReadTopBar: UIView {
    
    lazy var backButton: UIButton = {
        let bn = UIButton(type: .custom)
        bn.setImage(UIImage(named: "nav_back_black"), for: .normal)
        return bn
    }()
    
    lazy var titlelabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.textColor = .black
        tl.font = .systemFont(ofSize: 18)
        return tl
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(){
        
        addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.left.centerY.equalToSuperview()
        }
        
        addSubview(titlelabel)
        titlelabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))
        }
    }
    
}
