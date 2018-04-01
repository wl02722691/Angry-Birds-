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
    
        let color:UIColor!
      
        switch type {
        case .red:
            color = UIColor.red
        case .blue:
            color = UIColor.blue
        case .yellow:
            color = UIColor.yellow
        case .gray:
            color = UIColor.gray
        }
        super.init(texture: nil, color: color, size: CGSize(width: 40.0, height: 40.0))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)has not been implemanted")
    }
}
