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
            health = 140
            
        case .stone:
            health = 500
        
        case .glass:
            health = 50
        }
        damageThreshold = health/2
        let texture = SKTexture(imageNamed: type.rawValue)
        super.init(texture: texture, color: UIColor.clear, size: CGSize.zero)
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
    
    func impact(with force:Int){
        health -= force
        print(health)
        if health<1{//如果生命值小於1就消失
            removeFromParent()
        }else if health < damageThreshold{//如果生命值小於damageThreshold就變紅
            let brokenTexture = SKTexture(imageNamed: type.rawValue + "Broken")
            texture = brokenTexture
        }
    }
    
}
