//
//  Configuration.swift
//  bird
//
//  Created by 張書涵 on 2018/3/23.
//  Copyright © 2018年 AliceChang. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint{
    static public func * (left:CGPoint,right:CGFloat) ->CGPoint{
        return CGPoint(x: left.x * right, y: left.y * right)
    }
}
