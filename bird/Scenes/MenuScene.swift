//
//  MenuScene.swift
//  bird
//
//  Created by 張書涵 on 2018/4/16.
//  Copyright © 2018年 AliceChang. All rights reserved.
//

import SpriteKit
class MenuScene: SKScene {

    var SceneManagerDelegate:SceneManagerDelegate?
    override func didMove(to view: SKView) {
        setupMenu()
    }
    
    func setupMenu(){
        let button = SpriteKitButton(defaultButtonImage: "playButton", action: goToLevelScene, index: 0)
        //按下按鈕就會執行goToLevelScene到LevelScene
        button.position = CGPoint(x: frame.midX, y: frame.midY)
        button.aspectScale(to: frame.size, width: false, multiplier: 0.2)
        addChild(button)
    }
    
    func goToLevelScene(_:Int){
        SceneManagerDelegate?.presentLevelScene()
    }
}
