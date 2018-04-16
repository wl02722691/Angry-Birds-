//
//  Bird.swift
//  bird
//
//  Created by 張書涵 on 2018/3/25.
//  Copyright © 2018年 AliceChang. All rights reserved.
//

import SpriteKit

enum BirdType:String{
    case red,blue,yellow,gray
}

class Bird: SKSpriteNode {
    
    let birdType:BirdType
    var grabbed = false
    var flying = false{
        didSet{//在屬性發生變化後，更新一下flying的屬性
            if flying{
                physicsBody?.isDynamic = true
            }
        }
    }
    
    init(type:BirdType){
        
        birdType = type
    
        let texture = SKTexture(imageNamed: type.rawValue + "1")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)has not been implemanted")
    }
}
