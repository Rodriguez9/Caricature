//
//  UOtherWorksTCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/24.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UOtherWorksTCell: UBaseTableViewCell {
    
    //因为要使用预设的style所以要重写实例化方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        //accessoryType:单元应使用的标准附件视图的类型（正常状态）。
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var model : DetailStaticModel?{
        didSet{
            guard let model = model else {return}
            textLabel?.text = "其他作品"
            detailTextLabel?.text = "\(model.otherWorks?.count ?? 0)本"
            detailTextLabel?.font = .systemFont(ofSize: 15)
        }
    }
    
    
}
