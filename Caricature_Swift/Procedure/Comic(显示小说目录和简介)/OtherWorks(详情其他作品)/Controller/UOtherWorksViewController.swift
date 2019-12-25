//
//  UOtherWorksViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/25.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit
/**显示小说目录和简介界面的其他作品部分*/
class UOtherWorksViewController: UBaseViewController {
    
    var otherWorks: [OtherWorkModel]?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        let cw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cw.backgroundColor = .white
        cw.delegate = self
        cw.dataSource = self
        cw.register(cellType: UOtherWorksCCell.self)
        return cw
    }()
    
    convenience init(otherWorks: [OtherWorkModel]?) {
        self.init()
        self.otherWorks = otherWorks
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.usnp.edges)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.title = "其他作品"
    }

}

extension UOtherWorksViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherWorks?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((collectionView.frame.width - 40))
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UOtherWorksCCell.self)
        cell.model = otherWorks?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //取消选择指定索引处的项目,如果allowSelection属性为false，则调用此方法无效。此方法不会导致任何与选择相关的委托方法被调用。
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let model = otherWorks?[indexPath.row] else { return  }
        let vc = UComicViewController(comicid: model.comicId)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
