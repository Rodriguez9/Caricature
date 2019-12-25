//
//  UChapterViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/25.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

class UChapterViewController: UBaseViewController {

    private var isPositive: Bool = true
    
    var detailStatic: DetailStaticModel?
    var detailRealtiome: DetailRealtimeModel?
    
    weak var delegate: UComicViewWillEndDraggingDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: floor((screenWidth - 30)/2), height: 40)
        let cw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cw.backgroundColor = .white
        cw.delegate = self
        cw.dataSource = self
        cw.alwaysBounceVertical = true
        cw.register(supplementaryViewType: UChapterCHead.self, ofKind: UICollectionView.elementKindSectionHeader)
        cw.register(cellType: UChapterCCell.self)
        return cw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadData(){
        collectionView.reloadData()
    }
    
    override func configUI() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.usnp.edges)
        }
    }

}

extension UChapterViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailStatic?.chapter_list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: UChapterCHead.self)
        head.model = detailStatic
        head.setsortClosure { [weak self] (button) in
            if self?.isPositive == true {
                self?.isPositive = false
                button.setTitle("正序", for: .normal)
            }else{
                self?.isPositive = true
                button.setTitle("倒序", for: .normal)
            }
            self?.collectionView.reloadData()
        }
        return head
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UChapterCCell.self)
        if isPositive {
            cell.chapterStatic = detailStatic?.chapter_list?[indexPath.row]
        }else {
            cell.chapterStatic = detailStatic?.chapter_list?.reversed()[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = isPositive ? indexPath.row : ((detailStatic?.chapter_list?.count)! - indexPath.row - 1)
         let vc = UReadViewController(detailStatic: detailStatic, selectIndex: index)
               navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
