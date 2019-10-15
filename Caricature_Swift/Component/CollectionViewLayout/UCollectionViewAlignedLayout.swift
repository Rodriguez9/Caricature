//
//  UCollectionViewAlignedLayout.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/10/12.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit

//校准
protocol Alignment {}

//橫向校准
public enum HorizontalAlignment: Alignment{
    case left
    case justified
    case right
}

//豎向校准
public enum VerticalAlignment: Alignment{
    case top
    case center
    case bottom
}

//校准轴
private struct AlignmentAxis<A: Alignment>{
    let alignment: A
    let postition: CGFloat
}

//CollectionView佈局校準
public class UCollectionViewAlignedLayout: UICollectionViewFlowLayout {
    
    public var horizontalAlignment: HorizontalAlignment = .justified
    
    public var verticalAlignment: VerticalAlignment = .center
    
    fileprivate var alignmentAxis: AlignmentAxis<HorizontalAlignment>? {
        switch  horizontalAlignment {
        case .left:
            return AlignmentAxis(alignment: HorizontalAlignment.left, postition: sectionInset.left)
        case .right:
            guard let collectionViewWidth = collectionView?.frame.size.width else{
                return nil
            }
            return AlignmentAxis(alignment: HorizontalAlignment.right, postition: collectionViewWidth - sectionInset.right)
        default:
            return nil
        }
    }
    
    //直线的垂直对准轴
    private func verticalAlignmentAxisForLine(with layoutAttributes:[UICollectionViewLayoutAttributes]) -> AlignmentAxis<VerticalAlignment>?{
        
        guard let firstAttributes = layoutAttributes.first else {
            return nil
        }
        
        switch verticalAlignment {
        case .top:
            let minY = layoutAttributes.reduce(CGFloat.greatestFiniteMagnitude){
                min($0, $1.frame.minY)
            }
            return AlignmentAxis(alignment: .top, postition: minY)
        case .bottom:
            let maxY = layoutAttributes.reduce(0){max($0, $1.frame.maxY)}
            return AlignmentAxis(alignment: .bottom, postition: maxY)
        default:
            let centerY = firstAttributes.center.y
            return AlignmentAxis(alignment: .center, postition: centerY)
        }
    }
    
    //顯示內容寬度
    private var contentWidth: CGFloat? {
        guard let collectionViewWidth = collectionView?.frame.size.width else {
            return nil
        }
        return collectionViewWidth - sectionInset.left - sectionInset.right
    }
    
    public init(horizontalAlignment: HorizontalAlignment = .justified, verticalAlignment: VerticalAlignment = .center) {
        super.init()
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else{
            return nil
        }
        if horizontalAlignment != .justified {
            layoutAttributes.alignHorizontally(collectionViewLayout: self)
        }
        
        if verticalAlignment != .center {
            layoutAttributes.alignVertically(collectionViewLayout: self)
        }
        return layoutAttributes
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = copy(super.layoutAttributesForElements(in: rect))
        layoutAttributesObjects?.forEach({ (layoutAttributes) in
            setFrame(forLayoutAttributes: layoutAttributes)
        })
        return layoutAttributesObjects
    }
    
    //設置Frame
    //representedElementCategory:可以使用此属性中的值来区分布局属性是用于单元格视图，补充视图还是装饰视图
    //layoutAttributesForItem:返回指定索引路径下项目的布局信息
    private func setFrame(forLayoutAttributes layoutAttributes:UICollectionViewLayoutAttributes){
        if layoutAttributes.representedElementCategory == .cell {
            let indexPath = layoutAttributes.indexPath
            if let newFrame = layoutAttributesForItem(at: indexPath)?.frame{
                layoutAttributes.frame = newFrame
            }
        }
    }
    
    //初始佈局属性
    fileprivate func originalLayoutAttribute(forItemAt indexPath: IndexPath) -> UICollectionViewLayoutAttributes?{
        return super.layoutAttributesForItem(at: indexPath)
    }
    
    //intersects两个矩形是否相交
    fileprivate func isFrame(for firstItemAttributes: UICollectionViewLayoutAttributes,isSameLineAsFrameFor secondItemAttributes: UICollectionViewLayoutAttributes) -> Bool{
        guard let lineWidth = contentWidth else {
            return false
        }
        let firstItemFrame = firstItemAttributes.frame
        let lineFrame = CGRect(x: sectionInset.left,
                               y: firstItemFrame.origin.y,
                               width: lineWidth,
                               height: firstItemFrame.size.height)
        return lineFrame.intersects(secondItemAttributes.frame)
    }
    
    //UICollectionViewLayoutAttributes:一个布局对象，用于管理集合视图中给定项目的与布局相关的属性
    //layoutAttributesForElements:返回指定矩形中所有单元格和视图的布局属性
    //返回佈局屬性
    fileprivate func layoutAttributes(forItemsInLineWith layoutAttributes: UICollectionViewLayoutAttributes)-> [UICollectionViewLayoutAttributes]{
        guard let lineWidth = contentWidth else {
            return [layoutAttributes]
        }
        var lineFrame = layoutAttributes.frame
        lineFrame.origin.x = sectionInset.left
        lineFrame.size.width = lineWidth
        return super.layoutAttributesForElements(in: lineFrame) ?? []
    }
    
