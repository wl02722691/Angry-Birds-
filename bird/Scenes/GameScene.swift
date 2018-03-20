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
    
    let gameCamera = SKCameraNode()//建立遊戲鏡頭
    var panRecognizer = UIPanGestureRecognizer()
    
    
    override func didMove(to view: SKView) {
        addCamera()
        setupGestureRecognizers()
        }
    
    func setupGestureRecognizers() {
        guard let view = view else { return }
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panRecognizer)
    }
    
    func addCamera(){//gmaeCamera設定
        guard let view = view else {return}
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        camera = gameCamera //resizeFill讀取camera = gameCamera
        }
    }


extension GameScene{

    @objc func pan(sender:UIPanGestureRecognizer) {
        guard let view = view else { return }
        let translation = sender.translation(in: view)
        gameCamera.position = CGPoint(x: gameCamera.position.x - translation.x, y: gameCamera.position.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
}



