//
//  UCommentViewModel.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/12/28.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import Foundation
import UIKit

class UCommentViewModel {

    var model: CommentModel?
    var height: CGFloat = 0
    
    convenience init(model: CommentModel) {
        self.init()
        self.model = model
        
        //只为了测量model.content_filter所需要的UITextView的最合适高度，与界面无关
        let tw = UITextView().then { $0.font = .systemFont(ofSize: 13)}
        tw.text = model.content_filter
        //.sizeThatFits:要求视图计算并返回最适合指定大小的大小,但不会改变原来的View的尺寸
        let height = tw.sizeThatFits(CGSize(width: screenWidth - 70, height: CGFloat.infinity)).height
        //返回两个可比较值中的较大者。
        self.height = max(60, height + 45)
    }
    
    required init() {}
}
