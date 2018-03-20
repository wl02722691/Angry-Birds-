//
//  GameScene.swift
//  bird
//
//  Created by 張書涵 on 2018/3/19.
//  Copyright © 2018年 AliceChang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let gameCamera = SKCameraNode()//遊戲鏡頭
    
    override func didMove(to view: SKView) {
        
        }
    
    func addCamera(){//gmaeCamera設定
        guard let view = view else { return }
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        camera = gameCamera
        }
    }
