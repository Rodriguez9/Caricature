//
//  USearchTFoot.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/10/22.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

//CollectionViewCell屬性
class USearchCell: UBaseCollectionViewCell {
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textColor = .darkGray
        return tl
    }()
    
    override func configUI() {
        //邊框的寬度和顏色
        layer.borderWidth = 1
        //cgColor：与接收器颜色相对应的石英颜色参考
        layer.borderColor = UIColor.background.cgColor
        
        contentView.addSubview(titleLabel)
        //inset：相對位置，添加約束
        titleLabel.snp.makeConstraints {$0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))}
    }
}

typealias USearchTFootDidSelectIndexClosure = (_ index: Int, _ model: SearchItemModel) -> Void
    
protocol USearchTFootDelegate: class {
    func searchTFoot(_ searchTFoot: USearchTFoot, didSelectItemAt index: Int, _ model: SearchItemModel)
}

class USearchTFoot: UBaseTableViewHeaderFooterView {

    weak var delegate : USearchTFootDelegate?
    
    private var didSelectIndexClosure : USearchTFootDidSelectIndexClosure?
    
    private lazy var collectionView: UICollectionView = {
        //CollectCiew佈局類
        let lt = UCollectionViewAlignedLayout()
        //item左右間距
        lt.minimumInteritemSpacing = 10
        //item上下間距
        lt.minimumLineSpacing = 10
        //用于在部分中布置内容的边距
        lt.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //左對齊
        lt.horizontalAlignment = .left
        //自適應，集合视图中单元格的估计大小
        lt.estimatedItemSize = CGSize(width: 100, height: 40)
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor.white
        cw.dataSource = self
        cw.delegate = self
        cw.register(cellType: USearchCell.self)
        return cw
    }()
    
    //當data發生變化時，刷新collectionView
    var data: [SearchItemModel] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func configUI() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

extension USearchTFoot: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: USearchCell.self)
        cell.layer.cornerRadius = cell.bounds.height * 0.5
        cell.titleLabel.text = data[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.searchTFoot(self, didSelectItemAt: indexPath.row, data[indexPath.row])
        guard let closure = didSelectIndexClosure else {return}
        closure(indexPath.row,data[indexPath.row])
    }
    
    //Set
    func didSelectIndexClosure(_ closure:@escaping USearchTFootDidSelectIndexClosure) {
        didSelectIndexClosure = closure
    }
    
}
