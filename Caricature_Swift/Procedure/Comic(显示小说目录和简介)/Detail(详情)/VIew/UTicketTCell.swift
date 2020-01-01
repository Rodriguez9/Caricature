//
//  UTicketTCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/24.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UTicketTCell: UBaseTableViewCell {

    var model : DetailRealtimeModel?{
        didSet{
            guard let model = model else { return }
            //可变的字符串对象，还包含与其文本内容的各个部分相关联的属性
            let text = NSMutableAttributedString(string: "本月月票       |     累计月票  ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
            text.insert(NSAttributedString(string: "\(model.comic?.monthly_ticket ?? "")", attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]),at: 6)
            text.append(NSAttributedString(string: "\(model.comic?.total_ticket ?? "")", attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))

            textLabel?.attributedText = text
            textLabel?.textAlignment = .center
        }
    }
    

}
