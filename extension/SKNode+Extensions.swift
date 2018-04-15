//
//  SKNode+Extensions.swift
//  bird
//
//  Created by 張書涵 on 2018/4/15.
//  Copyright © 2018年 AliceChang. All rights reserved.
//

import SpriteKit

extension SKNode{
    func aspectScale(to size:CGSize,width: Bool,multiplier:CGFloat){
        let scale = width ? (size.width * multiplier) / self.frame.size.width :
        (size.height * multiplier) / self.frame.size.height
        self.setScale(scale)
        
    }
}

