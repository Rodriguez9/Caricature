//
//  UEmptyDataSet.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/10/2.
//  Copyright © 2019 姚智豪. All rights reserved.
//

/*
 EmptyDataSet_Swift下拉式UITableView / UICollectionView超类类别，用于在视图无内容可显示时显示空数据集
 objc_getAssociatedObject,objc_setAssociatedObject:作用是当属性和全局变量不能使用的时候进行扩展属性,类别是不可以添加属性的,使用分类可以为没有源码的类增加方法，但是一般不能增加属性
 */

import Foundation
import EmptyDataSet_Swift

extension UIScrollView{
    
    private struct AssociatedKeys {
        static var uemptyKey: Void?
    }
    
    var uempty: UEmptyView?{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.uemptyKey) as? UEmptyView
        }
        set{
            self.emptyDataSetDelegate = newValue
            self.emptyDataSetSource = newValue
            objc_setAssociatedObject(self, &AssociatedKeys.uemptyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

class UEmptyView: EmptyDataSetSource, EmptyDataSetDelegate {
    
    var image: UIImage?
    
    var allowShow: Bool = false
    var verticalOffset: CGFloat = 0
    
    private var tapClosure: (()->Void)?
    
    init(image: UIImage? = UIImage(named: "nodata"), verticalOffset: CGFloat = 0, tapClosure: (() -> Void)?) {
        self.image = image
        self.verticalOffset = verticalOffset
        self.tapClosure = tapClosure
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return verticalOffset
    }
    
    internal func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return image
    }
    
    internal func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return allowShow
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        guard let tapClosure = tapClosure else {return}
        tapClosure()
    }
    
}
