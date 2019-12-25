//
//  UGuessLikeTCell.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/24.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

typealias UGuessLikeTCellDidSelectClosure = (_ comic: ComicModel) -> Void

/**猜你喜欢界面*/
class UGuessLikeTCell: UBaseTableViewCell {

    private var didSelectClosure: UGuessLikeTCellDidSelectClosure?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .horizontal
        let cw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cw.backgroundColor = self.contentView.backgroundColor
        cw.delegate = self
        cw.dataSource = self
        cw.isScrollEnabled = false
        cw.register(cellType: UComicCCell.self)
        return cw
    }()
    
    override func configUI() {
        
        let titleLabel = UILabel().then{
            $0.text = "猜你喜欢"
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            make.height.equalTo(20)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    var model : GuessLikeModel?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
}

extension UGuessLikeTCell:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((collectionView.frame.width - 50) / 4)
        let height = collectionView.frame.height - 10
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
        cell.style = .withTitle
        //在UComicCCell里进行了image和label的设定
        cell.model = model?.comics?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let comic = model?.comics?[indexPath.row],
            let didSelectClosure = didSelectClosure else { return }
        didSelectClosure(comic)
    }
    
    //set
    func didSelectClosure(_ closure: UGuessLikeTCellDidSelectClosure?){
        didSelectClosure = closure
    }
    
}
