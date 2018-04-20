//
//  Configuration.swift
//  bird
//
//  Created by 張書涵 on 2018/3/23.
//  Copyright © 2018年 AliceChang. All rights reserved.
//

import Foundation
import CoreGraphics

struct Zposition {
    static let background:CGFloat = 0
    static let obstacles:CGFloat = 1
    static let hudBackground:CGFloat = 10
    static let hudLabel:CGFloat = 11
}

struct PhysicsCategory{
    
    static let none:UInt32 = 0
    static let all:UInt32 = UInt32.max
    static let edge:UInt32 = 0x1
    static let bird:UInt32 = 0x1 << 1
    static let block:UInt32 = 0x1 << 2
    
}

extension CGPoint{//讓+ - * 的CGPoint可以轉
    static public func + (left: CGPoint,right:CGPoint) -> CGPoint{
        return CGPoint(x: left.x + right.x , y: left.y + right.y)
    }
    
    static public func - (left:CGPoint, right:CGPoint) -> CGPoint{
        return CGPoint(x: left.x - right.x , y: left.y - right.y)
    }
    
    static public func * (left:CGPoint,right:CGFloat) ->CGPoint{
        return CGPoint(x: left.x * right, y: left.y * right)
    }
}


