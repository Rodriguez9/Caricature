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
    
    /**显示空数据视图元件*/
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

/**显示空数据视图*/
class UEmptyView {
    //展示的图片
    var image: UIImage?
    //是否显示
    var allowShow: Bool = false
    //图片的上线偏移量，用来调整图片的位置,默认为0，放在中间
    var verticalOffset: CGFloat = 0
    
    private var tapClosure: (()->Void)?
    
    init(image: UIImage? = UIImage(named: "nodata"), verticalOffset: CGFloat = 0, tapClosure: (() -> Void)?) {
        self.image = image
        self.verticalOffset = verticalOffset
        self.tapClosure = tapClosure
    }
}

extension UEmptyView: EmptyDataSetSource, EmptyDataSetDelegate{
    
    //返回图片偏移量
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return verticalOffset
    }
     
    //返回展示图片
    internal func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return image
    }
    
    //显示状态
    internal func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return allowShow
    }
    
    //点击时回调
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        guard let tapClosure = tapClosure else {return}
        tapClosure()
    }
}
