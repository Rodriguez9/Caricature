//
//  UComicTCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/10/28.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit
/**搜索结果界面的Cell布局*/
class UComicTCell: UBaseTableViewCell {
    
    var spinnerName: String?
    
    //封面
    private lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        //.clipsToBounds：一个布尔值，该值确定子视图是否限于视图的边界。
        iw.clipsToBounds = true
        return iw
    }()
    
    //小说名
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        return tl
    }()
    
    //副标题：作者，类型
    private lazy var subTitleLabel: UILabel = {
        let sl = UILabel()
        sl.textColor = UIColor.gray
        sl.font = UIFont.systemFont(ofSize: 14)
        return sl
    }()
    
    //简述
    private lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.numberOfLines = 3
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()
    
    //总点击率
    private lazy var tagLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.orange
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    private lazy var orderView: UIImageView = {
       let ow = UIImageView()
        ow.contentMode = .scaleAspectFit
        return ow
    }()
    
    override func configUI() {
        //separatorInset：单元格下方绘制的分隔线的插入值。
        separatorInset = .zero
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
            $0.width.equalTo(100)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
            make.top.equalTo(iconView)
        }
        
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(60)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
        }
        
        contentView.addSubview(orderView)
        orderView.snp.makeConstraints {
            $0.bottom.equalTo(iconView.snp.bottom)
            $0.height.width.equalTo(30)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalTo(orderView.snp.left).offset(-10)
            $0.height.equalTo(20)
            $0.bottom.equalTo(iconView.snp.bottom)
        }
    }
    
    var model: ComicModel?{
        didSet{
            guard let model = model else {return}
            iconView.kf.setImage(urlString: model.cover, placeholder: UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name
            subTitleLabel.text = "\(model.tags?.joined(separator: " ") ?? "") | \(model.author ?? "")"
            descLabel.text = model.description
            if spinnerName == "更新時間" {
                let comicDate = Date().timeIntervalSince(Date(timeIntervalSince1970:TimeInterval(model.conTag)))
                var tagString = ""
                if comicDate < 60 {
                    tagString = "\(Int(comicDate))秒前"
                } else if comicDate < 3600 {
                    tagString = "\(Int(comicDate / 60))分前"
                } else if comicDate < 86400 {
                    tagString = "\(Int(comicDate / 3600))小时前"
                } else if comicDate < 31536000{
                    tagString = "\(Int(comicDate / 86400))天前"
                } else {
                    tagString = "\(Int(comicDate / 31536000))年前"
                }
                tagLabel.text = "\(spinnerName!)\(tagString)"
                orderView.isHidden = true
            }else{
                var tagString = ""
                if model.conTag > 100000000 {
                    tagString = String(format: "%.1f亿", Double(model.conTag) / 100000000)
                }else if model.conTag > 10000{
                     tagString = String(format: "%.1f万", Double(model.conTag) / 10000)
                }else{
                    tagString = "\(model.conTag)"
                }
                if tagString != "0"{tagLabel.text = "\(spinnerName ?? "总点击") \(tagString)"}
                orderView.isHidden = false
            }
        }
    }
    var indexPath: IndexPath?{
        didSet{
            guard let indexPath = indexPath else {return}
            if indexPath.row == 0 {orderView.image = UIImage(named: "rank_frist")}
            else if indexPath.row == 1 {orderView.image = UIImage(named: "rank_second")}
            else if indexPath.row == 2 {orderView.image = UIImage(named: "rank_third")}
            else {orderView.image = nil}
        }
    }
}
