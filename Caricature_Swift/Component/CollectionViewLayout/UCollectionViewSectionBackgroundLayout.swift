//
//  UCollectionViewSectionBackgroundLayout.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/10/13.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

private let SectionBackground = "UCollectionReusableView"

//
protocol UCollectionViewSectionBackgroundLayoutDelegateLayout:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        backgroundColorForSectionAt section: Int) -> UIColor
}

extension UCollectionViewSectionBackgroundLayoutDelegateLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        backgroundColorForSectionAt section: Int) -> UIColor {
        return collectionView.backgroundColor ?? UIColor.clear
    }
}

//UICollectionViewLayoutAttributes：一个布局对象，用于管理集合视图中给定项目的与布局相关的属性
private class UCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes{
    var backgroundColor = UIColor.white
    //返回一个新实例，该实例是接收者的副本
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! UCollectionViewLayoutAttributes
        copy.backgroundColor = self.backgroundColor
        return copy
    }
    //返回一个布尔值，该值指示接收方和给定对象是否相等
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? UCollectionViewLayoutAttributes else {
            return false
        }
        /*
         guard self.backgroundColor.isEqual(rhs.backgroundColor) else {
         return false
         }
         */
        
        if !self.backgroundColor.isEqual(rhs.backgroundColor) {
            return false
        }
        return super.isEqual(object)
    }
}

//UICollectionReusableView：定义所有单元格行为的视图以及由集合视图提供的补充视图
private class UCollectionReusableView: UICollectionReusableView{
    
    //将指定的布局属性应用于视图
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let attr = layoutAttributes as? UCollectionViewLayoutAttributes else {
            return
        }
        
        self.backgroundColor = attr.backgroundColor
    }
}

//UICollectionViewFlowLayout：一个具体的布局对象，将项目组织到一个网格中，每个部分具有可选的页眉和页脚视图。
class UCollectionViewSectionBackgroundLayout: UICollectionViewFlowLayout{
    
    private var decorationViewAttrs: [UICollectionViewLayoutAttributes] = []
    
    override init(){
        super.init()
        setup()
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(){
        //classForCoder在编码期间被子类重写以替代其自身以外的类
        self.register(UICollectionReusableView.classForCoder(), forDecorationViewOfKind: SectionBackground)
    }
    
    override func prepare() {
        super.prepare()
        //numberOfSections：返回集合视图显示的节数
        guard let numberOfSections = self.collectionView?.numberOfSections,
            let delegate = self.collectionView?.delegate as? UCollectionViewSectionBackgroundLayoutDelegateLayout
        else {return}
        
        self.decorationViewAttrs.removeAll()
        for section in 0..<numberOfSections {
            //索引路径中的每个索引代表从树中一个节点到另一个更深节点的子节点数组的索引
            let indexPath = IndexPath(item: 0, section: section)
            //numberOfItems：返回指定部分中的项目数
            //layoutAttributesForItem：返回指定索引路径下项目的布局属性
            guard let numberOfItems = collectionView?.numberOfItems(inSection: section),
                numberOfSections > 0,
                let firstItem = layoutAttributesForItem(at: indexPath),
                let lastItem = layoutAttributesForItem(at: IndexPath(item: numberOfSections - 1, section: section))
                else{ continue }
            //sectionInset：用于在部分中布置内容的边距
            var inset = self.sectionInset
            //该代理来自于UICollectionViewDelegateFlowLayout
            if let delegateInset = delegate.collectionView?(self.collectionView!, layout: self,insetForSectionAt: section) {
                inset = delegateInset
            }
            //返回两个矩形的并集
            var sectionFrame = firstItem.frame.union(lastItem.frame)
            sectionFrame.origin.x = inset.left
            sectionFrame.origin.y -= inset.top
            //layoutAttributesForSupplementaryView：返回指定补充视图的布局属性
            //elementKindSectionHeader：标识给定节的标题的补充视图
            //elementKindSectionFooter：标识给定节的页脚的补充视图
            let headLayout = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            let footLayout = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath)
            
            if self.scrollDirection == .horizontal{
                sectionFrame.origin.y -= headLayout?.frame.height ?? 0
                sectionFrame.size.width += inset.left + inset.right
                sectionFrame.size.height = (collectionView?.frame.height ?? 0) + (headLayout?.frame.height ?? 0) + (footLayout?.frame.height ?? 0)
            }else{
                sectionFrame.origin.y -= headLayout?.frame.height ?? 0
                sectionFrame.size.width = collectionView?.frame.width ?? 0
                sectionFrame.size.height = sectionFrame.size.height + inset.top + inset.bottom + (headLayout?.frame.height ?? 0) + (footLayout?.frame.height ?? 0)
            }
            
            let attr = UCollectionViewLayoutAttributes(forDecorationViewOfKind: SectionBackground, with: IndexPath(item: 0, section: section))
            attr.frame = sectionFrame
            attr.zIndex = -1
            attr.backgroundColor = delegate.collectionView(self.collectionView!, layout: self, backgroundColorForSectionAt: section)
            self.decorationViewAttrs.append(attr)
        }
    }
    
    //返回指定矩形中所有单元格和视图的布局属性
    //filter过滤器
    //intersects：返回两个矩形是否相交
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = super.layoutAttributesForElements(in: rect)
        attrs?.append(contentsOf: decorationViewAttrs.filter{
            return rect.intersects($0.frame)
        })
        return attrs
    }
    
    //返回指定装饰视图的布局属性
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == SectionBackground {
            return decorationViewAttrs[indexPath.section]
        }
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
    }
}
