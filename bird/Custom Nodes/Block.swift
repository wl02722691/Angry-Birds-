//
//  Block.swift
//  bird
//
//  Created by 張書涵 on 2018/4/11.
//  Copyright © 2018年 AliceChang. All rights reserved.
//

import SpriteKit

enum BlockType:String{
    case wood,stone,glass
}

class Block: SKSpriteNode {
    
    let type:BlockType
    var health:Int
    let damageThreshold:Int
    
    init(type:BlockType){
        self.type = type
        switch type {
        case .wood:
            health = 200
            
        case .stone:
            health = 500
        
        case .glass:
            health = 50
        }
        damageThreshold = health/2
        super.init(texture: nil, color: UIColor.clear, size: CGSize.zero)
        //這樣設定看起來很怪，但之後會在gameScene中設定完整
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatPhysicsBody(){
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.block
        physicsBody?.contactTestBitMask = PhysicsCategory.all
        physicsBody?.collisionBitMask = PhysicsCategory.all
        
    }
    
}
