//
//  StringExtension.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/9/6.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import Foundation

extension String {
    public func substring(from index: Int) -> String {
        if self.count > index{
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        }else{
            return self
        }
    }
}
