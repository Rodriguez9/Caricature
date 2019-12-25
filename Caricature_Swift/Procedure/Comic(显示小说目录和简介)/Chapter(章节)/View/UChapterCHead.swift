//
//  UChapterCHead.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/25.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

typealias UChapterCHeadSortClosure = (_ button: UIButton) ->Void

class UChapterCHead: UBaseCollectionReusableView {
    
    private var sortClosure: UChapterCHeadSortClosure?
    
    private lazy var chapterLabel: UILabel = {
        let vl = UILabel()
        vl.textColor = .gray
        vl.font = .systemFont(ofSize: 13)
        return vl
    }()
    
    private lazy var sortButton: UIButton = {
        let sn = UIButton(type: .system)
        sn.setTitle("倒序", for: .normal)
        sn.setTitleColor(.gray, for: .normal)
        sn.titleLabel?.font = .systemFont(ofSize: 13)
        sn.addTarget(self, action: #selector(sortAction(for:)), for: .touchUpInside)
        return sn
    }()
    
    //button为委托方，可以理解为谁调用该方法就是谁
    @objc private func sortAction(for button: UIButton){
        guard let sortClosure = sortClosure else { return }
        sortClosure(button)
    }
    
    func setsortClosure(_ closure: @escaping UChapterCHeadSortClosure){
        sortClosure = closure
    }
    
    override func configUI() {
        
        addSubview(sortButton)
        sortButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(44)
        }
        
        addSubview(chapterLabel)
        chapterLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(sortButton.snp.left).offset(-10)
        }
    }
    
    var model: DetailStaticModel?{
        didSet{
            guard let model = model else { return }
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            self.chapterLabel.text = "目录\(format.string(from: Date(timeIntervalSince1970: model.comic?.last_update_time ?? 0))) 更新\(model.chapter_list?.last?.name ?? "")"
        }
    }
    
}
