//
//  UIScrollView+ParallaxHeader.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/10/5.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit
import ObjectiveC.runtime


/**
 A UIScrollView extension with a ParallaxHeader.
 */
extension UIScrollView{
    
    private struct AssociatedKeys{
        static var descriptiveName = "AssociatedKeys.DescriptiveName.parallaxHeader"
    }
    
    /**
     The parallax header.
     */
    public var parallaxHeader: ParallaxHeader{
        get{
            if let header = objc_getAssociatedObject(self,&AssociatedKeys.descriptiveName) as? ParallaxHeader{
                return header
            }
            let header = ParallaxHeader()
            self.parallaxHeader = header
            return header
        }
        set(parallaxHeader){
            parallaxHeader.scrollView = self
            objc_setAssociatedObject(self,&AssociatedKeys.descriptiveName,parallaxHeader,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}
