//
//  UReadCCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2020/1/1.
//  Copyright © 2020 姚智豪. All rights reserved.
//

import UIKit
import Kingfisher

//表示一个占位符类型，可以在加载时以及加载完成时设置图像而无需获取图像。
extension UIImageView: Placeholder {}

class UReadCCell: UBaseCollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        return iw
    }()
    
    lazy var placeholder: UIImageView = {
        let pr = UIImageView(image: UIImage(named: "yaofan"))
        pr.contentMode = .center
        return pr
    }()
    
    override func configUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    var model: ImageModel? {
        didSet{
            guard let model = model else { return }
            imageView.image = nil
            imageView.kf.setImage(urlString: model.location,placeholder: placeholder)
        }
    }
    
}