    //垂直对齐轴
    fileprivate func verticalAlignmentAxis(for currentLayoutAttributes:UICollectionViewLayoutAttributes)->AlignmentAxis<VerticalAlignment>{
        let layoutAttributesInLine = layoutAttributes(forItemsInLineWith: currentLayoutAttributes)
        return verticalAlignmentAxisForLine(with: layoutAttributesInLine)!
    }
    
    private func copy(_ layoutAttributesArray: [UICollectionViewLayoutAttributes]?) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributesArray?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
    }
}

fileprivate extension UICollectionViewLayoutAttributes {
    
    private var currentSection: Int {
        return indexPath.section
    }
    
    private var currentItem: Int {
        return indexPath.item
    }
    
    private var precedingIndexPath: IndexPath {
        return IndexPath(item: currentItem - 1, section: currentSection)
    }
    
    private var followingIndexPath: IndexPath{
         return IndexPath(item: currentItem + 1, section: currentSection)
    }
    
    func isRepresentingFirstItemInLine(collectionViewLayout: UCollectionViewAlignedLayout) -> Bool {
        if currentSection <= 0 {
            return true
        }
        else {
            if let layoutAttributesForPrecedingItem = collectionViewLayout.originalLayoutAttribute(forItemAt: precedingIndexPath){
                return !collectionViewLayout.isFrame(for: self, isSameLineAsFrameFor: layoutAttributesForPrecedingItem)
            }
            else{
                return true
            }
        }
    }
    
    func isRepresentingLastItemInLine(collectionViewLayout: UCollectionViewAlignedLayout) -> Bool {
        guard let itemCount = collectionViewLayout.collectionView?.numberOfItems(inSection: currentSection) else {
            return false
        }
        if currentItem >= itemCount - 1 {
            return true
        }
        else{
            if let layoutAttributesForFollowingItem = collectionViewLayout.originalLayoutAttribute(forItemAt: followingIndexPath){
                return !collectionViewLayout.isFrame(for: self, isSameLineAsFrameFor: layoutAttributesForFollowingItem)
            }
            else{
                return true
            }
        }
    }
    
    func align(toAlignmentAxis alignmentAxis: AlignmentAxis<HorizontalAlignment>) {
        switch alignmentAxis.alignment {
        case .left:
            frame.origin.x = alignmentAxis.postition
        case .right:
            frame.origin.x = alignmentAxis.postition - frame.size.width
        default:
            break
        }
    }
    
    func align(toAlignmentAxis alignmentAxis: AlignmentAxis<VerticalAlignment>) {
        switch alignmentAxis.alignment {
        
        case .top:
            frame.origin.y = alignmentAxis.postition
        case .bottom:
            frame.origin.y = alignmentAxis.postition - frame.size.height
        default:
            center.y = alignmentAxis.postition
        }
    }
    
    private func alignToPrecedingItem(collectionViewLayout: UCollectionViewAlignedLayout) {
        let itemSpacing = collectionViewLayout.minimumInteritemSpacing
        
        if let precedingItemAttributes = collectionViewLayout.layoutAttributesForItem(at: precedingIndexPath) {
            frame.origin.x = precedingItemAttributes.frame.maxX + itemSpacing
        }
    }
    
    private func alignToFollowingItem(collectionViewLayout: UCollectionViewAlignedLayout) {
        let itemSpacing = collectionViewLayout.minimumInteritemSpacing
        
        if let followingItemAttributes = collectionViewLayout.layoutAttributesForItem(at: followingIndexPath) {
            frame.origin.x = followingItemAttributes.frame.minX - itemSpacing - frame.size.width
        }
    }
    
    func alignHorizontally(collectionViewLayout: UCollectionViewAlignedLayout) {
        
        guard let alignementAxis = collectionViewLayout.alignmentAxis else {
            return
        }
        
        switch collectionViewLayout.horizontalAlignment {
        case .left:
            if isRepresentingFirstItemInLine(collectionViewLayout: collectionViewLayout){
                align(toAlignmentAxis: alignementAxis)
            }else{
                alignToFollowingItem(collectionViewLayout: collectionViewLayout)
            }
        case .right:
            if isRepresentingFirstItemInLine(collectionViewLayout: collectionViewLayout){
                align(toAlignmentAxis: alignementAxis)
            }else{
                alignToFollowingItem(collectionViewLayout: collectionViewLayout)
            }
        default:
            return
        }
    }
    
    func alignVertically(collectionViewLayout: UCollectionViewAlignedLayout) {
        let alignmentAxis = collectionViewLayout.verticalAlignmentAxis(for: self)
        align(toAlignmentAxis: alignmentAxis)
    }
    
}
