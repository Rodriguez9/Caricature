//
//  UBaseCollectionViewCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/8/19.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit
import Reusable

class UBaseCollectionViewCell: UICollectionViewCell,Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configUI() {}
    
}
