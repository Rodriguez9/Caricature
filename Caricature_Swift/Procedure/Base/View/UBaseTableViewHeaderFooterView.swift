//
//  UBaseTableViewHeaderFooterView.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/8/13.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit
import Reusable
import SnapKit

//放置在表部分顶部或底部的可重用视图，以显示该部分的其他信息。
class UBaseTableViewHeaderFooterView: UITableViewHeaderFooterView,Reusable{

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configUI()
    }

    open func configUI(){
        
    }
    
}
