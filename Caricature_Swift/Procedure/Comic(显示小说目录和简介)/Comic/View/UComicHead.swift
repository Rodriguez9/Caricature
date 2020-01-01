//
//  UComicHeadCCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/10/28.
//  Copyright © 2019 姚智豪. All rights reserved.
//小说简介，点击阅读前的界面

import UIKit

class UComicHeadCCell: UBaseCollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.white
        tl.textAlignment = .center
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    override func configUI() {
        layer.cornerRadius = 3
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in make.edges.equalToSuperview()}
    }
}

//小说介绍的顶部图片
class UComicHead: UIView{
    
    private lazy var bgView: UIImageView = {
        let bw = UIImageView()
        //.isUserInteractionEnabled：一个布尔值，该值确定是否忽略用户事件并将其从事件队列中删除。
        bw.isUserInteractionEnabled = true
        bw.contentMode = .scaleAspectFill
        bw.blurView.setup(style: .dark, alpha: 1).enable()
        return bw
    }()
    
    private lazy var coverView: UIImageView = {
        let cw = UIImageView()
        cw.contentMode = .scaleAspectFill
        cw.layer.cornerRadius = 3
        cw.layer.borderWidth = 1
        cw.layer.borderColor = UIColor.white.cgColor
        return cw
    }()
    
    private lazy var nameLabel: UILabel = {
        let nl = UILabel()
        nl.textColor = UIColor.white
        nl.font = UIFont.systemFont(ofSize: 16)
        return nl
    }()
    
    private lazy var authorLabel: UILabel = {
        let al = UILabel()
        al.textColor = UIColor.white
        al.font = UIFont.systemFont(ofSize: 13)
        return al
    }()
    
    private lazy var totalLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.white
        tl.font = UIFont.systemFont(ofSize: 13)
        return tl
    }()
    
    private lazy var thmemView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: 40, height: 20)
        layout.scrollDirection = .horizontal
        let tw = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        tw.backgroundColor = UIColor.clear
        tw.dataSource = self
        tw.showsHorizontalScrollIndicator = false
        tw.register(cellType: UComicHeadCCell.self)
        return tw
    }()
    
    private var themes:[String]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(){
        //背景
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        //小说图片
        bgView.addSubview(coverView)
        coverView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0))
            make.width.equalTo(90)
            make.height.equalTo(120)
        }
        //小说名
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(coverView.snp.right).offset(20)
            //.greaterThanOrEqualToSuperview：大于等于Superview
            make.right.greaterThanOrEqualToSuperview().offset(-20)
            make.top.equalTo(coverView)
            make.height.equalTo(20)
        }
        //小说作者
        bgView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { (make) in
            make.left.height.equalTo(nameLabel)
            make.right.greaterThanOrEqualToSuperview().offset(-20)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        //点击，收藏
        bgView.addSubview(totalLabel)
        totalLabel.snp.makeConstraints {
            $0.left.height.equalTo(authorLabel)
            $0.right.greaterThanOrEqualToSuperview().offset(-20)
            $0.top.equalTo(authorLabel.snp.bottom).offset(10)
        }
        //小说主题：动作，同人
        bgView.addSubview(thmemView)
        thmemView.snp.makeConstraints {
            $0.left.equalTo(totalLabel)
            $0.height.equalTo(30)
            $0.right.greaterThanOrEqualToSuperview().offset(-20)
            $0.bottom.equalTo(coverView)
        }
    }
    
    //静态数据：名字，作者，小说封面
    var detailStatic: ComicStaticModel?{
        didSet{
            guard let detailStatic = detailStatic else {return}
            bgView.kf.setImage(urlString: detailStatic.cover, placeholder: UIImage(named: "normal_placeholder_v"))
            coverView.kf.setImage(urlString: detailStatic.cover, placeholder: UIImage(named: "normal_placeholder_v"))
            nameLabel.text = detailStatic.name
            authorLabel.text = detailStatic.author?.name
            themes = detailStatic.theme_ids ?? []
            thmemView.reloadData()
        }
    }
    
    //实时数据：点击，收藏
    var detailRealtime: ComicRealtimeModel?{
        didSet{
            guard let detailRealtime = detailRealtime else {return}
            //NSMutableAttributedString：可变的字符串对象，还包含与其文本内容的各个部分相关联的属性
            //.attributes：新字符串的属性
            let text = NSMutableAttributedString(string: "点击 收藏")
            text.insert(NSAttributedString(string: "\(detailRealtime.click_total ?? "0")",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]),at: 2)
            text.append(NSAttributedString(string: " \(detailRealtime.favorite_total ?? "0") ",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))
            totalLabel.attributedText = text
        }
    }
}

extension UComicHead: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return themes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicHeadCCell.self)
        cell.titleLabel.text = themes?[indexPath.item]
        return cell
    }
}
